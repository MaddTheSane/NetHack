/* NetHack 3.6	snd386.c	$NHDT-Date: 1455672983 2016/02/17 01:36:23 $  $NHDT-Branch: NetHack-3.6.0 $:$NHDT-Revision: 1.548 $ */
/* Copyright (c) C.W. Betts, 2016.				  */
/* NetHack may be freely redistributed.  See license for details. */

#include "hack.h"
#include "nhsnd.h"

STATIC_DCL int NDECL(atconsole);


/*
 * Play audible music on the machine's speaker if appropriate.
 */

STATIC_OVL int
atconsole()
{
    /*
     * Kluge alert: This code assumes that your [34]86 has no X terminals
     * attached and that the console tty type is AT386 (this is always true
     * under AT&T UNIX for these boxen). The theory here is that your remote
     * ttys will have terminal type `ansi' or something else other than
     * `AT386' or `xterm'. We'd like to do better than this, but testing
     * to see if we're running on the console physical terminal is quite
     * difficult given the presence of virtual consoles and other modern
     * UNIX impedimenta...
     */
    char *termtype = nh_getenv("TERM");

    return (!strcmp(termtype, "AT386") || !strcmp(termtype, "xterm"));
}

void
speaker(instr, buf)
struct obj *instr;
char *buf;
{
    /*
     * For this to work, you need to have installed the PD speaker-control
     * driver for PC-compatible UNIX boxes that I (esr@snark.thyrsus.com)
     * posted to comp.sources.unix in Feb 1990.  A copy should be included
     * with your nethack distribution.
     */
    int fd;

    if ((fd = open("/dev/speaker", 1)) != -1) {
        /* send a prefix to modify instrumental `timbre' */
        switch (instr->otyp) {
        case WOODEN_FLUTE:
        case MAGIC_FLUTE:
            (void) write(fd, ">ol", 1); /* up one octave & lock */
            break;
        case TOOLED_HORN:
        case FROST_HORN:
        case FIRE_HORN:
            (void) write(fd, "<<ol", 2); /* drop two octaves & lock */
            break;
        case BUGLE:
            (void) write(fd, "ol", 2); /* octave lock */
            break;
        case WOODEN_HARP:
        case MAGIC_HARP:
            (void) write(fd, "l8mlol", 4); /* fast, legato, octave lock */
            break;
        }
        (void) write(fd, buf, strlen(buf));
        (void) nhclose(fd);
    }
}
