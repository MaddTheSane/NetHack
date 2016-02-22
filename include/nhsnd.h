/* NetHack 3.6	nhsnd.h	$NHDT-Date: 1455672983 2016/02/17 01:36:23 $  $NHDT-Branch: NetHack-3.6.0 $:$NHDT-Revision: 1.548 $ */
/* Copyright (c) C.W. Betts, 2016.				  */
/* NetHack may be freely redistributed.  See license for details. */

#ifdef UNIX386MUSIC
E void FDECL(unix386_speaker, (struct obj *, char *));
#endif
#ifdef VPIX_MUSIC
E void FDECL(vpix_speaker, (struct obj *, char *));
#endif
#ifdef PCMUSIC
E void FDECL(pc_speaker, (struct obj *, char *));
#endif
#ifdef AMIGA
E void FDECL(amii_speaker, (struct obj *, char *, int));
#endif
#ifdef MAC
/* ### sndmac.c ### */

E void FDECL(mac_speaker, (struct obj *, char *));
#endif

/* ### nullsnd.c ### */

