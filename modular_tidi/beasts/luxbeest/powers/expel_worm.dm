
/datum/action/luxbeest/expel_worm
	name = "expel worm"
	desc = "A luxbeest biological adaptation."
	dna_cost = 1

/datum/action/luxbeest/expel_worm/sting_action(mob/living/user, mob/living/target)
	. = ..()
	to_chat(user, span_notice("We activate [name]."))
	return TRUE

