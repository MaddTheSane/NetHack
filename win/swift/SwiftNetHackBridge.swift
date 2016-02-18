//
//  SwiftNetHackBridge.swift
//  SwiftHack
//
//  Created by C.W. Betts on 2/18/16.
//  Copyright © 2016 C.W. Betts. All rights reserved.
//

import Foundation

let GLYPH_PET_OFF: Int32 =		(NUMMONS	+ GLYPH_MON_OFF)
let GLYPH_INVIS_OFF: Int32 =	(NUMMONS	+ GLYPH_PET_OFF)
let GLYPH_DETECT_OFF: Int32 =	(1		+ GLYPH_INVIS_OFF)
let GLYPH_BODY_OFF: Int32 =		(NUMMONS	+ GLYPH_DETECT_OFF)
let GLYPH_RIDDEN_OFF: Int32 =	(NUMMONS	+ GLYPH_BODY_OFF)
let GLYPH_OBJ_OFF: Int32 =		(NUMMONS	+ GLYPH_RIDDEN_OFF)
let GLYPH_CMAP_OFF: Int32 =		(NUM_OBJECTS	+ GLYPH_OBJ_OFF)
let GLYPH_EXPLODE_OFF: Int32 =	((MAXPCHARS - MAXEXPCHARS) + GLYPH_CMAP_OFF)
let GLYPH_ZAP_OFF: Int32 =		((MAXEXPCHARS * EXPL_MAX) + GLYPH_EXPLODE_OFF)
let GLYPH_SWALLOW_OFF: Int32 =	((NUM_ZAP << 2) + GLYPH_ZAP_OFF)
let GLYPH_WARNING_OFF: Int32 =	((NUMMONS << 3) + GLYPH_SWALLOW_OFF)
let GLYPH_STATUE_OFF: Int32 =	(WARNCOUNT + GLYPH_WARNING_OFF)
let MAX_GLYPH: Int32 =			(NUMMONS + GLYPH_STATUE_OFF)

let NO_GLYPH		= MAX_GLYPH
let GLYPH_INVISIBLE	= GLYPH_INVIS_OFF


private func perceives(ptr: UnsafePointer<permonst>) -> Bool {
	return (ptr.memory.mflags1 & UInt(M1_SEE_INVIS)) != 0
}

// MARK: - from youprop.h
// MARK: Resistances to troubles - With intrinsics and extrinsics

var HFire_resistance: Int {
	return u.uprops.1.intrinsic
}

var EFire_resistance: Int {
	return u.uprops.1.extrinsic
}

var Fire_resistance: Bool {
	return HFire_resistance != 0 || EFire_resistance != 0
}

/*
/*** Resistances to troubles ***/
/* With intrinsics and extrinsics */

#define HCold_resistance u.uprops[COLD_RES].intrinsic
#define ECold_resistance u.uprops[COLD_RES].extrinsic
#define Cold_resistance (HCold_resistance || ECold_resistance)

#define HSleep_resistance u.uprops[SLEEP_RES].intrinsic
#define ESleep_resistance u.uprops[SLEEP_RES].extrinsic
#define Sleep_resistance (HSleep_resistance || ESleep_resistance)

#define HDisint_resistance u.uprops[DISINT_RES].intrinsic
#define EDisint_resistance u.uprops[DISINT_RES].extrinsic
#define Disint_resistance (HDisint_resistance || EDisint_resistance)

#define HShock_resistance u.uprops[SHOCK_RES].intrinsic
#define EShock_resistance u.uprops[SHOCK_RES].extrinsic
#define Shock_resistance (HShock_resistance || EShock_resistance)

#define HPoison_resistance u.uprops[POISON_RES].intrinsic
#define EPoison_resistance u.uprops[POISON_RES].extrinsic
#define Poison_resistance (HPoison_resistance || EPoison_resistance)

#define HDrain_resistance u.uprops[DRAIN_RES].intrinsic
#define EDrain_resistance u.uprops[DRAIN_RES].extrinsic
#define Drain_resistance (HDrain_resistance || EDrain_resistance)

/* Hxxx due to FROMFORM only */
#define HAntimagic u.uprops[ANTIMAGIC].intrinsic
#define EAntimagic u.uprops[ANTIMAGIC].extrinsic
#define Antimagic (HAntimagic || EAntimagic)

#define HAcid_resistance u.uprops[ACID_RES].intrinsic
#define EAcid_resistance u.uprops[ACID_RES].extrinsic
#define Acid_resistance (HAcid_resistance || EAcid_resistance)

#define HStone_resistance u.uprops[STONE_RES].intrinsic
#define EStone_resistance u.uprops[STONE_RES].extrinsic
#define Stone_resistance (HStone_resistance || EStone_resistance)

/* Intrinsics only */
#define HSick_resistance u.uprops[SICK_RES].intrinsic
#define Sick_resistance (HSick_resistance || defends(AD_DISE, uwep))

#define Invulnerable u.uprops[INVULNERABLE].intrinsic /* [Tom] */

/*** Troubles ***/
/* Pseudo-property */
#define Punished (uball != 0)

/* Those implemented solely as timeouts (we use just intrinsic) */
#define HStun u.uprops[STUNNED].intrinsic
#define Stunned HStun

#define HConfusion u.uprops[CONFUSION].intrinsic
#define Confusion HConfusion

#define Blinded u.uprops[BLINDED].intrinsic
#define Blindfolded (ublindf && ublindf->otyp != LENSES)
/* ...means blind because of a cover */
#define Blind                                     \
((u.uroleplay.blind || Blinded || Blindfolded \
|| !haseyes(youmonst.data))                 \
&& !(ublindf && ublindf->oartifact == ART_EYES_OF_THE_OVERWORLD))
/* ...the Eyes operate even when you really are blind
or don't have any eyes */
#define Blindfolded_only                                            \
(Blindfolded && ublindf->oartifact != ART_EYES_OF_THE_OVERWORLD \
&& !u.uroleplay.blind && !Blinded && haseyes(youmonst.data))
/* ...blind because of a blindfold, and *only* that */

#define Sick u.uprops[SICK].intrinsic
#define Stoned u.uprops[STONED].intrinsic
#define Strangled u.uprops[STRANGLED].intrinsic
#define Vomiting u.uprops[VOMITING].intrinsic
#define Glib u.uprops[GLIB].intrinsic
#define Slimed u.uprops[SLIMED].intrinsic /* [Tom] */

/* Hallucination is solely a timeout */
#define HHallucination u.uprops[HALLUC].intrinsic
#define HHalluc_resistance u.uprops[HALLUC_RES].intrinsic
#define EHalluc_resistance u.uprops[HALLUC_RES].extrinsic
#define Halluc_resistance (HHalluc_resistance || EHalluc_resistance)
#define Hallucination (HHallucination && !Halluc_resistance)

/* Timeout, plus a worn mask */
#define HDeaf u.uprops[DEAF].intrinsic
#define EDeaf u.uprops[DEAF].extrinsic
#define Deaf (HDeaf || EDeaf)

#define HFumbling u.uprops[FUMBLING].intrinsic
#define EFumbling u.uprops[FUMBLING].extrinsic
#define Fumbling (HFumbling || EFumbling)

#define HWounded_legs u.uprops[WOUNDED_LEGS].intrinsic
#define EWounded_legs u.uprops[WOUNDED_LEGS].extrinsic
#define Wounded_legs (HWounded_legs || EWounded_legs)

#define HSleepy u.uprops[SLEEPY].intrinsic
#define ESleepy u.uprops[SLEEPY].extrinsic
#define Sleepy (HSleepy || ESleepy)

#define HHunger u.uprops[HUNGER].intrinsic
#define EHunger u.uprops[HUNGER].extrinsic
#define Hunger (HHunger || EHunger)

/*** Vision and senses ***/
#define HSee_invisible u.uprops[SEE_INVIS].intrinsic
#define ESee_invisible u.uprops[SEE_INVIS].extrinsic
#define See_invisible (HSee_invisible || ESee_invisible)

#define HTelepat u.uprops[TELEPAT].intrinsic
#define ETelepat u.uprops[TELEPAT].extrinsic
#define Blind_telepat (HTelepat || ETelepat)
#define Unblind_telepat (ETelepat)

#define HWarning u.uprops[WARNING].intrinsic
#define EWarning u.uprops[WARNING].extrinsic
#define Warning (HWarning || EWarning)

/* Warning for a specific type of monster */
#define HWarn_of_mon u.uprops[WARN_OF_MON].intrinsic
#define EWarn_of_mon u.uprops[WARN_OF_MON].extrinsic
#define Warn_of_mon (HWarn_of_mon || EWarn_of_mon)

#define HUndead_warning u.uprops[WARN_UNDEAD].intrinsic
#define Undead_warning (HUndead_warning)

#define HSearching u.uprops[SEARCHING].intrinsic
#define ESearching u.uprops[SEARCHING].extrinsic
#define Searching (HSearching || ESearching)

#define HClairvoyant u.uprops[CLAIRVOYANT].intrinsic
#define EClairvoyant u.uprops[CLAIRVOYANT].extrinsic
#define BClairvoyant u.uprops[CLAIRVOYANT].blocked
#define Clairvoyant ((HClairvoyant || EClairvoyant) && !BClairvoyant)

#define HInfravision u.uprops[INFRAVISION].intrinsic
#define EInfravision u.uprops[INFRAVISION].extrinsic
#define Infravision (HInfravision || EInfravision)

#define HDetect_monsters u.uprops[DETECT_MONSTERS].intrinsic
#define EDetect_monsters u.uprops[DETECT_MONSTERS].extrinsic
#define Detect_monsters (HDetect_monsters || EDetect_monsters)

/*** Appearance and behavior ***/
#define Adornment u.uprops[ADORNED].extrinsic

#define HInvis u.uprops[INVIS].intrinsic
#define EInvis u.uprops[INVIS].extrinsic
#define BInvis u.uprops[INVIS].blocked
#define Invis ((HInvis || EInvis) && !BInvis)
#define Invisible (Invis && !See_invisible)
/* Note: invisibility also hides inventory and steed */

#define EDisplaced u.uprops[DISPLACED].extrinsic
#define Displaced EDisplaced

#define HStealth u.uprops[STEALTH].intrinsic
#define EStealth u.uprops[STEALTH].extrinsic
#define BStealth u.uprops[STEALTH].blocked
#define Stealth ((HStealth || EStealth) && !BStealth)

#define HAggravate_monster u.uprops[AGGRAVATE_MONSTER].intrinsic
#define EAggravate_monster u.uprops[AGGRAVATE_MONSTER].extrinsic
#define Aggravate_monster (HAggravate_monster || EAggravate_monster)

#define HConflict u.uprops[CONFLICT].intrinsic
#define EConflict u.uprops[CONFLICT].extrinsic
#define Conflict (HConflict || EConflict)

/*** Transportation ***/
#define HJumping u.uprops[JUMPING].intrinsic
#define EJumping u.uprops[JUMPING].extrinsic
#define Jumping (HJumping || EJumping)

#define HTeleportation u.uprops[TELEPORT].intrinsic
#define ETeleportation u.uprops[TELEPORT].extrinsic
#define Teleportation (HTeleportation || ETeleportation)

#define HTeleport_control u.uprops[TELEPORT_CONTROL].intrinsic
#define ETeleport_control u.uprops[TELEPORT_CONTROL].extrinsic
#define Teleport_control (HTeleport_control || ETeleport_control)

#define HLevitation u.uprops[LEVITATION].intrinsic
#define ELevitation u.uprops[LEVITATION].extrinsic
#define BLevitation u.uprops[LEVITATION].blocked
#define Levitation ((HLevitation || ELevitation) && !BLevitation)
/* Can't touch surface, can't go under water; overrides all others */
#define Lev_at_will                                                    \
(((HLevitation & I_SPECIAL) != 0L || (ELevitation & W_ARTI) != 0L) \
&& (HLevitation & ~(I_SPECIAL | TIMEOUT)) == 0L                   \
&& (ELevitation & ~W_ARTI) == 0L)

#define HFlying u.uprops[FLYING].intrinsic
#define EFlying u.uprops[FLYING].extrinsic
#define BFlying u.uprops[FLYING].blocked
#define Flying                                                      \
((HFlying || EFlying || (u.usteed && is_flyer(u.usteed->data))) \
&& !BFlying)
/* May touch surface; does not override any others */

#define Wwalking (u.uprops[WWALKING].extrinsic && !Is_waterlevel(&u.uz))
/* Don't get wet, can't go under water; overrides others except levitation */
/* Wwalking is meaningless on water level */

#define HSwimming u.uprops[SWIMMING].intrinsic
#define ESwimming u.uprops[SWIMMING].extrinsic /* [Tom] */
#define Swimming \
(HSwimming || ESwimming || (u.usteed && is_swimmer(u.usteed->data)))
/* Get wet, don't go under water unless if amphibious */

#define HMagical_breathing u.uprops[MAGICAL_BREATHING].intrinsic
#define EMagical_breathing u.uprops[MAGICAL_BREATHING].extrinsic
#define Amphibious \
(HMagical_breathing || EMagical_breathing || amphibious(youmonst.data))
/* Get wet, may go under surface */

#define Breathless \
(HMagical_breathing || EMagical_breathing || breathless(youmonst.data))

#define Underwater (u.uinwater)
/* Note that Underwater and u.uinwater are both used in code.
The latter form is for later implementation of other in-water
states, like swimming, wading, etc. */

#define HPasses_walls u.uprops[PASSES_WALLS].intrinsic
#define EPasses_walls u.uprops[PASSES_WALLS].extrinsic
#define Passes_walls (HPasses_walls || EPasses_walls)

/*** Physical attributes ***/
#define HSlow_digestion u.uprops[SLOW_DIGESTION].intrinsic
#define ESlow_digestion u.uprops[SLOW_DIGESTION].extrinsic
#define Slow_digestion (HSlow_digestion || ESlow_digestion) /* KMH */

#define HHalf_spell_damage u.uprops[HALF_SPDAM].intrinsic
#define EHalf_spell_damage u.uprops[HALF_SPDAM].extrinsic
#define Half_spell_damage (HHalf_spell_damage || EHalf_spell_damage)


/* Troubles */
#define STUNNED 13
#define CONFUSION 14
#define BLINDED 15
#define DEAF 16
#define SICK 17
#define STONED 18
#define STRANGLED 19
#define VOMITING 20
#define GLIB 21
#define SLIMED 22
#define HALLUC 23
#define HALLUC_RES 24
#define FUMBLING 25
#define WOUNDED_LEGS 26
#define SLEEPY 27
#define HUNGER 28
/* Vision and senses */
#define SEE_INVIS 29
#define TELEPAT 30
#define WARNING 31
#define WARN_OF_MON 32
#define WARN_UNDEAD 33
#define SEARCHING 34
#define CLAIRVOYANT 35
#define INFRAVISION 36
#define DETECT_MONSTERS 37
/* Appearance and behavior */
#define ADORNED 38
#define INVIS 39
#define DISPLACED 40
#define STEALTH 41
#define AGGRAVATE_MONSTER 42
#define CONFLICT 43
/* Transportation */
#define JUMPING 44
#define TELEPORT 45
#define TELEPORT_CONTROL 46
#define LEVITATION 47
#define FLYING 48
#define WWALKING 49
#define SWIMMING 50
#define MAGICAL_BREATHING 51
#define PASSES_WALLS 52
/* Physical attributes */
#define SLOW_DIGESTION 53
#define HALF_SPDAM 54
#define HALF_PHDAM 55
#define REGENERATION 56
#define ENERGY_REGENERATION 57
#define PROTECTION 58
#define PROT_FROM_SHAPE_CHANGERS 59
#define POLYMORPH 60
#define POLYMORPH_CONTROL 61
#define UNCHANGING 62
#define FAST 63
#define REFLECTING 64
#define FREE_ACTION 65
#define FIXED_ABIL 66
#define LIFESAVED 67
*/

var See_invisible: Bool {
	return (HSee_invisible != 0 || ESee_invisible != 0 ||
		perceives(youmonst.data))
}

var HSee_invisible: Int {
	return u.uprops.12.intrinsic
}

var ESee_invisible: Int {
	return u.uprops.12.extrinsic
}

// MARK: Appearance and behavior
var Adornment: Int {
	return u.uprops.9.extrinsic
}

var HInvis: Int {
	return u.uprops.13.intrinsic
}

var EInvis: Int {
	return u.uprops.13.extrinsic
}

var BInvis: Int {
	return u.uprops.13.blocked
}

var Invis: Bool {
	return ((HInvis != 0 || EInvis != 0) && BInvis == 0)
}

var Invisible: Bool {
	return (Invis && !See_invisible)
}

func IS_DOOR(typ: schar) -> Bool {
	return Int32(typ) == DOOR
}

func Is_rogue_level(x: UnsafeMutablePointer<d_level>) -> Bool {
	return on_level(x, &dungeon_topology.d_rogue_level)
}

func Is_knox(x: UnsafeMutablePointer<d_level>) -> Bool {
	return on_level(x, &dungeon_topology.d_knox_level)
}

func Is_sanctum(x: UnsafeMutablePointer<d_level>) -> Bool {
	return on_level(x, &dungeon_topology.d_sanctum_level)
}

func Is_stronghold(x: UnsafeMutablePointer<d_level>) -> Bool {
	return on_level(x, &dungeon_topology.d_stronghold_level)
}

func In_sokoban(x: UnsafeMutablePointer<d_level>) -> Bool {
	return x.memory.dnum == dungeon_topology.d_sokoban_dnum
}

func Is_earthlevel(x: UnsafeMutablePointer<d_level>) -> Bool {
	return on_level(x, &dungeon_topology.d_earth_level)
}

func Is_waterlevel(x: UnsafeMutablePointer<d_level>) -> Bool {
	return on_level(x, &dungeon_topology.d_water_level)
}

func Is_firelevel(x: UnsafeMutablePointer<d_level>) -> Bool {
	return on_level(x, &dungeon_topology.d_fire_level)
}

func Is_airlevel(x: UnsafeMutablePointer<d_level>) -> Bool {
	return on_level(x, &dungeon_topology.d_air_level)
}

func Is_astralevel(x: UnsafeMutablePointer<d_level>) -> Bool {
	return on_level(x, &dungeon_topology.d_astral_level)
}



@inline(__always) func init_nhwindows(argc: UnsafeMutablePointer<Int32>, _ argv: UnsafeMutablePointer<UnsafeMutablePointer<Int8>>) {
	windowprocs.win_init_nhwindows(argc, argv)
}

@inline(__always) func player_selection() {
	windowprocs.win_player_selection()
}

@inline(__always) func askname() {
	windowprocs.win_askname()
}

@inline(__always) func get_nh_event() {
	windowprocs.win_get_nh_event()
}

@inline(__always) func exit_nhwindows(reason: UnsafePointer<Int8>) {
	windowprocs.win_exit_nhwindows(reason)
}

@inline(__always) func suspend_nhwindows(reason: UnsafePointer<Int8>) {
	windowprocs.win_suspend_nhwindows(reason)
}

@inline(__always) func resume_nhwindows() {
	windowprocs.win_resume_nhwindows()
}

@inline(__always) func create_nhwindow(winType: Int32) -> winid {
	return windowprocs.win_create_nhwindow(winType)
}

@inline(__always) func clear_nhwindow(wid: winid) {
	windowprocs.win_clear_nhwindow(wid)
}

@inline(__always) func display_nhwindow(wid: winid, _ block: Bool) {
	windowprocs.win_display_nhwindow(wid, block ? 1 : 0)
}

@inline(__always) func destroy_nhwindow(wid: winid) {
	windowprocs.win_destroy_nhwindow(wid)
}

@inline(__always) func curs(wid: winid, _ x: Int32, _ y: Int32) {
	windowprocs.win_curs(wid, x, y)
}

@inline(__always) func putstr(wid: winid, _ attr: Int32, _ str: UnsafePointer<Int8>) {
	windowprocs.win_putstr(wid, attr, str)
}

@inline(__always) func putmixed(wid: winid, _ attr: Int32, _ str: UnsafePointer<Int8>) {
	windowprocs.win_putmixed(wid, attr, str)
}

func display_file(fileName: UnsafePointer<Int8>, mustExist: Bool) {
	windowprocs.win_display_file(fileName, mustExist ? 1 : 0)
}

/*
#define start_menu (*windowprocs.win_start_menu)
#define add_menu (*windowprocs.win_add_menu)
#define end_menu (*windowprocs.win_end_menu)
#define select_menu (*windowprocs.win_select_menu)
#define message_menu (*windowprocs.win_message_menu)
#define update_inventory (*windowprocs.win_update_inventory)
#define mark_synch (*windowprocs.win_mark_synch)
#define wait_synch (*windowprocs.win_wait_synch)
#ifdef CLIPPING
#define cliparound (*windowprocs.win_cliparound)
#endif
#ifdef POSITIONBAR
#define update_positionbar (*windowprocs.win_update_positionbar)
#endif
#define print_glyph (*windowprocs.win_print_glyph)
#define raw_print (*windowprocs.win_raw_print)
#define raw_print_bold (*windowprocs.win_raw_print_bold)
#define nhgetch (*windowprocs.win_nhgetch)
#define nh_poskey (*windowprocs.win_nh_poskey)
*/
func nhbell() {
	windowprocs.win_nhbell()
}
/*
#define nh_doprev_message (*windowprocs.win_doprev_message)
#define getlin (*windowprocs.win_getlin)
#define get_ext_cmd (*windowprocs.win_get_ext_cmd)
#define number_pad (*windowprocs.win_number_pad)
#define delay_output (*windowprocs.win_delay_output)
*/

