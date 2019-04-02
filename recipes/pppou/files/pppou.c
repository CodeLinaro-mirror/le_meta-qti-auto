/*!
@file
  pppou.c

@brief
  enable specified uart clock via IOCTL; bringup ppp interface over specified uart port.

*/

/*===========================================================================

Copyright (c) 2019, The Linux Foundation. All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above
      copyright notice, this list of conditions and the following
      disclaimer in the documentation and/or other materials provided
      with the distribution.
    * Neither the name of The Linux Foundation nor the names of its
      contributors may be used to endorse or promote products derived
      from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

===========================================================================*/

#include <stdio.h>
#include <termios.h>
#include <sys/ioctl.h>
#include <fcntl.h>
#include <stdlib.h>
#include <string.h>
#include <getopt.h>
#include <unistd.h>
#include <syslog.h>
#include <stdarg.h>
#include <qmi_idl_lib.h>
#include <qmi_client.h>
#include <power_manager_service_v01.h>
#include <power_state.h>

#define MSM_ENABLE_UART_CLOCK  0x5441
#define MSM_DISABLE_UART_CLOCK  0x5442

#define CMD_MAX_LEN 500
#define ARG_MAX_LEN 200
#define PPPOU_QMI_TIMEOUT_MS 3000
#define PPPOU_QMI_MAX_RETRY  3

int  user_baud_rate = 0;
char *user_port = NULL;
char *user_additional_arg = NULL;
const int default_baud = 3000000;
static int tty_fd = -1;

static qmi_cci_os_signal_type pm_os_param;
static qmi_cci_os_signal_type pm_notifier_osparamm;
static qmi_client_type pm_clnt;
static qmi_client_type pm_notifier_clnt;
static int             g_pmd_active = -1;
static pwr_state_v01   g_pwr_state = UNKNOWN_STATE_V01;
static pthread_mutex_t pmd_mutex   = PTHREAD_MUTEX_INITIALIZER;
static pthread_cond_t  pmd_cond    = PTHREAD_COND_INITIALIZER;

int pppou_log_level = LOG_INFO;
int pppou_use_syslog = 1;

#define LOGD(fmt, args...) \
    pppou_log(LOG_DEBUG, "[D][%s:%d] " fmt, __func__, __LINE__, ## args)

#define LOGI(fmt, args...) \
    pppou_log(LOG_INFO, "[I][%s:%d] " fmt, __func__, __LINE__, ## args)

#define LOGW(fmt, args...) \
    pppou_log(LOG_WARNING, "[W][%s:%d] " fmt, __func__, __LINE__, ## args)

#define LOGE(fmt, args...) \
    pppou_log(LOG_ERR, "[E][%s:%d] " fmt, __func__, __LINE__, ## args)


static inline void pppou_log(int level, const char *fmt, ...)
{
    va_list args;

    va_start(args, fmt);
    if (level <= pppou_log_level) {
        if (!pppou_use_syslog) {
            vprintf(fmt, args);
        } else {
            vsyslog(level, fmt, args);
        }
    }
    va_end(args);
}

static void display_help(void)
{
    printf("Usage: pppou [OPTION]\n"
         "\n"
         "  -h, --help\n"
         "  -b, --baud        Baud rate, 115200, etc (3000000 is default)\n"
         "  -p, --port        Port (/dev/ttyHS0, etc)\n"
         "  -a, --additional  Additional options to pppd\n"
         "\n");
}

static void process_options(int argc, char * argv[])
{
    int c = 0;
    int tx_len = 0;
    int option_index = 0;
    static const char *short_options = "h:b:p:a:";
    static const struct option long_options[] = {
        {"help",       no_argument, 0, 0},
        {"baud",       required_argument, 0, 'b'},
        {"port",       required_argument, 0, 'p'},
        {"additional", required_argument, 0, 'a'},
        {0,0,0,0},
    };

    while(1){
        c = getopt_long(argc, argv, short_options, long_options, &option_index);
        if (c == EOF) {
            break;
        }

        switch (c) {
          case 0:
          case 'h':
              display_help();
              exit(0);
          break;
          case 'b':
              user_baud_rate = atoi(optarg);
          break;
          case 'p':
              user_port = strdup(optarg);
              if (NULL!=user_port && strlen(user_port) > ARG_MAX_LEN){
                  LOGE("unexpected uart port provided.\n");
                  free(user_port);
                  user_port = NULL;
              }
          break;
          case 'a':
              user_additional_arg = strdup(optarg);
              if (NULL!=user_additional_arg &&
                 strlen(user_additional_arg) > ARG_MAX_LEN){
                    LOGE("unexpected args to pppd provided.\n");
                    free(user_additional_arg);
                    user_additional_arg = NULL;
              }
          break;
        }
    }

}

static int launch_pppd( void )
{
    int ret = -1;
    char pppd_cmd[CMD_MAX_LEN] = {0};
    int baud_rate = default_baud;
    const char* mandatory_opt = "local lock ";
    int len = 0;

    if (user_baud_rate){
        baud_rate = user_baud_rate;
    }

    snprintf(pppd_cmd, sizeof(pppd_cmd), "pppd %d %s %s ",
             baud_rate, user_port, mandatory_opt );

    if (user_additional_arg){
        len = strlen(user_additional_arg)+1;
        strncat(pppd_cmd, user_additional_arg, len);
    }

    ret = system(pppd_cmd);
    LOGD("%s returns %d\n", pppd_cmd, ret);

    return ret;
}


static void disable_uart_clock(void)
{
    int ret;

    if (tty_fd < 0) {
        return;
    }

    ret = ioctl(tty_fd, MSM_DISABLE_UART_CLOCK, 0);
    if (ret < 0){
        LOGE("MSM_DISABLE_UART_CLOCK erorr %d.\n", ret);
    }
    else{
        LOGW("MSM_DISABLE_UART_CLOCK success.\n");
    }

    tcdrain(tty_fd);

    close(tty_fd);
    tty_fd = -1;
}


static void enable_uart_clock(void)
{
    int ret;

    if (tty_fd < 0)
    {
        tty_fd = open(user_port, O_RDWR | O_NONBLOCK);
        if (tty_fd < 0) {
            LOGE("Error opening serial port.\n");
            free(user_port);
            exit(EXIT_FAILURE);
        }
    }
    /*disable the clock then enable it, to make sure the clock count is 1*/
    ret = ioctl(tty_fd, MSM_DISABLE_UART_CLOCK, 0);

    ret = ioctl(tty_fd, MSM_ENABLE_UART_CLOCK, 0);
    if (ret < 0){
        LOGE("MSM_ENABLE_UART_CLOCK returns %d.\n", ret);
    }
    else{
        LOGW("MSM_ENABLE_UART_CLOCK success.\n");
    }

    tcdrain(tty_fd);
}

void send_pwr_ack(pwr_state_ack_v01 ack_state)
{
    qmi_client_error_type qmi_error;
    pwr_mgr_ack_req_msg_v01 ack_req;
    pwr_mgr_ack_resp_msg_v01 ack_resp;

    ack_req.acknowledgement = ack_state;
    qmi_error = qmi_client_send_msg_sync(pm_clnt,
                                        PWR_MGR_ACK_REQ_V01,
                                        &ack_req,
                                        sizeof(pwr_mgr_ack_req_msg_v01),
                                        &ack_resp,
                                        sizeof(pwr_mgr_ack_resp_msg_v01),
                                        PPPOU_QMI_TIMEOUT_MS);
    if (QMI_NO_ERR != qmi_error) {
        LOGE("Error sending PWR_MGR_ACK w/ qmi_error %u \n", qmi_error );
        return;
    }

    LOGI("PWR_MGR_ACK response result %d.\n", ack_resp.ackresp.result);
    return;
}

void handle_power_change(pwr_state_v01 pwr_state) {

    switch(pwr_state)
    {
        case SUSPEND_STATE_V01:
            LOGW("Suspend notification received\n");
            disable_uart_clock();
            send_pwr_ack(ACK_SUSPEND_V01);
            break;
        case RESUME_STATE_V01:
            LOGW("Resume notification received\n");
            enable_uart_clock();
            break;
        case SHUTDOWN_STATE_V01:
            LOGW("Shutdown notification received\n");
            disable_uart_clock();
            send_pwr_ack(ACK_SHUTDOWN_V01);
            break;
        default :
            LOGE("Invalid notification received\n");
            break;
        }
}

void pm_indication_cb(
    qmi_client_type  clnt_handle,
    unsigned int     msg_id,
    void            *ind_buf,
    unsigned int     ind_buf_len,
    void            *ind_cb_data
)
{
    qmi_client_error_type rc;
    uint32_t decoded_payload_len;
    void * decoded_payload = NULL;
    pwr_mgr_broadcast_indication_msg_v01* pwr_ind = NULL;

    rc = qmi_idl_get_message_c_struct_len(power_manager_qmi_service_get_service_object_v01(),
                                          QMI_IDL_INDICATION,
                                          msg_id,
                                          &decoded_payload_len);
    if (rc != QMI_NO_ERR) {
        LOGE("get_message_c_struct msg_id %u with err %u \n", msg_id, rc);
        return;
    }
    if (0 == decoded_payload_len)
    {
        LOGD("Empty payload, return!\n");
        return;
    }

    decoded_payload = malloc(decoded_payload_len);
    if(NULL == decoded_payload) {
        return;
    }
    memset(decoded_payload, 0, decoded_payload_len);

    do {
        rc = qmi_client_message_decode(clnt_handle,
                                       QMI_IDL_INDICATION,
                                       msg_id,
                                       ind_buf,
                                       ind_buf_len,
                                       decoded_payload,
                                       decoded_payload_len);
        if (rc != QMI_NO_ERR)
        {
            LOGE("Error decoding msg_id %u\n", msg_id);
            break;
        }

        if (PWR_MGR_BROADCAST_IND_V01 != msg_id) {
            LOGE("received unexpected indication id %u\n", msg_id);
            break;
        }

        pthread_mutex_lock(&pmd_mutex);
        pwr_ind = (pwr_mgr_broadcast_indication_msg_v01*)decoded_payload;
        g_pwr_state = pwr_ind->notify_state;
        pthread_cond_signal(&pmd_cond);
        pthread_mutex_unlock(&pmd_mutex);
    } while (0);

    free(decoded_payload);
    return;
}

void pm_notify_cb
(
    qmi_client_type                clnt_handle,
    qmi_idl_service_object_type    service_obj,
    qmi_client_notify_event_type   service_event,
    void                           *notify_cb_data
)
{

    if (service_event == QMI_CLIENT_SERVICE_COUNT_INC)
    {
        pthread_mutex_lock(&pmd_mutex);
        g_pmd_active = 1;
        pthread_cond_signal(&pmd_cond);
        pthread_mutex_unlock(&pmd_mutex);
    }
    else if (service_event == QMI_CLIENT_SERVICE_COUNT_DEC)
    {
        pthread_mutex_lock(&pmd_mutex);
        g_pmd_active = 0;
        pthread_cond_signal(&pmd_cond);
        pthread_mutex_unlock(&pmd_mutex);
    }

    LOGE("got notifer service_event %u.\n", service_event);
    return;
}

qmi_client_error_type pwr_manager_register_indication(void)
{
    qmi_client_error_type rc = QMI_NO_ERR;
    pwr_mgr_register_req_msg_v01 reg_req;
    pwr_mgr_register_resp_msg_v01 reg_resp;

    //enable pwr_mgr_broadcast_indication
    reg_req.value = 1;
    rc = qmi_client_send_msg_sync(pm_clnt,
                                 PWR_MGR_REGISTER_REQ_V01,
                                 &reg_req, sizeof(pwr_mgr_register_req_msg_v01),
                                 &reg_resp, sizeof(pwr_mgr_register_resp_msg_v01),
                                 PPPOU_QMI_TIMEOUT_MS);
    if (rc != QMI_NO_ERR)
    {
        LOGD("enable pwr_mgr_broadcast_indication fail %u\n", rc);
    }
    else
    {
        LOGD("enable pwr_mgr_broadcast_indication success\n");
    }
    return rc;
}

int init_pm_client(void)
{
    qmi_client_error_type rc = QMI_SERVICE_ERR;
    qmi_idl_service_object_type pm_obj;
    int i;

    LOGW("Try initiate powre manager qmi client\n");
    pm_obj = power_manager_qmi_service_get_service_object_v01();
    if (NULL==pm_obj) {
        LOGE("Error, power_manager_qmi_service_get_service_object_v01 NULL\n");
        return rc;
    }

    for (i=0; i<PPPOU_QMI_MAX_RETRY; ++i)
    {
        rc = qmi_client_init_instance(pm_obj,
                                      QMI_CLIENT_INSTANCE_ANY,
                                      pm_indication_cb,
                                      NULL,
                                      &pm_os_param,
                                      PPPOU_QMI_TIMEOUT_MS,
                                      &pm_clnt);
        if (rc == QMI_NO_ERR)
        {
            LOGW("qmi_client_init_instance success\n");
            break;
        }
        sleep(1);
    }

    if (rc == QMI_NO_ERR)
    {
        rc = pwr_manager_register_indication();
        LOGW("register pwr_manager indication rc %u", rc);
    }
    LOGI("rc %u, pm_clnt %u. \n", rc, pm_clnt);
    return rc;
}


int init_pm_notifier_client(void)
{
    qmi_client_error_type rc = QMI_SERVICE_ERR;
    qmi_idl_service_object_type pm_obj;
    int i;

    pm_obj = power_manager_qmi_service_get_service_object_v01();
    if (NULL == pm_obj) {
        LOGE("Error, power_manager_qmi_service_get_service_object_v01 NULL\n");
        return rc;
    }

    for (i=0; i<PPPOU_QMI_MAX_RETRY; ++i)
    {
        rc = qmi_client_notifier_init(pm_obj,
                                      &pm_notifier_osparamm,
                                      &pm_notifier_clnt);
        if (rc == QMI_NO_ERR)
        {
            break;
        }
        LOGE("Notifier clnt init fail: rc %d.\n", rc);
        sleep(1);
    }

    if (rc != QMI_NO_ERR)
    {
        return rc;
    }

    for (i=0; i<PPPOU_QMI_MAX_RETRY; ++i)
    {
        rc = qmi_client_register_notify_cb(pm_notifier_clnt,
                                           pm_notify_cb,
                                           NULL);
        if (rc == QMI_NO_ERR)
        {
            break;
        }
        LOGE("qmi_client_register_notify_cb rc %d.\n", rc);
        sleep(1);
    }

    LOGW("rc %u, pm_clnt %u.\n", rc, pm_notifier_clnt);
    return rc;
}


int main(int argc, char * argv[])
{
    LOGD("ppp over uart app\n");

    process_options(argc, argv);

    if (NULL==user_port) {
        LOGE("ERROR: need Port argument!\n");
        display_help();
        return 1;
    }

    enable_uart_clock();
    launch_pppd();

    init_pm_notifier_client();

    while( 1 ) {

        pthread_mutex_lock(&pmd_mutex);
        pthread_cond_wait(&pmd_cond, &pmd_mutex);
        if (0 == g_pmd_active) {
            LOGE("release the pm client.\n");
            qmi_client_release(pm_clnt);
            pm_clnt = 0;
            g_pmd_active = -1;
        }
        else if(1 == g_pmd_active) {
            init_pm_client();
            g_pmd_active = -1;
        }

        if(g_pwr_state > UNKNOWN_STATE_V01 && g_pwr_state <= SHUTDOWN_STATE_V01) {
            handle_power_change(g_pwr_state);
            g_pwr_state = UNKNOWN_STATE_V01;
        }
        pthread_mutex_unlock(&pmd_mutex);
    }

    free(user_port);

    if (NULL != user_additional_arg){
        free(user_additional_arg);
    }

    return 0;
}
