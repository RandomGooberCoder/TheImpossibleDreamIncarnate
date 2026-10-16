/datum/action/luxbeest/regenerate
	name = "Regenerate"
	desc = "A luxbeest biological adaptation."
	helptext = "Activate this adaptation."
	button_icon_state = "luxbeest"
	chemical_cost = 10
	dna_cost = -1 //CHANGELING_POWER_INNATE

/datum/action/luxbeest/regenerate/sting_action(mob/living/user)
	. = ..()
	to_chat(user, span_notice("We activate [name]."))
	return TRUE


/datum/action/changeling/regenerate/sting_action(mob/living/user)
	if(!iscarbon(user))
		user.balloon_alert(user, "nothing missing!")
		return FALSE

	..()
	to_chat(user, span_notice("You feel an itching, both inside and outside as your tissues knit and reknit."))
	var/mob/living/carbon/carbon_user = user
	var/got_limbs_back = length(carbon_user.get_missing_limbs()) >= 1
	carbon_user.fully_heal(HEAL_BODY)
	// Occurs after fully heal so the ling themselves can hear the sound effects (if deaf prior)
	if(got_limbs_back)
		playsound(user, 'sound/effects/magic/demon_consume.ogg', 50, TRUE)
		carbon_user.visible_message(
			span_warning("[user]'s missing limbs reform, making a loud, grotesque sound!"),
			span_userdanger("Your limbs regrow, making a loud, crunchy sound and giving you great pain!"),
			span_hear("You hear organic matter ripping and tearing!"),
		)
		carbon_user.emote("scream")

	return TRUE
