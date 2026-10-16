/datum/action/luxbeest/strained_muscles
	name = "Strained Muscles"
	desc = "A luxbeest biological adaptation."
	helptext = "Activate this adaptation."
	button_icon_state = "luxbeest"
	dna_cost = 2
	chemical_cost = 0

/datum/action/luxbeest/strained_muscles/sting_action(mob/living/user)
	. = ..()
	to_chat(user, span_notice("We activate [name]."))
	return TRUE
