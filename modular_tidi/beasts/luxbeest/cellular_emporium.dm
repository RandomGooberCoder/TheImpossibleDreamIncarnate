// Cellular Emporium -
// The place where luxbeests go to purchase biological weaponry.
/datum/cellular_emporium
	/// The name of the emporium - why does it need a name? Dunno
	var/name = "cellular emporium"
	/// The luxbeest who owns this emporium
	var/datum/beast/luxbeest/luxbeest

/datum/cellular_emporium/New(my_luxbeest)
	. = ..()
	luxbeest = my_luxbeest

/datum/cellular_emporium/Destroy()
	luxbeest = null
	return ..()

/datum/cellular_emporium/ui_state(mob/user)
	return GLOB.always_state

/datum/cellular_emporium/ui_status(mob/user, datum/ui_state/state)
	if(!luxbeest)
		return UI_CLOSE
	return UI_INTERACTIVE

/datum/cellular_emporium/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CellularEmporium", name)
		ui.open()

/datum/cellular_emporium/ui_static_data(mob/user)
	var/list/data = list()

	var/static/list/abilities
	if(isnull(abilities))
		abilities = list()
		for(var/datum/action/luxbeest/ability_path as anything in luxbeest.all_powers)
			var/dna_cost = initial(ability_path.dna_cost)
			if(dna_cost < 0) // 0 = free, but negatives are invalid
				continue

			var/list/ability_data = list(
				"name" = initial(ability_path.name),
				"desc" = initial(ability_path.desc),
				"icon" = initial(ability_path.button_icon_state),
				"helptext" = initial(ability_path.helptext),
				"path" = ability_path,
				"genetic_point_required" = dna_cost,
				"absorbs_required" = initial(ability_path.req_absorbs),
				"dna_required" = initial(ability_path.req_dna),
				"category" = initial(ability_path.category),
			)

			abilities += list(ability_data)

		sortTim(abilities, /proc/cmp_name_asc)

	data["abilities"] = abilities
	return data

/datum/cellular_emporium/ui_data(mob/user)
	var/list/data = list()

	data["can_readapt"] = luxbeest.can_respec
	data["owned_abilities"] = assoc_to_keys(luxbeest.purchased_powers)
	data["genetic_points_count"] = luxbeest.genetic_points
	data["absorb_count"] = luxbeest.true_absorbs
	data["dna_count"] = luxbeest.absorbed_count

	return data

/datum/cellular_emporium/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("readapt")
			if(luxbeest.can_respec)
				luxbeest.readapt()

		if("evolve")
			// purchase_power sanity checks stuff like typepath, DNA, and absorbs for us.
			luxbeest.purchase_power(text2path(params["path"]))

	return TRUE

/datum/action/cellular_emporium
	name = "Cellular Emporium"
	//button_icon = 'icons/obj/drinks/soda.dmi'
	button_icon_state = "heal"
	background_icon_state = "bg_changeling"
	overlay_icon_state = "bg_changeling_border"
	check_flags = NONE

/datum/action/cellular_emporium/New(Target)
	. = ..()
	if(!istype(Target, /datum/cellular_emporium))
		stack_trace("cellular_emporium action created with non-emporium.")
		qdel(src)

/datum/action/cellular_emporium/Trigger(mob/clicker, trigger_flags)
	. = ..()
	if(!.)
		return
	target.ui_interact(owner)
