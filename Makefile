INSTALL = /usr/bin/install -c
INSTALLDATA = /usr/bin/install -c -m 644
CFLAGS = -Wall
UNAME := $(shell uname)
OUTDIR = bin

ifeq ($(UNAME), Darwin)
	CFLAGS += -DOSX $(shell pkg-config --cflags hidapi)
	LDFLAGS = $(shell pkg-config --libs hidapi)
else
	ifeq ($(UNAME), Linux)
		CFLAGS += $(shell pkg-config --cflags hidapi-libusb)
		LDFLAGS = $(shell pkg-config --libs hidapi-libusb)
	else
		LDFLAGS = -lhidapi
	endif
endif

all: scythe.c footswitch.c common.h common.c debug.h debug.c
	$(CC) footswitch.c common.c debug.c -o $(OUTDIR)/footswitch $(CFLAGS) $(LDFLAGS)
	$(CC) scythe.c common.c debug.c -o $(OUTDIR)/scythe $(CFLAGS) $(LDFLAGS)

install: all
	$(INSTALL) $(OUTDIR)/footswitch /usr/local/bin
	$(INSTALL) $(OUTDIR)/scythe /usr/local/bin
ifeq ($(UNAME), Linux)
	$(INSTALLDATA) 19-footswitch.rules /etc/udev/rules.d
endif

clean:
	rm -f $(OUTDIR)/scythe $(OUTDIR)/footswitch *.o

