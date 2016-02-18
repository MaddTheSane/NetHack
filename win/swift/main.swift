import Cocoa

swift_procs.wincap = UInt(WC_TILED_MAP | WC_COLOR |
	WC_HILITE_PET |
	WC_INVERSE |
	WC_ASCII_MAP |
	WC_POPUP_DIALOG) | WC_MOUSE_SUPPORT
swift_procs.win_init_nhwindows = swift_init_nhwindows
//swift_procs.win_player_selection
//swift_procs.win_askname
//swift_procs.win_get_nh_event
//swift_procs.win_exit_nhwindows
//swift_procs.win_suspend_nhwindows
//swift_procs.win_resume_nhwindows
//swift_procs.win_create_nhwindow
//swift_procs.win_clear_nhwindow
//swift_procs.win_display_nhwindow
//swift_procs.win_destroy_nhwindow
//swift_procs.win_curs
swift_procs.win_putstr = swift_win_putstr
swift_procs.win_putmixed = genl_putmixed
//swift_procs.win_display_file
//swift_procs.win_start_menu
//swift_procs.win_add_menu

//swift_procs.win_end_menu
//swift_procs.win_select_menu
swift_procs.win_message_menu = genl_message_menu
//swift_procs.win_update_inventory
//swift_procs.win_mark_synch
//swift_procs.win_wait_synch

//swift_procs.win_cliparound

//swift_procs.win_print_glyph
//swift_procs.win_raw_print
//swift_procs.win_raw_print_bold
//swift_procs.win_nhgetch
//swift_procs.win_nh_poskey
swift_procs.win_nhbell = NSBeep

//swift_procs.win_doprev_message
//swift_procs.win_yn_function
//swift_procs.win_getlin
//swift_procs.win_get_ext_cmd
//swift_procs.win_number_pad
//swift_procs.win_delay_output

/* other defs that really should go away (they're tty specific) */
//swift_procs.win_start_screen
//swift_procs.win_end_screen

//swift_procs.win_outrip
swift_procs.win_preference_update = genl_preference_update
swift_procs.win_getmsghistory = genl_getmsghistory
swift_procs.win_putmsghistory = genl_putmsghistory

swift_procs.win_can_suspend = genl_can_suspend_no

