
Introduction:
=============

The folder includes ppp over uart user space code,
it enable specified hs uart clock, and launch pppd.

Top level directory structure:

pppou
  ├── files
  │   ├── CMakeLists.txt
  │   ├── pppou.c
  │   └── README.md 
  └── pppou_1.0.bb

Usage:
=====

pppou [OPTION]
  -h, --help
  -b, --baud        Baud rate, 115200, etc (3000000 is default)
  -p, --port        Port (/dev/ttyHS0, etc)
  -a, --additional  Additional options to pppd

supported baud rate:
9600
19200
38400
57600
115200
230400
460800
500000
576000
921600
1000000
1152000
1500000
2000000
2500000
3000000
3500000
4000000

addtional options can refer to https://linux.die.net/man/8/pppd

Compilation:
===========

bitbake -c cleansstate -f pppou; bitbake -c compile -f pppou; bitbake -c install -f pppou
