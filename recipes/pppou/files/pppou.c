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

#define PPPOU_LOG  printf

#define MSM_ENABLE_UART_CLOCK  0x5441
#define MSM_DISABLE_UART_CLOCK  0x5442

#define CMD_MAX_LEN 500
#define ARG_MAX_LEN 200

int  user_baud_rate = 0;
char *user_port = NULL;
char *user_additional_arg = NULL;
const int default_baud = 3000000;

static void display_help(void)
{
    PPPOU_LOG("Usage: pppou [OPTION]\n"
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
                  PPPOU_LOG("unexpected uart port provided.\n");
                  free(user_port);
                  user_port = NULL;
              }
          break;
          case 'a':
              user_additional_arg = strdup(optarg);
              if (NULL!=user_additional_arg &&
                 strlen(user_additional_arg) > ARG_MAX_LEN){
                    PPPOU_LOG("unexpected args to pppd provided.\n");
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
    PPPOU_LOG("%s returns %d\n", pppd_cmd, ret);

    return ret;
}


static void enabe_uart_clock(void)
{
    int tty_fd = -1;
    int ret = -1;

    tty_fd = open(user_port, O_RDWR | O_NONBLOCK);
    if (tty_fd < 0) {
        perror("Error opening serial port");
        free(user_port);
        exit(1);
    }

    ret = ioctl(tty_fd, MSM_ENABLE_UART_CLOCK, 0);
    if (ret < 0){
        PPPOU_LOG("MSM_ENABLE_UART_CLOCK returns %d.\n", ret);
    }
    else{
        PPPOU_LOG("MSM_ENABLE_UART_CLOCK success.\n");
    }

    tcdrain(tty_fd);
    tcflush(tty_fd, TCIOFLUSH);
}

int main(int argc, char * argv[])
{
    PPPOU_LOG("ppp over uart app\n");

    process_options(argc, argv);

    if (NULL==user_port) {
        fprintf(stderr, "ERROR: need Port argument!\n");
        display_help();
        return 1;
    }

    enabe_uart_clock();

    launch_pppd();

    free(user_port);

    if (NULL != user_additional_arg){
        free(user_additional_arg);
    }

    return 0;
}
