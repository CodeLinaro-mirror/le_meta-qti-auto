/*===========================================================================
Copyright (c) 2021 The Linux Foundation. All rights reserved.

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License version 2 and
only version 2 as published by the Free Software Foundation.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
============================================================================ */

#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/platform_device.h>
#include <linux/ptp_clock_kernel.h>
#include <linux/socket.h>
#include <net/sock.h>
#include <linux/net.h>
#include <linux/qmi.h>
#include <linux/gpio.h>
#include <linux/of_gpio.h>
#include <linux/interrupt.h>
#include <linux/timekeeping.h>

#define QSOCKET_QC_GPTP_TIME_SERVICE_ID 5010
#define QSOCKET_QC_GPTP_TIME_INSTANCE_ID 10
#define OFFSET_ARRAY_SIZE 10
#define PREV_OFFSET_WEIGHTAGE 9
#define OFFSET_WEIGHTAGE_MAX 10

struct rgptp_prv_data {
    struct platform_device *pdev;
    struct device *dev;
    struct qmi_handle cntl_qmi;
    struct socket *hdl;
    struct sockaddr_qrtr remote_addr;
    unsigned int  toggle_gpio;
    int gpio_irq;
    spinlock_t ptp_lock;
    struct ptp_clock *ptp_clock;
    struct ptp_clock_info ptp_clock_ops;
    s64 irq_systime_ns;
    u64 rptp_time_ns;
    s64 offset_ns;
    unsigned int irq_cnt;
    unsigned int ptp_cnt;
    bool rptp_sync;
    bool modem_sync;
    s64 offset_array[OFFSET_ARRAY_SIZE];
    int offset_index;
};

struct sync_data {
    uint64_t ptp_time;
    bool sync;
};

static s64 find_max_offset(struct rgptp_prv_data *priv_data)
{
    s64 max_offset;
    int i;
    max_offset = priv_data->offset_array[0];

    for (i = 1; i < OFFSET_ARRAY_SIZE; i++) {
        if ((priv_data->offset_array[i]) && (max_offset < priv_data->offset_array[i])) {
            max_offset = priv_data->offset_array[i];
        }
    }

    return max_offset;
}

static int rgptp_get_time(struct ptp_clock_info *ptp, struct timespec64 *ts)
{
    struct rgptp_prv_data *info =
        container_of(ptp, struct rgptp_prv_data, ptp_clock_ops);
    unsigned long flags;
    struct timespec cur_sys_time;
    u64 ns = 0;
    u64 cur_systime_ns = 0;
    u32 reminder = 0;

    if (info) {
        if (info->modem_sync == false) {
            return -1;
        }
    } else {
        return -1;
    }

    getnstimeofday(&cur_sys_time);
    cur_systime_ns = timespec_to_ns(&cur_sys_time);
    ns = cur_systime_ns + info->offset_ns;
    dev_dbg(info->dev, "rgptp_get_time rgptp time %llu cur_systime_ns : %llu ", ns,
            cur_systime_ns);
    ts->tv_sec = div_u64_rem(ns, 1000000000ULL, &reminder);
    ts->tv_nsec = reminder;
    return 0;
}

static struct ptp_clock_info rgptp_ptp_clock_ops = {
    .owner = THIS_MODULE,
    .name = "rgptp_clk",
    .gettime64 = rgptp_get_time,
};

static void rgptp_ptp_deinit(struct rgptp_prv_data *priv_data)
{
    if (priv_data->ptp_clock) {
        ptp_clock_unregister(priv_data->ptp_clock);
        priv_data->ptp_clock = NULL;
        dev_info(priv_data->dev, "Removed rgptp successfully\n");
    }
}

static int rgptp_ptp_init(struct rgptp_prv_data *priv_data)
{
    int ptp_index = 0;
    priv_data->ptp_clock_ops = rgptp_ptp_clock_ops;
    spin_lock_init(&priv_data->ptp_lock);
    priv_data->ptp_clock = ptp_clock_register(&priv_data->ptp_clock_ops,
                           priv_data->dev);

    if (IS_ERR(priv_data->ptp_clock)) {
        dev_err(priv_data->dev, "ptp_clock_register failed\n");
        priv_data->ptp_clock = NULL;
    } else if (priv_data->ptp_clock) {
        dev_info(priv_data->dev, "registered PTP clock\n");
    }

    ptp_index = ptp_clock_index(priv_data->ptp_clock);
    dev_info(priv_data->dev, "%s, ptp index = %d", __func__, ptp_index);
    return 0;
}

static void socket_data_ready(struct sock *sk_ptr)
{
    int ret = 0;
    struct kvec iov = {0};
    struct msghdr rd_msg = {0};
    struct rgptp_prv_data *info = NULL;
    struct sync_data rcvBuf;
    int len = sizeof(rcvBuf);
    unsigned long flags;
    struct timespec cur_sys_time;
    u64 cur_systime_ns = 0;
    s64 offset_ns;

    if (!sk_ptr) {
        pr_err("%s, invalid sk_ptr", __func__);
        return;
    }

    info = (struct rgptp_prv_data *)(sk_ptr->sk_user_data);

    if (!info) {
        pr_err("%s, invalid info\n", __func__);
        return;
    }

    memset(&rcvBuf, 0x00, sizeof(rcvBuf));
    iov.iov_base = &rcvBuf;
    iov.iov_len = sizeof(rcvBuf);
    memset(&rd_msg, 0x00, sizeof(rd_msg));
    rd_msg.msg_name = &info->remote_addr;
    rd_msg.msg_namelen = sizeof(info->remote_addr);
    rd_msg.msg_flags |= MSG_DONTWAIT;
    ret = kernel_recvmsg(info->hdl, &rd_msg, &iov, len, len, MSG_DONTWAIT);

    if (ret < 0) {
        dev_err(info->dev, "%s, kernel_recvmsg - err = %d\n", __func__, ret);
        return;
    }

    getnstimeofday(&cur_sys_time);
    cur_systime_ns = timespec_to_ns(&cur_sys_time);
    spin_lock_irqsave(&info->ptp_lock, flags);
    info->rptp_time_ns = rcvBuf.ptp_time;
    info->rptp_sync = rcvBuf.sync;
    info->modem_sync = true;
    info->ptp_cnt++;

    if (info->irq_cnt == info->ptp_cnt) {
        offset_ns = (info->rptp_time_ns - info->irq_systime_ns);
        info->offset_array[info->offset_index] = offset_ns;
        info->offset_index = (info->offset_index + 1) % OFFSET_ARRAY_SIZE;
        offset_ns = find_max_offset(info);

        if (info->offset_ns != 0) {
            /* To avoid drastic variations due to irq delays due to system load,
            smoothen out the variations by giving weight for previous offset value
            and use the newer one along with it */
            info->offset_ns = PREV_OFFSET_WEIGHTAGE * info->offset_ns / OFFSET_WEIGHTAGE_MAX
                              +
                              (OFFSET_WEIGHTAGE_MAX - PREV_OFFSET_WEIGHTAGE) * offset_ns /
                              OFFSET_WEIGHTAGE_MAX;
        } else {
            info->offset_ns = offset_ns;
        }

        dev_dbg(info->dev, "rptp_time_ns : %llu irq_systime_ns : %llu count %d",
                info->rptp_time_ns, info->irq_systime_ns, info->irq_cnt);
        info->irq_cnt = info->ptp_cnt = 0;
    }

    spin_unlock_irqrestore(&info->ptp_lock, flags);
    return;
}

static void socket_error_report(struct sock *sk_ptr)
{
    struct rgptp_prv_data *info;
    info = (struct rgptp_prv_data*)(sk_ptr->sk_user_data);
    dev_err(info->dev, "%s", __func__);
    return;
}

static void rgptp_open_client(struct rgptp_prv_data *info)
{
    int ret = 0;
    int write_len = 0;
    struct kvec iov = {0};
    struct msghdr write_msg = {0};
    static char *buf = "hello";
    int len = 6;
    ret = sock_create(AF_QIPCRTR, SOCK_DGRAM, PF_QIPCRTR, &info->hdl);

    if (ret < 0 || !info->hdl) {
        dev_err(info->dev, "In %s, socket not initialized", __func__);
    }

    info->hdl->sk->sk_user_data = (void *)(info);
    info->hdl->sk->sk_data_ready = socket_data_ready;
    info->hdl->sk->sk_error_report = socket_error_report;
    iov.iov_base = buf;
    iov.iov_len = len;
    memset(&write_msg, 0x00, sizeof(write_msg));
    write_msg.msg_name = &info->remote_addr;
    write_msg.msg_namelen = sizeof(info->remote_addr);
    write_msg.msg_flags |= MSG_DONTWAIT;
    write_len = kernel_sendmsg(info->hdl, &write_msg, &iov, 1, len);

    if (write_len < 0) {
        dev_err(info->dev, "%s, error sending data, err: %d\n",
                __func__, write_len);
    }

    dev_info(info->dev, "%s, kernel_sendmsg - write_len %d", __func__, write_len);
    return;
}

static int rgptp_new_server(struct qmi_handle *cntl_qmi,
                            struct qmi_service *svc)
{
    struct rgptp_prv_data *info =
        container_of(cntl_qmi, struct rgptp_prv_data, cntl_qmi);
    info->remote_addr.sq_family = AF_QIPCRTR;
    info->remote_addr.sq_node = svc->node;
    info->remote_addr.sq_port = svc->port;
    dev_info(info->dev, "%s, node = %u port = %u", __func__,
             info->remote_addr.sq_node, info->remote_addr.sq_port);
    rgptp_open_client(info);
    return 0;
}

static void rgptp_del_server(struct qmi_handle *cntl_qmi,
                             struct qmi_service *svc)
{
    struct rgptp_prv_data *info =
        container_of(cntl_qmi, struct rgptp_prv_data, cntl_qmi);
    dev_info(info->dev, "%s ptp time will be calculated with last known offset",
             __func__);
    return;
}

static struct qmi_ops rptp_qmi_cntl_ops = {
    .new_server = rgptp_new_server,
    .del_server = rgptp_del_server,
};

static int rgptp_drv_remove(struct platform_device *pdev)
{
    struct rgptp_prv_data *priv = NULL;
    priv = platform_get_drvdata(pdev);

    if (priv->hdl) {
        sock_release(priv->hdl);
    }

    priv->hdl = NULL;
    qmi_handle_release(&priv->cntl_qmi);
    rgptp_ptp_deinit(priv);
    gpio_free(priv->toggle_gpio);
    return 0;
}

static int rgptp_qmi_init(struct rgptp_prv_data *priv_data)
{
    int ret = 0;
    memset(&priv_data->cntl_qmi, 0, sizeof(priv_data->cntl_qmi));
    ret = qmi_handle_init(&priv_data->cntl_qmi, 0, &rptp_qmi_cntl_ops, NULL);

    if (ret < 0) {
        dev_err(priv_data->dev, "%s, qmi handle init failed: %d", __func__, ret);
        return ret;
    }

    ret = qmi_add_lookup(&priv_data->cntl_qmi, QSOCKET_QC_GPTP_TIME_SERVICE_ID,
                         0, QSOCKET_QC_GPTP_TIME_INSTANCE_ID);

    if (ret < 0) {
        dev_err(priv_data->dev, "%s, qmi_add_lookup failed: %d", __func__, ret);
    }

    return ret;
}

static irqreturn_t toggle_gpio_handle_irq(int irq, void *dev_id)
{
    struct rgptp_prv_data *info = (struct rgptp_prv_data*)dev_id;
    unsigned long flags;
    struct timespec sys_time;
    struct timespec cur_sys_time;
    u64 cur_systime_ns = 0;
    s64 offset_ns;
    getnstimeofday(&cur_sys_time);
    cur_systime_ns = timespec_to_ns(&cur_sys_time);
    spin_lock_irqsave(&info->ptp_lock, flags);
    getnstimeofday(&sys_time);
    info->irq_systime_ns = cur_systime_ns;
    info->irq_cnt++;

    if (info->irq_cnt == info->ptp_cnt) {
        offset_ns = (info->rptp_time_ns - info->irq_systime_ns);
        info->offset_array[info->offset_index] = offset_ns;
        info->offset_index = (info->offset_index + 1) % OFFSET_ARRAY_SIZE;
        offset_ns = find_max_offset(info);

        if (info->offset_ns != 0) {
            /* To avoid drastic variations due to irq delays due to system load,
            smoothen out the variations by giving weight for previous offset value
            and use the newer one along with it */
            info->offset_ns = PREV_OFFSET_WEIGHTAGE * info->offset_ns / OFFSET_WEIGHTAGE_MAX
                              +
                              (OFFSET_WEIGHTAGE_MAX - PREV_OFFSET_WEIGHTAGE) * offset_ns /
                              OFFSET_WEIGHTAGE_MAX;
        } else {
            info->offset_ns = offset_ns;
        }

        dev_dbg(info->dev, "rptp_time_ns : %llu irq_systime_ns : %llu count %d",
                info->rptp_time_ns, info->irq_systime_ns, info->irq_cnt);
        info->irq_cnt = info->ptp_cnt = 0;
    }

    spin_unlock_irqrestore(&info->ptp_lock, flags);
    return IRQ_HANDLED;
}

static int rgptp_platform_init(struct rgptp_prv_data *priv_data)
{
    int ret = 0;
    priv_data->toggle_gpio = of_get_named_gpio(priv_data->dev->of_node,
                             "qcom,toggle-gpio", 0);

    do {
        if (!gpio_is_valid(priv_data->toggle_gpio)) {
            dev_err(priv_data->dev, "%s: gpio_is_valid failed", __func__);
            break;
        }

        ret = gpio_request(priv_data->toggle_gpio, "toggle_gpio");

        if (ret) {
            dev_err(priv_data->dev, "%s: gpio_request failed \n", __func__);
            break;
        }

        gpio_direction_input(priv_data->toggle_gpio);
        priv_data->gpio_irq = gpio_to_irq(priv_data->toggle_gpio);
        dev_dbg(priv_data->dev, "rgptp gpio = %u irq = %u",
                priv_data->toggle_gpio, priv_data->gpio_irq);

        if (priv_data->gpio_irq < 0) {
            dev_err(priv_data->dev, "%s: gpio_to_irq failed\n", __func__);
            ret = -1;
            break;
        }

        ret = devm_request_threaded_irq(priv_data->dev, priv_data->gpio_irq,
                                        toggle_gpio_handle_irq, NULL,
                                        IRQF_TRIGGER_RISING | IRQF_ONESHOT, "rgptp", priv_data);

        if (ret < 0) {
            dev_err(priv_data->dev, "%s: gpio_irq #%d request failed:%d\n",
                    __func__, priv_data->gpio_irq, ret);
            break;
        }
    } while (0);

    return ret;
}

static int rgptp_drv_probe(struct platform_device *pdev)
{
    int ret = 0;
    struct rgptp_prv_data *priv_data = NULL;
    priv_data = devm_kzalloc(&pdev->dev, sizeof(*priv_data), GFP_KERNEL);

    if (!priv_data) {
        pr_err("%s, memory alloc failure", __func__);
        return -ENOMEM;
    }

    memset(priv_data, 0, sizeof(struct rgptp_prv_data));
    platform_set_drvdata(pdev, priv_data);
    priv_data->pdev = pdev;
    priv_data->dev = &pdev->dev;
    priv_data->modem_sync = false;
    ret = rgptp_platform_init(priv_data);

    if (ret < 0) {
        dev_err(priv_data->dev, "%s: rgptp_platform_init failed,\n", __func__);
        goto rgptp_plt_failed;
    }

    ret = rgptp_ptp_init(priv_data);

    if (ret < 0) {
        dev_err(priv_data->dev, "%s: rgptp_ptp_init failed,\n", __func__);
        goto rgptp_ptp_failed;
    }

    ret = rgptp_qmi_init(priv_data);

    if (ret < 0) {
        dev_err(priv_data->dev, "%s: rgptp_qmi_init failed,\n", __func__);
        goto rgptp_qmi_failed;
    }

    return 0;
rgptp_qmi_failed:
    qmi_handle_release(&priv_data->cntl_qmi);
rgptp_ptp_failed:
rgptp_plt_failed:
    gpio_free(priv_data->toggle_gpio);
    return ret;
}

static struct of_device_id rgptp_match[] = {
    {
        .compatible = "qcom,rgptp",
    },
    {}
};

static struct platform_driver rgptp_driver = {
    .probe  = rgptp_drv_probe,
    .remove = rgptp_drv_remove,
    .driver = {
        .name   = "rgptp",
        .owner    = THIS_MODULE,
        .of_match_table = rgptp_match,
    },
};

static int __init rgptp_init(void)
{
    int ret = 0;
    ret = platform_driver_register(&rgptp_driver);
    return ret;
}

static void __exit rgptp_exit(void)
{
    platform_driver_unregister(&rgptp_driver);
    return;
}

module_init(rgptp_init);
module_exit(rgptp_exit);

MODULE_LICENSE("GPL v2");
