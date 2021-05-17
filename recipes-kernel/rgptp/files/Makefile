
KERNEL_SRC ?= /lib/modules/$(shell uname -r)/build

all:
	$(MAKE) -C $(KERNEL_SRC) M=$(shell pwd) modules $(KBUILD_OPTIONS)

modules_install:
	$(MAKE) -C $(KERNEL_SRC) M=$(shell pwd) modules_install

clean:
	$(MAKE) -C $(KERNEL_SRC) M=$(PWD) clean

obj-m += rgptp.o

EXTRA_CFLAGS+= -I$(KERNELDIR)/include/linux

#Top level
rgptp-y := rgptp_init.o