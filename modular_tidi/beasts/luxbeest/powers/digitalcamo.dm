/datum/action/luxbeest/digitalcamo
	name = "Digital Camouflage"
	desc = "A luxbeest biological adaptation."
	helptext = "Activate this adaptation."
	button_icon_state = "luxbeest"
	dna_cost = 1
	chemical_cost = 0

/datum/action/luxbeest/digitalcamo/sting_action(mob/living/user)
	. = ..()
	to_chat(user, span_notice("We activate [name]."))
	return TRUE
