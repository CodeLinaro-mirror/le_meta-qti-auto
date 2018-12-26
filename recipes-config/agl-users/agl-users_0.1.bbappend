# 1001 and 1002 are alredy defined in meta-qti-bsp/conf/distro/include/base.inc
# use 6001 and 6002 instead
GROUPADD_PARAM_${PN} = "\
        --system display ; \
        --system weston-launch ; \
        -g 6001 agl-driver ; \
        -g 6002 agl-passenger \
"

USERADD_PARAM_${PN} = "\
  -g 6001 -G display -u 6001 -o -d /home/6001 -m -K PASS_MAX_DAYS=-1 agl-driver ; \
  -g 6002 -G display -u 6002 -o -d /home/6002 -m -K PASS_MAX_DAYS=-1 agl-passenger ; \
  --gid display --groups weston-launch,video,input --home-dir /run/platform/display --shell /bin/false --comment \"Display daemon\" --key PASS_MAX_DAYS=-1 display \
"
