/datum/action/luxbeest/pheromone_receptors
	name = "Pheromone Receptors"
	desc = "A luxbeest biological adaptation."
	helptext = "Activate this adaptation."
	button_icon_state = "luxbeest"
	dna_cost = 2
	chemical_cost = 0

/datum/action/luxbeest/pheromone_receptors/sting_action(mob/living/user)
	. = ..()
	to_chat(user, span_notice("We activate [name]."))
	return TRUE
