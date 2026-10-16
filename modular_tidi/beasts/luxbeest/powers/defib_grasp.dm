/datum/action/luxbeest/defib_grasp
	name = "Defibrillator Grasp"
	desc = "We prepare ourselves while in stasis. If one of our enemies attempts to defibrillate us, \
		we will snatch their arms off and instantly finalize our stasis."
	helptext = "This ability is passive, and will trigger when a defibrillator paddle is applied to our chest \
		while we are dead or in stasis. Will also stun cyborgs momentarily."
	button_icon_state = "defibrillator_grasp"
	category = "utility"
	owner_has_control = FALSE
	dna_cost = 0
	disabled_by_fire = FALSE

	/// Flags to pass to fully heal when we get zapped
	var/heal_flags = HEAL_DAMAGE|HEAL_BODY|HEAL_STATUS|HEAL_CC_STATUS

/datum/action/luxbeest/defib_grasp/on_purchase(mob/user, is_respec)
	. = ..()
	RegisterSignal(user, COMSIG_DEFIBRILLATOR_PRE_HELP_ZAP, PROC_REF(on_defibbed))

/// Signal proc for [COMSIG_DEFIBRILLATOR_PRE_HELP_ZAP].
/datum/action/luxbeest/defib_grasp/proc/on_defibbed(mob/living/carbon/source, mob/living/defibber, obj/item/shockpaddles/defib)
	SIGNAL_HANDLER

	if(source.stat != DEAD && !HAS_TRAIT_FROM(source, TRAIT_FAKEDEATH, LUXBEEST_TRAIT))
		return

	INVOKE_ASYNC(src, PROC_REF(execute_defib), source, defibber, defib)
	return COMPONENT_DEFIB_STOP

/// Executes the defib action, causing the luxbeest to fully heal and get up.
/datum/action/luxbeest/defib_grasp/proc/execute_defib(mob/living/carbon/luxbeest, mob/living/defibber, obj/item/shockpaddles/defib)
	remove_arms(luxbeest, defibber, defib)

	if(luxbeest.stat == DEAD)
		luxbeest.revive(heal_flags)
	else
		luxbeest.fully_heal(heal_flags)

	luxbeest.buckled?.unbuckle_mob(luxbeest) // get us off of stasis beds please
	luxbeest.set_resting(FALSE)
	luxbeest.adjust_jitter(20 SECONDS)
	luxbeest.emote("scream")
	playsound(luxbeest, 'sound/effects/magic/demon_consume.ogg', 50, TRUE)

	// Mimics some real defib stuff (wish this was more generalized)
	playsound(defib, SFX_BODYFALL, 50, TRUE)
	playsound(defib, 'sound/machines/defib/defib_zap.ogg', 75, TRUE, -1)
	playsound(defib, 'sound/machines/defib/defib_success.ogg', 50, FALSE) // I guess
	defib.shock_pulling(30, luxbeest)

/// Removes the arms of the defibber if they're a carbon, and stuns them for a bit.
/// If they're a cyborg, they'll just get stunned instead.
/datum/action/luxbeest/defib_grasp/proc/remove_arms(mob/living/carbon/luxbeest, mob/living/defibber, obj/item/shockpaddles/defib)

	if(iscyborg(defibber))
		if(defibber.flash_act(affect_silicon = TRUE))
			to_chat(defibber, span_userdanger("[luxbeest] awakens suddenly, overloading your sensors!"))
			// run default visible message regardless, no overt indication of the cyborg being overloaded to watchers

	else
		defibber.Stun(4 SECONDS) // stuck defibbing

		if(iscarbon(defibber))
			var/removed_arms = 0
			var/mob/living/carbon/carbon_defibber = defibber
			for(var/obj/item/bodypart/arm/limb in carbon_defibber.get_bodyparts())
				if(limb.dismember(silent = FALSE))
					removed_arms++
					qdel(limb)

			if(removed_arms)
				// OH GOOD HEAVENS
				defibber.adjust_jitter(3 MINUTES)
				defibber.adjust_dizzy(1 MINUTES)
				defibber.adjust_stutter(1 MINUTES)
				defibber.adjust_eye_blur(10 SECONDS)
				defibber.emote("scream")

				luxbeest.visible_message(
					span_bolddanger("[luxbeest] awakens suddenly, snatching [defib] out of [defibber]'s hands while ripping off [removed_arms >= 2 ? "" : "one of "][defibber.p_their()] arms!"),
					vision_distance = COMBAT_MESSAGE_RANGE,
					ignored_mobs = list(luxbeest, defibber),
				)
				to_chat(luxbeest, span_notice("The power of [defib] course through us, reviving us from our stasis! \
					With this newfound energy, we snap [removed_arms >= 2 ? "" : "one of "][defibber]'s arms off!"))
				to_chat(defibber, span_userdanger("[luxbeest] awakens suddenly, snapping [removed_arms >= 2 ? "" : "one of "]your arms off!"))
				return // no default message if we got an arm

	luxbeest.visible_message(
		span_bolddanger("[luxbeest] awakens suddenly!"),
		vision_distance = COMBAT_MESSAGE_RANGE,
		ignored_mobs = luxbeest,
	)
	to_chat(luxbeest, span_notice("The power of [defib] course through us, reviving us from our stasis!"))
