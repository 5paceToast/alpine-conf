V=0.6.1
P=alpine-conf
PV=$(P)-$(V)
APKF=$(PV).apk
TARGZ=$(PV).tar.gz
PREFIX=/usr/local
TMP=$(PV)

LIB_FILES=libalpine.sh
SBIN_FILES=lbu\
	setup-interfaces\
	setup-dns\
	setup-hostname\
	setup-alpine\
	setup-webconf\
	update-conf
EXTRA_DIST=Makefile README

DIST_FILES=$(LIB_FILES) $(SBIN_FILES) $(EXTRA_DIST)

DESC="Alpine configuration scripts"
WWW="http://alpinelinux.org/alpine-conf"


TAR=tar
DB=$(TMP)/var/db/apk/$(PV)

.PHONY:	all apk clean dist install uninstall
all:	
	sed -i 's|^PREFIX=.*|PREFIX=$(PREFIX)|' $(SBIN_FILES)

apk:	$(APKF)

dist:	$(TARGZ)

$(APKF): $(SBIN_FILES)
	rm -rf $(TMP)
	make all PREFIX=
	make install DESTDIR=$(TMP) PREFIX=
	mkdir -p $(DB)
	echo $(DESC) > $(DB)/DESC
	cd $(TMP) && $(TAR) -czf ../$@ .
	rm -rf $(TMP)

$(TARGZ): $(DIST_FILES)
	rm -rf $(TMP)
	mkdir -p $(TMP)
	cp $(DIST_FILES) $(TMP)
	$(TAR) -czf $@ $(TMP)
	
install:
	install -m 755 -d $(DESTDIR)/$(PREFIX)/sbin
	install -m 755 $(SBIN_FILES) $(DESTDIR)/$(PREFIX)/sbin
	install -m 755 -d $(DESTDIR)/$(PREFIX)/lib
	install -m 755 $(LIB_FILES) $(DESTDIR)/$(PREFIX)/lib

uninstall:
	for i in $(SBIN_FILES); do \
		rm -f "$(DESTDIR)/$(PREFIX)/sbin/$$i";\
	done
	for i in $(LIB_FILES); do \
		rm -f "$(DESTDIR)/$(PREFIX)/lib/$$i";\
	done
	
clean:
	rm -rf $(APKF) $(TMP) $(TARGZ)
