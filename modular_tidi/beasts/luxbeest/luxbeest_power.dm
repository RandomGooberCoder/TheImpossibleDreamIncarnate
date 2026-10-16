/datum/action/luxbeest
	abstract_type = /datum/action/luxbeest
	name = "Prototype Pintle-Lyke Proboscis"
	background_icon_state = "bg_changeling"
	overlay_icon_state = "bg_changeling_border"
	button_icon = 'modular_tidi/beasts/icons/actions_changeling.dmi'
	// This build does not ship the upstream luxbeest action icon sheet.
	/// Details displayed in fine print within the luxbeest emporium
	var/helptext = ""
	/// How many luxbeest chems it costs to use
	var/chemical_cost = 0
	/**
	 * Cost of the ability in dna points, negative values are not valid
	 *
	 * Special numbers include [LUXBEEST_POWER_INNATE], which are given to luxbeest for free without bring prompted
	 * and [LUXBEEST_POWER_UNOBTAINABLE], which are not available for purchase in the luxbeest emporium
	 */
	var/dna_cost = LUXBEEST_POWER_UNOBTAINABLE
	/// Amount of dna needed to use this ability. Note, luxbeests always have atleast 1
	var/req_dna = 0
	/// If you need to be humanoid to use this ability (disincludes monkeys)
	var/req_human = FALSE
	/// Similar to req_dna, but only gained from absorbing, not DNA sting
	var/req_absorbs = 0
	/// Action availability checks. See /datum/action/IsAvailable().
	/// Powers that can be used while incapacitated can override this with NONE.
	check_flags = AB_CHECK_CONSCIOUS
	/// usable when the luxbeest is in death coma
	var/ignores_fakedeath = FALSE
	/// used by a few powers that toggle
	var/active = FALSE
	/// Does this ability stop working if you are burning?
	var/disabled_by_fire = TRUE
	///Defines the ability category: 'stings', 'combat', 'stealth', 'utility'
	var/category = "utility"

/*
luxbeest code now relies on on_purchase to grant powers.
if you override it, MAKE SURE you call parent or it will not be usable
the same goes for Remove(). if you override Remove(), call parent or else your power won't be removed on respec
*/

/datum/action/luxbeest/proc/on_purchase(mob/user, is_respec)
	Grant(user)//how powers are added rather than the checks in mob.dm

/datum/action/luxbeest/Trigger(mob/clicker, trigger_flags)
	. = ..()
	if(!.)
		return
	var/mob/user = owner
	if(!user || !is_luxbeest(user))
		return
	try_to_sting(user)

/**
 *Contrary to the name, this proc isn't just used by luxbeest stings. It handles the activation of the action and the deducation of its cost.
 *The order of the proc chain is:
 *can_sting(). Should this fail, the process gets aborted early.
 *sting_action(). This proc usually handles the actual effect of the action.
 *Should sting_action succeed the following will be done:
 *sting_feedback(). Produces feedback on the performed action. Don't ask me why this isn't handled in sting_action()
 *The deduction of the cost of this power.
 *Returns TRUE on a successful activation.
 */
/datum/action/luxbeest/proc/try_to_sting(mob/living/user, mob/living/target)
	if(!can_sting(user, target))
		return FALSE
	if(disabled_by_fire && user.fire_stacks && user.on_fire)
		user.balloon_alert(user, "on fire!")
		return FALSE
	var/datum/beast/luxbeest/luxbeest = is_luxbeest(user)
	if(sting_action(user, target))
		sting_feedback(user, target)
		luxbeest.adjust_chemicals(-chemical_cost)
		user.changeNext_move(CLICK_CD_MELEE)
		return TRUE
	return FALSE

/datum/action/luxbeest/proc/sting_action(mob/living/user, mob/living/target)
	SHOULD_CALL_PARENT(TRUE)
	SSblackbox.record_feedback("nested tally", "luxbeest_powers", 1, list("[name]"))
	return FALSE

/datum/action/luxbeest/proc/sting_feedback(mob/living/user, mob/living/target)
	return FALSE

// Fairly important to remember to return 1 on success >.< // Return TRUE not 1 >.<
/datum/action/luxbeest/proc/can_sting(mob/living/user, mob/living/target)
	if(!IsAvailable())
		return FALSE
	if(!can_be_used_by(user))
		return FALSE
	var/datum/beast/luxbeest/luxbeest = is_luxbeest(user)
	if(!luxbeest || luxbeest.chem_charges < chemical_cost)
		return FALSE
	return TRUE


/datum/action/luxbeest/proc/can_be_used_by(mob/living/user)
	return !!user && ishuman(user)
