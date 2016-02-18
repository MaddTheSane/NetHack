#include "SwiftHack.pch"
#include "winswift.h"


/* These will be filled out by our Swift main file */
struct window_procs swift_procs = {
	"swift",
	0L,
    0L,
	donull,
	donull,
	donull,
	donull,
	donull,
	donull,
	donull,
	donull,
	donull,
	donull,
	donull,
	donull,
	donull,
	genl_putmixed,
	donull,
	donull,
	donull,
	donull,
	donull,
    genl_message_menu,
	donull,
	donull,
	donull,
#ifdef CLIPPING
	donull,
#endif
#ifdef POSITIONBAR
    donull,
#endif
	donull,
    // nh3d_print_glyph_compose,
	donull,
	donull,
	donull,
	donull,
	donull,
	donull,
	donull,
	donull,
	donull,
	donull,
	donull,
#ifdef CHANGE_COLOR     /* only a Mac option currently */
    donull,
    donull,
#endif
    /* other defs that really should go away (they're tty specific) */
	donull,
	donull,
	donull,
    genl_preference_update,
	genl_getmsghistory,
	genl_putmsghistory,
#ifdef STATUS_VIA_WINDOWPORT
	hup_void_ndecl,                                   /* status_init */
	hup_void_ndecl,                                   /* status_finish */
	genl_status_enablefield, hup_status_update,
#ifdef STATUS_HILITES
	genl_status_threshold,
#endif
#endif /* STATUS_VIA_WINDOWPORT */
	genl_can_suspend_no,
};
