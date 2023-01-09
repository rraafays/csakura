.POSIX:
CC	= cc
PKG_CONFIG	?= pkg-config
CFLAGS	+= -Wall -Wextra -Wshadow -Wpointer-arith -Wcast-qual -pedantic $(shell $(PKG_CONFIG) --cflags ncursesw panelw)
LDLIBS	= $(shell $(PKG_CONFIG) --libs ncursesw panelw || echo "-lncursesw -ltinfo -lpanelw")
PREFIX	= /usr/local
MANDIR	= $(PREFIX)/share/man

csakura: csakura.c

csakura.6: csakura.scd
ifeq ($(shell command -v scdoc 2>/dev/null),)
	$(warning Missing dependency: scdoc. The man page will not be generated.)
else
	scdoc <$< >$@
endif

install: csakura csakura.6
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	mkdir -p $(DESTDIR)$(MANDIR)/man6
	install -m 0755 csakura $(DESTDIR)$(PREFIX)/bin/csakura
	[ ! -f csakura.6 ] || install -m 0644 csakura.6 $(DESTDIR)$(MANDIR)/man6/csakura.6

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/csakura
	rm -f $(DESTDIR)$(MANDIR)/man6/csakura.6

clean:
	rm -f csakura
	rm -f csakura.6

.PHONY: install uninstall clean
