
/datum/action/luxbeest/mimicvoice
	name = "mimicvoice"
	desc = "A luxbeest biological adaptation."
	dna_cost = 1

/datum/action/luxbeest/mimicvoice/sting_action(mob/living/user, mob/living/target)
	. = ..()
	to_chat(user, span_notice("We activate [name]."))
	return TRUE

/datum/action/luxbeest/mimicvoice/Remove
	name = "Remove"
	desc = "A luxbeest biological adaptation."
	dna_cost = 1

/datum/action/luxbeest/mimicvoice/Remove/sting_action(mob/living/user, mob/living/target)
	. = ..()
	to_chat(user, span_notice("We activate [name]."))
	return TRUE

