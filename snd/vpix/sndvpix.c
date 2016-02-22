/* NetHack 3.6	sndvpix.c	$NHDT-Date: 1455672983 2016/02/17 01:36:23 $  $NHDT-Branch: NetHack-3.6.0 $:$NHDT-Revision: 1.548 $ */
/* Copyright (c) C.W. Betts, 2016.				  */
/* NetHack may be freely redistributed.  See license for details. */

#include "hack.h"
#include "nhsnd.h"

extern int sco_flag_console; /* will need changing if not _M_UNIX */
STATIC_DCL void NDECL(playinit);
STATIC_DCL void FDECL(playstring, (char *, size_t));

#if 0
#include <sys/types.h>
#include <sys/console.h>
#include <sys/vtkd.h>
#else
#define KIOC ('K' << 8)
#define KDMKTONE (KIOC | 8)
#endif

#define noDEBUG

/* emit tone of frequency hz for given number of ticks */
STATIC_OVL void
tone(hz, ticks)
unsigned int hz, ticks;
{
    ioctl(0, KDMKTONE, hz | ((ticks * 10) << 16));
#ifdef DEBUG
    printf("TONE: %6d %6d\n", hz, ticks * 10);
#endif
    nap(ticks * 10);
}

/* rest for given number of ticks */
STATIC_OVL void
rest(ticks)
int ticks;
{
    nap(ticks * 10);
#ifdef DEBUG
    printf("REST:        %6d\n", ticks * 10);
#endif
}

#include "interp.c" /* from snd86unx.shr */

void
vpix_speaker(instr, buf)
struct obj *instr;
char *buf;
{
    /* emit a prefix to modify instrumental `timbre' */
    playinit();
    switch (instr->otyp) {
    case WOODEN_FLUTE:
    case MAGIC_FLUTE:
        playstring(">ol", 1); /* up one octave & lock */
        break;
    case TOOLED_HORN:
    case FROST_HORN:
    case FIRE_HORN:
        playstring("<<ol", 2); /* drop two octaves & lock */
        break;
    case BUGLE:
        playstring("ol", 2); /* octave lock */
        break;
    case WOODEN_HARP:
    case MAGIC_HARP:
        playstring("l8mlol", 4); /* fast, legato, octave lock */
        break;
    }
    playstring(buf, strlen(buf));
}

#ifdef VPIX_DEBUG
main(argc, argv)
int argc;
char *argv[];
{
    if (argc == 2) {
        playinit();
        playstring(argv[1], strlen(argv[1]));
    }
}
#endif
