# dwm - dynamic window manager
# See LICENSE file for copyright and license details.

include config.mk

SRC = drw.c dwm.c util.c
OBJ = ${SRC:.c=.o}

all: options dwm

options:
	@echo dwm build options:
	@echo "CFLAGS   = ${CFLAGS}"
	@echo "LDFLAGS  = ${LDFLAGS}"
	@echo "CC       = ${CC}"

.c.o:
	${CC} -c ${CFLAGS} $<

${OBJ}: config.mk

dwm: ${OBJ}
	${CC} -o $@ ${OBJ} ${LDFLAGS}

clean:
	rm -f dwm ${OBJ} dwm-${VERSION}.tar.gz *.orig *.rej

dist: clean
	mkdir -p dwm-${VERSION}
	cp -R LICENSE Makefile README config.h config.mk\
		dwm.1 drw.h util.h ${SRC} dwm.png transient.c dwm-${VERSION}
	tar -cf dwm-${VERSION}.tar dwm-${VERSION}
	gzip dwm-${VERSION}.tar
	rm -rf dwm-${VERSION}

install: all
	mkdir -p ${DESTDIR}${PREFIX}/bin
	cp -f dwm ${DESTDIR}${PREFIX}/bin
	chmod 755 ${DESTDIR}${PREFIX}/bin/dwm
	mkdir -p ${DESTDIR}${MANPREFIX}/man1
	sed "s/VERSION/${VERSION}/g" < dwm.1 > ${DESTDIR}${MANPREFIX}/man1/dwm.1
	chmod 644 ${DESTDIR}${MANPREFIX}/man1/dwm.1
	cp -f dwm.desktop ${DESTDIR}${SHARE}/xsessions/dwm.desktop
	cp -f startdwm ${DESTDIR}${PREFIX}/bin/startdwm
	chmod +x ${DESTDIR}${PREFIX}/bin/startdwm
	mkdir -p /home/${SUDO_USER}/.local/share/dwm
	cp autostart.sh atom.jpg /home/${SUDO_USER}/.local/share/dwm/
	chmod +x /home/${SUDO_USER}/.local/share/dwm/autostart.sh
	chown -R ${SUDO_USER} /home/${SUDO_USER}/.local/share/dwm

uninstall:
	rm -f ${DESTDIR}${PREFIX}/bin/dwm\
		${DESTDIR}${MANPREFIX}/man1/dwm.1\
		${DESTDIR}${SHARE}/xsessions/dwm.desktop\
		${DESTDIR}${PREFIX}/bin/startdwm\
		${HOME}/.local/share/dwm/

.PHONY: all options clean dist install uninstall
