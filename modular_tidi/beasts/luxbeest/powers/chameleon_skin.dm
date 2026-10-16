/datum/action/luxbeest/chameleon_skin
	name = "Chameleon Skin"
	desc = "We adjust our surface coloration to blend into the surroundings."
	helptext = "Toggle a subtle camouflage effect."
	button_icon_state = "chameleon_skin"
	chemical_cost = 0
	dna_cost = 2
	active = FALSE

/datum/action/luxbeest/chameleon_skin/sting_action(mob/living/user)
	. = ..()
	active = !active
	user.alpha = active ? 180 : initial(user.alpha)
	to_chat(user, span_notice(active ? "Our skin fades into the surroundings." : "Our skin returns to normal."))
	return TRUE

/datum/action/luxbeest/chameleon_skin/Remove(mob/living/user)
	. = ..()
	if(user)
		user.alpha = initial(user.alpha)
	return .
