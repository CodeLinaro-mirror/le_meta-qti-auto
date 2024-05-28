USERADD_PACKAGES ?= "${PN}"

USERADD_PARAM:${PN} ?= 	" \
			-u 5002 -U leprop; \
			-u 1000 -U system; \
			-u 1001 -U radio; \
			-u 1004 -g input input; \
			-G diag,system -u 1005 -g audio audio; \
			-u 1010 -U wifi; \
			-u 1036 -U logd; \
			-u 2000 -U adb; \
			-G diag,inet,system,leprop -u 3011 -U sensors; \
			-u 9999 -U nobody; \
			-u 4021 -U locclient; \
			-G system,locclient -u 1021 -U gps; \
			-u 3014 -U powermgr; \
			-u 3015 -U ubi; \
			-u 2906 -U qrtr; \
			-u 3019 -U mvm; \
			"

GROUPADD_PARAM:${PN} ?=	" \
                        -g 2901 kmsg; \
			-g 3004 net_raw; \
			-g 3005 net_admin; \
			-g 3010 wakelock; \
			-g 3013 qwes; \
			-g 3018 gpio; \
			-g 3017 cpu; \
			-r netdev; \
			"
