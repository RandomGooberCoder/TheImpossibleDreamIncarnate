// luxbeest profile themselves. Store a data to store what every DNA instance looked like.
/datum/luxbeest_profile
	/// The name of the profile / the name of whoever this profile source.
	var/name = "a bug"
	/// Whether this profile is protected - if TRUE, it cannot be removed from a luxbeest's profiles without force
	var/protected = FALSE
	/// The DNA datum associated with our profile from the profile source
	var/datum/dna/dna
	/// Assoc list of item slot to item name - stores the name of every item of this profile.
	var/list/name_list = list()
	/// Assoc list of item slot to apperance - stores the appearance of every item of this profile.
	var/list/appearance_list = list()
	/// Assoc list of item slot to flag - stores the flags_cover of every item of this profile.
	var/list/flags_cover_list = list()
	/// Assoc list of item slot to boolean - stores whether an item in that slot exists
	var/list/exists_list = list()
	/// Assoc list of item slot to file - stores the lefthand file of the item in that slot
	var/list/lefthand_file_list = list()
	/// Assoc list of item slot to file - stores the righthand file of the item in that slot
	var/list/righthand_file_list = list()
	/// Assoc list of item slot to file - stores the inhand file of the item in that slot
	var/list/inhand_icon_state_list = list()
	/// Assoc list of item slot to file - stores the worn icon file of the item in that slot
	var/list/worn_icon_list = list()
	/// Assoc list of item slot to string - stores the worn icon state of the item in that slot
	var/list/worn_icon_state_list = list()
	/// The underwear worn by the profile source
	var/underwear
	/// The colour of the underwear worn by the profile source
	var/underwear_color
	/// The undershirt worn by the profile source
	var/undershirt
	/// The socks worn by the profile source
	var/socks
	/// A list of paths for any skill chips the profile source had installed
	var/list/skillchips = list()
	/// Icon snapshot of the profile
	var/datum/icon_snapshot/profile_snapshot
	/// ID HUD icon associated with the profile
	var/id_icon
	/// ID HUD icon state associated with the profile
	var/id_icon_state
	/// The age of the profile source.
	var/age
	/// The body type of the profile source.
	var/physique
	/// The athleticism of the profile source.
	var/athletics_level
	/// The quirks of the profile source.
	var/list/quirks = list()
	/// The TTS voice of the profile source
	var/voice
	/// The TTS filter of the profile filter
	var/voice_filter = ""

/datum/luxbeest_profile/Destroy()
	qdel(dna)
	return ..()

/*
 * Copy every aspect of this file into a new instance of a profile.
 * Must be suppied with an instance.
 */
/datum/luxbeest_profile/proc/copy_profile(datum/luxbeest_profile/new_profile)
	new_profile.name = name
	new_profile.protected = protected
	new_profile.dna = new dna.type()
	dna.copy_dna(new_profile.dna)
	new_profile.name_list = name_list.Copy()
	new_profile.appearance_list = appearance_list.Copy()
	new_profile.flags_cover_list = flags_cover_list.Copy()
	new_profile.exists_list = exists_list.Copy()
	new_profile.lefthand_file_list = lefthand_file_list.Copy()
	new_profile.righthand_file_list = righthand_file_list.Copy()
	new_profile.inhand_icon_state_list = inhand_icon_state_list.Copy()
	new_profile.underwear = underwear
	new_profile.underwear_color = underwear_color
	new_profile.undershirt = undershirt
	new_profile.socks = socks
	new_profile.worn_icon_list = worn_icon_list.Copy()
	new_profile.worn_icon_state_list = worn_icon_state_list.Copy()
	new_profile.skillchips = skillchips.Copy()
	new_profile.profile_snapshot = profile_snapshot
	new_profile.id_icon = id_icon
	new_profile.age = age
	new_profile.physique = physique
	new_profile.athletics_level = athletics_level
	new_profile.voice = voice
	new_profile.voice_filter = voice_filter
