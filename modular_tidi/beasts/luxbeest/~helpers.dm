/// Helper to format the text that gets thrown onto the chem hud element.
#define FORMAT_CHEM_MAX_TEXT(charges) MAPTEXT("<div align='center' valign='middle' style='position:relative; top:0px; left:6px'><font color='#dd2828'>[round(charges)]</font></div>")
#define FORMAT_CHEM_CHARGES_TEXT(charges) MAPTEXT("<div align='center' valign='middle' style='position:relative; top:0px; left:6px'><font color='#dd66dd'>[round(charges)]</font></div>")
#define LUXBEEST_POWER_INNATE -1
#define LUXBEEST_POWER_UNOBTAINABLE -2
#define LUXBEEST_TRAIT "luxbeest"
#define TRAIT_LUXBEEST_HIVEMIND "luxbeest_hivemind"

/proc/is_luxbeest(mob)
	var/mob/living/L = mob
	var/datum/antagonist/beast/luxbeest/antag = L?.mind?.has_antag_datum(/datum/antagonist/beast/luxbeest)
	return antag?.beast
