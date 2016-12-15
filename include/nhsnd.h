/* NetHack 3.6	nhsnd.h	$NHDT-Date: 1448013599 2015/11/20 09:59:59 $  $NHDT-Branch: master $:$NHDT-Revision: 1.35 $ */
/* Copyright (c) C.W. Betts, 2016. */
/* NetHack may be freely redistributed.  See license for details. */

#ifndef NHSND_H
#define NHSND_H


struct sound_procs {
    const char *name;     /* Names should start with [a-z].  Names must
                           * not start with '-'.  Names starting with
                           * '+' are reserved for processors. */
    boolean (*snd_init)(void);
    /* A speed of 0 means no modification of speed*/
    boolean (*snd_play_sound)(const char* /* path */, int /*volume*/, int /*speed*/);
    boolean (*snd_play_instrument)(struct obj */*instrument*/, const char */*melody*/);
	void (*snd_change_volume)(int /*volTo*/);
}

extern struct sound_procs soundprocs;

/* changes playback speed to change pitch and, thus, note */
E boolean genl_snd_play_instrument(struct obj *instrument, const char *melody);
/* default implementation; does nothing */
E void genl_snd_change_volume(int volTo);

E int nh_note_to_speed(char note);

#define play_usersound(__path, __vol) soundprocs->snd_play_sound(__path, __vol, 0)
E void nh_speaker(struct obj */*instrument*/, const char */*melody*/);

#endif 
