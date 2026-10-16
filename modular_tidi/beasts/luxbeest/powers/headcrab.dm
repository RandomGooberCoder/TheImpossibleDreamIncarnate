
/datum/action/luxbeest/headcrab
	name = "headcrab"
	desc = "A luxbeest biological adaptation."
	dna_cost = 1

/datum/action/luxbeest/headcrab/sting_action(mob/living/user, mob/living/target)
	. = ..()
	to_chat(user, span_notice("We activate [name]."))
	return TRUE

/datum/action/luxbeest/headcrab/can_be_used_by
	name = "can be used by"
	desc = "A luxbeest biological adaptation."
	dna_cost = 1

/datum/action/luxbeest/headcrab/can_be_used_by/sting_action(mob/living/user, mob/living/target)
	. = ..()
	to_chat(user, span_notice("We activate [name]."))
	return TRUE

