/* NetHack 3.6	sound.c	$NHDT-Date: 1448013599 2015/11/20 09:59:59 $  $NHDT-Branch: master $:$NHDT-Revision: 1.35 $ */
/* Copyright (c) C.W. Betts, 2016. */
/* NetHack may be freely redistributed.  See license for details. */

#include "hack.h"
#include "nhsnd.h"

extern char sounddir[];

struct sound_procs soundprocs;

static boolean genl_snd_init(void)
{
	return true;
}

static boolean genl_snd_play_sound(const char* path, int volume, int speed)
{
	return true;
}


struct sound_procs genl_soundprocs =
{
	"null sound",
	&genl_snd_init,
	&genl_snd_play_sound,
	&genl_snd_play_instrument,
	&genl_snd_change_volume
};

boolean genl_snd_play_instrument(struct obj *instr, const char *melody)
{
    char filename[256];
    char filespec[256];
    int i;
    int *changedPitch;
    int typ = instr->otyp;
    const char *actualn = OBJ_NAME(objects[typ]);

    size_t soundCount = strlen(melody);
    
	
	if (strlen(sounddir) + strlen(actualn) > 254) {
		raw_print("sound file name too long");
		return 0;
	}
	Sprintf(filespec, "%s/%s.aiff", sounddir, actualn);
	
	if (!can_read_file(filespec)) {
		return 0;
	}
	changedPitch = malloc(soundCount * sizeof(int));
	for (i = 0; i < soundCount; i++) {
		changedPitch[i] = nh_note_to_speed(melody[i]);
	}
	for (i = 0; i < soundCount; i++) {
		soundprocs->snd_play_sound(filespec, 100, changedPitch[i]);
	}
	
	free(changedPitch);
}

void genl_snd_change_volume(int volTo)
{
	// do nothing
}

int nh_note_to_speed(char note)
{
	/* TODO: implement scaling based on speed of melody, with middle c = 0 speed */
	return 0;
}

void nh_speaker(struct obj *instrument, const char *melody)
{
    /*
     * Are we in the library ?
     */
    if (flags.silent) {
        return;
    }

	soundprocs->snd_play_instrument(instrument, melody);
}
