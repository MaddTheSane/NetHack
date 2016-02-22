/* NetHack 3.6	sndmain.c	$NHDT-Date: 1455672983 2016/02/17 01:36:23 $  $NHDT-Branch: NetHack-3.6.0 $:$NHDT-Revision: 1.548 $ */
/* Copyright (c) C.W. Betts, 2016.				  */
/* NetHack may be freely redistributed.  See license for details. */

#include "hack.h"
#include "nhsnd.h"

void nh_speaker(struct obj *instr, char *notes, boolean improv)
{
#ifdef AMIGA
    if (!improv) {
        char nbuf[20];
        int i;

        for (i = 0; notes[i] && i < 5; ++i) {
            nbuf[i * 2] = notes[i];
            nbuf[(i * 2) + 1] = 'h';
        }
        nbuf[i * 2] = 0;
        amii_speaker(instr, nbuf, AMII_OKAY_VOLUME);
    } else {
        amii_speaker(instr, "Cw", AMII_OKAY_VOLUME);
    }
#endif
#ifdef VPIX_MUSIC
    if (sco_flag_console)
        vpix_speaker(instr, notes);
#endif
#ifdef UNIX386MUSIC
    /* if user is at the console, play through the console speaker */
    if (atconsole())
        speaker(instr, notes);
#endif
#ifdef MAC
    mac_speaker(instr, notes);
#endif
#ifdef PCMUSIC
    pc_speaker(instr, notes);
#endif
     /*TODO: implement others*/
}

