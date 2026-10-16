
/datum/action/luxbeest/transform
	name = "transform"
	desc = "A luxbeest biological adaptation."
	dna_cost = 1

/datum/action/luxbeest/transform/sting_action(mob/living/user, mob/living/target)
	. = ..()
	to_chat(user, span_notice("We activate [name]."))
	return TRUE

