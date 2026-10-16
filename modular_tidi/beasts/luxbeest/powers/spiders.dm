/datum/action/luxbeest/spiders
	name = "Spider Form"
	desc = "A luxbeest biological adaptation."
	helptext = "Activate this adaptation."
	button_icon_state = "luxbeest"
	dna_cost = 3
	chemical_cost = 20

/datum/action/luxbeest/spiders/sting_action(mob/living/user)
	. = ..()
	to_chat(user, span_notice("We activate [name]."))
	return TRUE
