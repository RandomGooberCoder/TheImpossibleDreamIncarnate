
/datum/action/luxbeest/lesserform
	name = "lesserform"
	desc = "A luxbeest biological adaptation."
	dna_cost = 1

/datum/action/luxbeest/lesserform/sting_action(mob/living/user, mob/living/target)
	. = ..()
	to_chat(user, span_notice("We activate [name]."))
	return TRUE

/datum/action/luxbeest/lesserform/apply_button_icon
	name = "apply button icon"
	desc = "A luxbeest biological adaptation."
	dna_cost = 1

/datum/action/luxbeest/lesserform/apply_button_icon/sting_action(mob/living/user, mob/living/target)
	. = ..()
	to_chat(user, span_notice("We activate [name]."))
	return TRUE

/datum/action/luxbeest/lesserform/Grant
	name = "Grant"
	desc = "A luxbeest biological adaptation."
	dna_cost = 1

/datum/action/luxbeest/lesserform/Grant/sting_action(mob/living/user, mob/living/target)
	. = ..()
	to_chat(user, span_notice("We activate [name]."))
	return TRUE

/datum/action/luxbeest/lesserform/Remove
	name = "Remove"
	desc = "A luxbeest biological adaptation."
	dna_cost = 1

/datum/action/luxbeest/lesserform/Remove/sting_action(mob/living/user, mob/living/target)
	. = ..()
	to_chat(user, span_notice("We activate [name]."))
	return TRUE

/datum/action/luxbeest/lesserform/update_button_name
	name = "update button name"
	desc = "A luxbeest biological adaptation."
	dna_cost = 1

/datum/action/luxbeest/lesserform/update_button_name/sting_action(mob/living/user, mob/living/target)
	. = ..()
	to_chat(user, span_notice("We activate [name]."))
	return TRUE

