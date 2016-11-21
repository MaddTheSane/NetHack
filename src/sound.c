/* NetHack 3.6	sound.c	$NHDT-Date: 1448013599 2015/11/20 09:59:59 $  $NHDT-Branch: master $:$NHDT-Revision: 1.35 $ */
/* Copyright (c) C.W. Betts, 2016. */
/* NetHack may be freely redistributed.  See license for details. */

#include "hack.h"
#include "nhsnd.h"

struct sound_procs soundprocs;

static boolean genl_snd_init(void)
{
	return true;
}

boolean genl_snd_play_sound(const char* path, int volume, int speed)
{
	return true;
}


struct sound_procs genl_soundprocs =
{
	"null sound",
	&genl_snd_init,
	&genl_snd_play_sound,
	&genl_snd_play_instrument
};

boolean genl_snd_play_instrument(struct obj *instrument, const char *melody)
{

}
