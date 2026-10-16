/datum/beast/luxbeest
	/// list of datum/luxbeest_profile
	var/list/stored_profiles = list()
	/// The original profile of this luxbeest.
	var/datum/luxbeest_profile/first_profile = null
	/// How many lux the beest can store for transformation.
	var/lux_max = 6
	/// The amount of lux absorbed, includes identity
	var/absorbed_count = 0
	/// The amount of lux gained using absorb, not identity sting. Start with one (your original identity/lux)
	var/true_absorbs = 0

	/// The number of chemicals the luxbeest currently has.
	var/chem_charges = 20
	/// The max chemical storage the luxbeest currently has.
	var/total_chem_storage = 75
	/// The chemical recharge rate per life tick.
	var/chem_recharge_rate = 1
	/// Any additional modifiers triggered by luxbeests that modify the chem_recharge_rate.
	var/chem_recharge_slowdown = 0
	/// The range this beest can sting things.
	var/sting_range = 2
	/// luxbeest name, what other lings see over the hivemind when talking.
	var/luxbeestname = "Snort"

	/// The number of genetics points (to buy powers) this beest currently has.
	var/genetic_points = 10
	/// The max number of genetics points (to buy powers) this beest can have.
	var/total_genetic_points = 10
	/// List of all powers we start with.
	var/list/innate_powers = list()
	/// Associated list of all powers we have evolved / bought from the emporium. [path] = [instance of path]
	var/list/purchased_powers = list()

	/// The voice we're mimicing via the beest voice ability.
	var/mimicing = ""
	/// Whether we can currently respec in the cellular emporium.
	var/can_respec = 0

	/// The currently active luxbeest sting.
	var/datum/action/luxbeest/chosen_sting
	/// A reference to our cellular emporium datum.
	var/datum/cellular_emporium/cellular_emporium
	/// A reference to our cellular emporium action (which opens the UI for the datum).
	var/datum/action/cellular_emporium/emporium_action

	/// The name of our "hive" that our ling came from. Flavor.
	var/hive_name

	/// Static typecache of all luxbeest powers that are usable.
	var/static/list/all_powers = typecacheof(/datum/action/luxbeest, ignore_root_path = TRUE)

	/// Static list of possible names. Initialized into the greek alphabet the first time it is used
	var/static/list/possible_luxbeest_names

	/// Flesh item types used while changing profile.
	var/static/list/slot2type = list(
		"head" = /obj/item/clothing/head/luxbeest,
		"wear_mask" = /obj/item/clothing/mask/luxbeest,
		"wear_neck" = /obj/item/luxbeest,
		"back" = /obj/item/luxbeest,
		"wear_suit" = /obj/item/clothing/suit/luxbeest,
		"w_uniform" = /obj/item/clothing/under/luxbeest,
		"shoes" = /obj/item/clothing/shoes/luxbeest,
		"belt" = /obj/item/luxbeest,
		"gloves" = /obj/item/clothing/gloves/luxbeest,
		"glasses" = /obj/item/clothing/glasses/luxbeest,
		"ears" = /obj/item/luxbeest,
		"wear_id" = /obj/item/luxbeest/id,
		"s_store" = /obj/item/luxbeest,
	)


	/// A list of all memories we've stolen through absorbs.
	var/list/stolen_memories = list()

	///	Keeps track of the currently selected profile.
	var/datum/luxbeest_profile/current_profile

/datum/beast/luxbeest/New(datum/mind/newuser)
	. = ..()
	hive_name = generate_hive_name()

/proc/generate_hive_name()
	return "hive"

/datum/beast/luxbeest/Destroy()
	QDEL_NULL(emporium_action)
	QDEL_NULL(cellular_emporium)
	current_profile = null
	return ..()

/datum/beast/luxbeest/proc/on_new()
	if(cellular_emporium)
		return
	generate_name()
	create_emporium()
	create_innate_actions()
	create_initial_profile()
	//owner.current.get_language_holder().omnitongue = TRUE

/datum/beast/luxbeest/proc/generate_name()
	var/honorific = "Mx."

	if(!possible_luxbeest_names)
		possible_luxbeest_names = GLOB.greek_letters.Copy()
	if(possible_luxbeest_names.len)
		luxbeestname = "[honorific] [pick_n_take(possible_luxbeest_names)]"
	else
		luxbeestname = "[honorific] [rand(1,999)]"

/*
 * Instantiate the cellular emporium for the luxbeest.
 */
/datum/beast/luxbeest/proc/create_emporium()
	cellular_emporium = new(src)
	emporium_action = new(cellular_emporium)
	emporium_action.Grant(owner.current)

/*
 * Instantiate all the default actions of a ling (transform, dna sting, absorb, etc)
 * Any luxbeest action with dna_cost = LUXBEEST_POWER_INNATE will be added here automatically
 */
/datum/beast/luxbeest/proc/create_innate_actions()
	for(var/datum/action/luxbeest/path as anything in all_powers)
		if(initial(path.dna_cost) != LUXBEEST_POWER_INNATE)
			continue

		var/datum/action/luxbeest/innate_ability = new path()
		innate_powers += innate_ability
		innate_ability.on_purchase(owner.current, TRUE)

/*
 * Create a profile based on the luxbeest's initial appearance.
 */
/datum/beast/luxbeest/proc/create_initial_profile()
	if(!ishuman(owner.current))
		return

	add_new_profile(owner.current)

/*
 * Add a new profile to our luxbeest's profile list.
 * Pops the first profile in the list if we're above our limit of profiles.
 *
 * new_profile - the profile being added.
 */
/datum/beast/luxbeest/proc/add_profile(datum/luxbeest_profile/new_profile)
	if(stored_profiles.len > lux_max)
		if(!push_out_profile())
			return

	if(!first_profile)
		first_profile = new_profile
		current_profile = first_profile

	stored_profiles += new_profile
	absorbed_count++

/*
 * Create a new profile from the given [profile_target]
 * and add it to our profile list via add_profile.
 *
 * profile_target - the human we're making a profile based off of
 * protect - if TRUE, mark the new profile as protected. If protected, it cannot be removed / popped from the profile list (without force).
 */
/datum/beast/luxbeest/proc/add_new_profile(mob/living/carbon/human/profile_target, protect = FALSE)
	var/datum/luxbeest_profile/new_profile = create_profile(profile_target, protect)
	add_profile(new_profile)
	return new_profile

/*
 * Remove a given profile from the profile list.
 *  *
 * profile_target - the human we want to remove from our profile list (looks for a profile with a matching name)
 * force - if TRUE, removes the profile even if it's protected.
 */
/datum/beast/luxbeest/proc/remove_profile(mob/living/carbon/human/profile_target, force = FALSE)
	for(var/datum/luxbeest_profile/found_profile as anything in stored_profiles)
		if(profile_target.real_name == found_profile.name)
			if(found_profile.protected && !force)
				continue
			stored_profiles -= found_profile
			qdel(found_profile)

/*
 * Removes the highest luxbeest profile from the list
 * that isn't protected and returns TRUE if successful.
 *
 * Returns TRUE if a profile was removed, FALSE otherwise.
 */
/datum/beast/luxbeest/proc/push_out_profile()
	var/datum/luxbeest_profile/profle_to_remove
	for(var/datum/luxbeest_profile/found_profile as anything in stored_profiles)
		if(!found_profile.protected)
			profle_to_remove = found_profile
			break

	if(profle_to_remove)
		stored_profiles -= profle_to_remove
		return TRUE
	return FALSE

/*
 * Create a new luxbeest profile datum based off of [target].
 *
 * target - the human we're basing the new profile off of.
 * protect - if TRUE, set the new profile to protected, preventing it from being removed (without force).
 */
/datum/beast/luxbeest/proc/create_profile(mob/living/carbon/human/target, protect = 0)
	var/datum/luxbeest_profile/new_profile = new()

	target.dna.real_name = target.real_name //Set this again, just to be sure that it's properly set.

	// Set up a copy of their DNA in our profile.
	var/datum/dna/new_dna = new target.dna.type()
	target.dna.copy_dna(new_dna)
	new_profile.dna = new_dna
	new_profile.name = target.real_name
	new_profile.protected = protect

	new_profile.age = target.age

	// Clothes, of course
	new_profile.underwear = target.underwear
	new_profile.socks = target.socks

	// Make an icon snapshot of what they currently look like
	var/datum/icon_snapshot/entry = new()
	entry.name = target.name
	entry.icon = target.icon
	entry.icon_state = target.icon_state
	entry.overlays = target.get_overlays_copy(list(HANDS_LAYER, HANDCUFF_LAYER, LEGCUFF_LAYER))
	new_profile.profile_snapshot = entry

	var/list/slots = list("head", "wear_mask", "wear_neck", "back", "wear_suit", "w_uniform", "shoes", "belt", "gloves", "glasses", "ears", "wear_id", "s_store")
	for(var/slot in slots)
		if(!(slot in target.vars))
			continue
		var/obj/item/clothing/clothing_item = target.vars[slot]
		if(!clothing_item)
			continue
		new_profile.name_list[slot] = clothing_item.name
		new_profile.appearance_list[slot] = clothing_item.appearance
		new_profile.flags_cover_list[slot] = clothing_item.flags_cover
		new_profile.lefthand_file_list[slot] = clothing_item.lefthand_file
		new_profile.righthand_file_list[slot] = clothing_item.righthand_file
		new_profile.exists_list[slot] = 1

	return new_profile

/*
 * luxbeest's ability to re-adapt all of their learned powers.
 */
/datum/beast/luxbeest/proc/readapt()
	//if(!ishuman(owner.current) || HAS_TRAIT(owner.current, TRAIT_LESSER_HUMANOID))
	//	to_chat(owner.current, span_warning("We can't remove our evolutions in this form!"))
	//	return FALSE

	//if(HAS_TRAIT_FROM(owner.current, TRAIT_DEATHCOMA, LUXBEEST_TRAIT))
	//	to_chat(owner.current, span_warning("We are too busy reforming ourselves to readapt right now!"))
	//	return FALSE

	if(!can_respec)
		to_chat(owner.current, span_warning("You lack the power to readapt your evolutions!"))
		return FALSE

	to_chat(owner.current, span_notice("We have removed our evolutions from this form, and are now ready to readapt."))
	//remove_luxbeest_powers()
	can_respec -= 1
	SSblackbox.record_feedback("tally", "LUXBEEST_POWER_purchase", 1, "Readapt")
	//log_luxbeest_power("[key_name(owner)] readapted their luxbeest powers")
	return TRUE

/*
 * The act of purchasing a certain power for a luxbeest.
 *
 * [sting_path] - the power that's being purchased / evolved.
 */
/datum/beast/luxbeest/proc/purchase_power(datum/action/luxbeest/sting_path)
	if(!ispath(sting_path, /datum/action/luxbeest))
		CRASH("luxbeest purchase_power attempted to purchase an invalid typepath! (got: [sting_path])")

	if(purchased_powers[sting_path])
		to_chat(owner.current, span_warning("We have already evolved this ability!"))
		return FALSE

	if(genetic_points < initial(sting_path.dna_cost))
		to_chat(owner.current, span_warning("We have reached our capacity for abilities!"))
		return FALSE

	if(absorbed_count < initial(sting_path.req_dna))
		to_chat(owner.current, span_warning("We lack the DNA to evolve this ability!"))
		return FALSE

	if(true_absorbs < initial(sting_path.req_absorbs))
		to_chat(owner.current, span_warning("We lack the absorbed DNA to evolve this ability!"))
		return FALSE

	if(initial(sting_path.dna_cost) < 0)
		to_chat(owner.current, span_warning("We cannot evolve this ability!"))
		return FALSE

	//To avoid potential exploits by buying new powers while in stasis, which clears your verblist. // Probably not a problem anymore, but whatever.
	if(HAS_TRAIT(owner.current, TRAIT_DEATHCOMA))
		to_chat(owner.current, span_warning("We lack the energy to evolve new abilities right now!"))
		return FALSE

	var/success = give_power(sting_path)
	if(success)
		genetic_points -= initial(sting_path.dna_cost)
	return success

/**
 * Gives a passed luxbeest power datum to the player
 *
 * Is passed a path to a luxbeest power, and applies it to the user.
 * If successful, we return TRUE, otherwise not.
 *
 * Arguments:
 * * power_path - The path of the power we will be giving to our attached player.
 */

/datum/beast/luxbeest/proc/give_power(power_path)
	var/datum/action/luxbeest/new_action = new power_path()

	if(!new_action)
		to_chat(owner.current, "This is awkward. luxbeest power purchase failed, please report this bug to a coder!")
		CRASH("luxbeest give_power was unable to grant a new luxbeest action for path [power_path]!")

	purchased_powers[power_path] = new_action
	new_action.on_purchase(owner.current) // Grant() is ran in this proc, see luxbeest_powers.dm.
	//log_luxbeest_power("[key_name(owner)] adapted the [new_action.name] power")
	SSblackbox.record_feedback("tally", "LUXBEEST_POWER_purchase", 1, new_action.name)

	return TRUE


/datum/beast/luxbeest/proc/adjust_chemicals(amount, override_cap)
	if(!isnum(amount))
		return
	chem_charges = clamp(chem_charges + amount, 0, isnum(override_cap) ? override_cap : total_chem_storage)

/datum/beast/luxbeest/proc/remove_luxbeest_powers(include_innate = FALSE)
	QDEL_LIST_ASSOC_VAL(purchased_powers)
	if(include_innate)
		QDEL_LIST(innate_powers)
	chosen_sting = null
	genetic_points = total_genetic_points

/datum/beast/luxbeest/proc/regain_powers()
	if(emporium_action)
		emporium_action.Grant(owner.current)
	for(var/datum/action/luxbeest/power as anything in innate_powers)
		power.on_purchase(owner.current)
