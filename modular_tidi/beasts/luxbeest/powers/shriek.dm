/datum/action/luxbeest/resonant_shriek
	name = "Resonant Shriek"
	desc = "A luxbeest biological adaptation."
	helptext = "Activate this adaptation."
	button_icon_state = "luxbeest"
	dna_cost = 2
	chemical_cost = 15

/datum/action/luxbeest/resonant_shriek/sting_action(mob/living/user)
	. = ..()
	to_chat(user, span_notice("We activate [name]."))
	return TRUE
