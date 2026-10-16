/datum/action/luxbeest/sting
	name = "Sting"


/datum/action/luxbeest/sting/proc/unset_sting(mob/user)
	var/datum/beast/luxbeest/beast = is_luxbeest(user)
	if(beast)
		beast.chosen_sting = null
