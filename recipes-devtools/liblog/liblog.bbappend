DEPENDS += "glib-2.0"

EXTRA_OECONF_remove_class-target = " --with-logd-logging"

CFLAGS += " -Dstrlcpy=g_strlcpy "
LDFLAGS += " -lglib-2.0 "
