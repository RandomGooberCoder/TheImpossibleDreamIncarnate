
/datum/action/luxbeest/absorb_dna
	name = "absorb dna"
	desc = "A luxbeest biological adaptation."
	dna_cost = 1

/datum/action/luxbeest/absorb_dna/sting_action(mob/living/user, mob/living/target)
	. = ..()
	to_chat(user, span_notice("We activate [name]."))
	return TRUE

/datum/action/luxbeest/eject_from_hivemind
	name = "eject from hivemind"
	desc = "A luxbeest biological adaptation."
	dna_cost = 1

/datum/action/luxbeest/eject_from_hivemind/sting_action(mob/living/user, mob/living/target)
	. = ..()
	to_chat(user, span_notice("We activate [name]."))
	return TRUE

