/// Antagonist registration for the luxbeest mechanics datum.
/datum/antagonist/beast/luxbeest
	name = "Luxbeest"
	roundend_category = "luxbeests"
	antagpanel_category = "Luxbeest"
	job_rank = ROLE_LUXBEEST
	storyteller_antag_flags = STORYTELLER_ANTAG_VILLAIN | STORYTELLER_ANTAG_ROUNDSTART
	confess_lines = list()
	rogue_enabled = TRUE

	var/datum/beast/luxbeest/beast

/datum/antagonist/beast/luxbeest/get_antag_cap_weight()
	return 3

/datum/antagonist/beast/luxbeest/on_gain()
	if(!beast)
		beast = new(owner)
		beast.on_new()
	return ..()

/datum/antagonist/beast/luxbeest/apply_innate_effects(mob/living/mob_override)
	if(beast)
		beast.regain_powers()

/datum/antagonist/beast/luxbeest/remove_innate_effects(mob/living/mob_override)
	return

/datum/antagonist/beast/luxbeest/on_removal()
	if(beast)
		beast.remove_luxbeest_powers(TRUE)
		qdel(beast)
		beast = null
	return ..()

/datum/antagonist/beast/luxbeest/farewell()
	if(owner?.current)
		to_chat(owner.current, span_userdanger("You lose your luxbeest powers and remain in your current form."))
