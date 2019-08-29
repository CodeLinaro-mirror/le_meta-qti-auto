# sa515m uses 64bit IPC though userspace is 32bit.
EXTRA_OECONF_remove_sa515m = "--enable-32bit-binder-ipc"
