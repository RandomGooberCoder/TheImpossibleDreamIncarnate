/datum/action/luxbeest/biodegrade
	name = "Biodegrade"
	desc = "A luxbeest biological adaptation."
	helptext = "Activate this adaptation."
	button_icon_state = "luxbeest"
	dna_cost = 2
	chemical_cost = 20

/datum/action/luxbeest/biodegrade/sting_action(mob/living/user)
	. = ..()
	to_chat(user, span_notice("We activate [name]."))
	return TRUE
