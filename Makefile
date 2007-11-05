# Define your C compiler.  I recommend gcc if you have it.
# MacOS users should use "cc" even though it's really "gcc".

# iPhone build put in separate Makefile.iphone.
# Only the default (forwarding) target has been changed in this one.
# Type 'make help' to se the other targets.
iphone:	
	$(MAKE) -f Makefile.iphone

#
CC = gcc
#CC = cc

# Define your optimization flags.  Most compilers understand -O and -O2,
# Standard (note: Solaris on UltraSparc using gcc 2.8.x might not like this.)
#
OPTS = -g #-O2 

# Pentium with gcc 2.7.0 or better
#OPTS = -O2 -fomit-frame-pointer -malign-functions=2 -malign-loops=2 \
#-malign-jumps=2

# Define where you want Frotz installed.  Usually this is /usr/local
PREFIX = /usr/local

MAN_PREFIX = $(PREFIX)
#MAN_PREFIX = /usr/local/share

CONFIG_DIR = $(PREFIX)/etc
#CONFIG_DIR = /etc

# Define where you want Frotz to look for frotz.conf.
#
CONFIG_DIR = /usr/local/etc
#CONFIG_DIR = /etc
#CONFIG_DIR = /usr/pkg/etc
#CONFIG_DIR =

# Uncomment this if you want color support.  Most, but not all curses
# libraries that work with Frotz will support color.
#
COLOR_DEFS = -DCOLOR_SUPPORT

# Uncomment this if you have an OSS soundcard driver and want classical
# Infocom sound support.
#
#SOUND_DEFS = -DOSS_SOUND

# Uncomment this too if you're running BSD of some sort and are using
# the OSS sound driver.
#
#SOUND_LIB = -lossaudio

# Define your sound device 
# This should probably be a command-line/config-file option.
#
#SOUND_DEV = /dev/dsp
#SOUND_DEV = /dev/sound
#SOUND_DEV = /dev/audio

# If your vendor-supplied curses library won't work, uncomment the
# location where ncurses.h is.
#
#INCL = -I/usr/local/include
#INCL = -I/usr/pkg/include
#INCL = -I/usr/freeware/include
#INCL = -I/5usr/include
#INCL = -I/path/to/ncurses.h

# If your vendor-supplied curses library won't work, uncomment the
# location where the ncurses library is.
#
#LIB = -L/usr/local/lib
#LIB = -L/usr/pkg/lib
#LIB = -L/usr/freeware/lib
#LIB = -L/5usr/lib
#LIB = -L/path/to/libncurses.so

# One of these must always be uncommented.  If your vendor-supplied
# curses library won't work, comment out the first option and uncomment
# the second.
#
CURSES = -lcurses
#CURSES = -lncurses

# Uncomment this if your need to use ncurses instead of the
# vendor-supplied curses library.  This just tells the compile process
# which header to include, so don't worry if ncurses is all you have
# (like on Linux).  You'll be fine.
#
#CURSES_DEF = -DUSE_NCURSES_H

# Uncomment this if you're compiling Unix Frotz on a machine that lacks
# the memmove(3) system call.  If you don't know what this means, leave it
# alone.
#
#MEMMOVE_DEF = -DNO_MEMMOVE

# Uncomment this if for some wacky reason you want to compile Unix Frotz
# under Cygwin under Windoze.  This sort of thing is not reccomended.
#
#EXTENSION = .exe


#####################################################
# Nothing under this line should need to be changed.
#####################################################

SRCDIR = src

VERSION = 2.43
 
NAME = frotz
BINNAME = $(NAME)

DISTFILES = bugtest

DISTNAME = $(BINNAME)-$(VERSION)
distdir = $(DISTNAME)

COMMON_DIR = $(SRCDIR)/common
COMMON_TARGET = $(SRCDIR)/frotz_common.a
COMMON_OBJECT = $(COMMON_DIR)/buffer.o \
		$(COMMON_DIR)/err.o \
		$(COMMON_DIR)/fastmem.o \
		$(COMMON_DIR)/files.o \
		$(COMMON_DIR)/hotkey.o \
		$(COMMON_DIR)/input.o \
		$(COMMON_DIR)/main.o \
		$(COMMON_DIR)/math.o \
		$(COMMON_DIR)/object.o \
		$(COMMON_DIR)/process.o \
		$(COMMON_DIR)/quetzal.o \
		$(COMMON_DIR)/random.o \
		$(COMMON_DIR)/redirect.o \
		$(COMMON_DIR)/screen.o \
		$(COMMON_DIR)/sound.o \
		$(COMMON_DIR)/stream.o \
		$(COMMON_DIR)/table.o \
		$(COMMON_DIR)/text.o \
		$(COMMON_DIR)/variable.o

CURSES_DIR = $(SRCDIR)/curses
CURSES_TARGET = $(SRCDIR)/frotz_curses.a
CURSES_OBJECT = $(CURSES_DIR)/ux_init.o \
		$(CURSES_DIR)/ux_input.o \
		$(CURSES_DIR)/ux_pic.o \
		$(CURSES_DIR)/ux_screen.o \
		$(CURSES_DIR)/ux_text.o \
		$(CURSES_DIR)/ux_audio_none.o \
		$(CURSES_DIR)/ux_audio_oss.o

DUMB_DIR = $(SRCDIR)/dumb
DUMB_TARGET = $(SRCDIR)/frotz_dumb.a
DUMB_OBJECT =	$(DUMB_DIR)/dumb_init.o \
		$(DUMB_DIR)/dumb_input.o \
		$(DUMB_DIR)/dumb_output.o \
		$(DUMB_DIR)/dumb_pic.o

TARGETS = $(COMMON_TARGET) $(CURSES_TARGET)

OPT_DEFS = -DCONFIG_DIR="\"$(CONFIG_DIR)\"" $(CURSES_DEF) \
	-DVERSION="\"$(VERSION)\"" -DSOUND_DEV="\"$(SOUND_DEV)\""

COMP_DEFS = $(OPT_DEFS) $(COLOR_DEFS) $(SOUND_DEFS) $(SOUNDCARD) \
	$(MEMMOVE_DEF)

FLAGS = $(OPTS) $(COMP_DEFS) $(INCL)

$(NAME): $(NAME)-curses

$(NAME)-curses:		soundcard.h  $(COMMON_TARGET) $(CURSES_TARGET)
	$(CC) -o $(BINNAME)$(EXTENSION) $(TARGETS) $(LIB) $(CURSES) \
		$(SOUND_LIB)

all:	$(NAME) d$(NAME)

dumb:		$(NAME)-dumb
d$(NAME):	$(NAME)-dumb
$(NAME)-dumb:		$(COMMON_TARGET) $(DUMB_TARGET)
	$(CC) -o d$(BINNAME)$(EXTENSION) $(COMMON_TARGET) \
		$(DUMB_TARGET) $(LIB)

.SUFFIXES:
.SUFFIXES: .c .o .h

.c.o:
	$(CC) $(FLAGS) $(CFLAGS) -o $@ -c $<

# If you're going to make this target manually, you'd better know which 
# config target to make first.
#
common_lib:	$(COMMON_TARGET)
$(COMMON_TARGET): $(COMMON_OBJECT)
	@echo
	@echo "Archiving common code..."
	ar rc $(COMMON_TARGET) $(COMMON_OBJECT)
	ranlib $(COMMON_TARGET)
	@echo

curses_lib:	config_curses $(CURSES_TARGET)
$(CURSES_TARGET): $(CURSES_OBJECT)
	@echo
	@echo "Archiving curses interface code..."
	ar rc $(CURSES_TARGET) $(CURSES_OBJECT)
	ranlib $(CURSES_TARGET)
	@echo

dumb_lib:	$(DUMB_TARGET)
$(DUMB_TARGET): $(DUMB_OBJECT)
	@echo
	@echo "Archiving dumb interface code..."
	ar rc $(DUMB_TARGET) $(DUMB_OBJECT)
	ranlib $(DUMB_TARGET)
	@echo

soundcard.h:
	@if [ ! -f $(SRCDIR)/soundcard.h ] ; then \
		 sh $(SRCDIR)/misc/findsound.sh $(SRCDIR); \
	fi

install: $(NAME)
	strip $(BINNAME)$(EXTENSION)
	install -d $(PREFIX)/bin
	install -d $(MAN_PREFIX)/man/man6
	install -c -m 755 $(BINNAME)$(EXTENSION) $(PREFIX)/bin
	install -c -m 644 doc/$(NAME).6 $(MAN_PREFIX)/man/man6

uninstall:
	rm -f $(PREFIX)/bin/$(NAME)
	rm -f $(MAN_PREFIX)/man/man6/$(NAME).6

deinstall: uninstall

install_dumb: d$(NAME)
	strip d$(BINNAME)$(EXTENSION)
	install -d $(PREFIX)/bin
	install -d $(MAN_PREFIX)/man/man6
	install -c -m 755 d$(BINNAME)$(EXTENSION) $(PREFIX)/bin
	install -c -m 644 doc/d$(NAME).6 $(MAN_PREFIX)/man/man6

uninstall_dumb:
	rm -f $(PREFIX)/bin/d$(NAME)
	rm -f $(MAN_PREFIX)/man/man6/d$(NAME).6

deinstall_dumb: uninstall_dumb

distro: dist

dist: distclean
	mkdir $(distdir)
	@for file in `ls`; do \
		if test $$file != $(distdir); then \
			cp -Rp $$file $(distdir)/$$file; \
		fi; \
	done
	find $(distdir) -type l -exec rm -f {} \;
	tar chof $(distdir).tar $(distdir)
	gzip -f --best $(distdir).tar
	rm -rf $(distdir)
	@echo
	@echo "$(distdir).tar.gz created"
	@echo

clean:
	make -f Makefile.iphone clean
	rm -f $(SRCDIR)/*.h $(SRCDIR)/*.a
	rm -f $(COMMON_DIR)/*.o $(CURSES_DIR)/*.o $(DUMB_DIR)/*.o

distclean: clean
	rm -f $(BINNAME)$(EXTENSION) d$(BINNAME)$(EXTENSION)
	rm -f *core $(SRCDIR)/*core
	-rm -rf $(distdir)
	-rm -f $(distdir).tar $(distdir).tar.gz
	
realclean: distclean

clobber: distclean

help:
	@echo
	@echo "Targets:"
	@echo "    iphone"
	@echo "    frotz"
	@echo "    dfrotz"
	@echo "    install"
	@echo "    uninstall"
	@echo "    clean"
	@echo "    distclean"
	@echo

