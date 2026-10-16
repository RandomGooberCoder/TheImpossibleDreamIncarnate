
/datum/action/luxbeest/fakedeath
	name = "fakedeath"
	desc = "A luxbeest biological adaptation."
	dna_cost = 1

/datum/action/luxbeest/fakedeath/sting_action(mob/living/user, mob/living/target)
	. = ..()
	to_chat(user, span_notice("We activate [name]."))
	return TRUE

/datum/action/luxbeest/fakedeath/apply_button_icon
	name = "apply button icon"
	desc = "A luxbeest biological adaptation."
	dna_cost = 1

/datum/action/luxbeest/fakedeath/apply_button_icon/sting_action(mob/living/user, mob/living/target)
	. = ..()
	to_chat(user, span_notice("We activate [name]."))
	return TRUE

/datum/action/luxbeest/fakedeath/update_button_name
	name = "update button name"
	desc = "A luxbeest biological adaptation."
	dna_cost = 1

/datum/action/luxbeest/fakedeath/update_button_name/sting_action(mob/living/user, mob/living/target)
	. = ..()
	to_chat(user, span_notice("We activate [name]."))
	return TRUE

