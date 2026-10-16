#define EGG_INCUBATION_TIME (8 MINUTES)

/// The actual organ that the luxbeest implants into a bearer.
/obj/item/organ/luxbeest_egg
	name = "luxbeest egg"
	desc = "A twitching, developing luxbeest embryo."
	zone = BODY_ZONE_CHEST
	slot = ORGAN_SLOT_PARASITE_EGG
	gender = PLURAL
	w_class = WEIGHT_CLASS_SMALL

	/// The mind of the luxbeest that produced the egg.
	var/datum/mind/origin
	/// When the egg hatches.
	var/hatch_time = 0
	/// When the egg was removed, if it has ever been removed.
	var/removal_time = -1

/obj/item/organ/luxbeest_egg/Initialize(mapload)
	. = ..()
	if(iscarbon(loc))
		Insert(loc)

/obj/item/organ/luxbeest_egg/Insert(mob/living/carbon/egg_bearer, special = FALSE, movement_flags)
	. = ..()
	hatch_time = world.time + (removal_time == -1 ? EGG_INCUBATION_TIME : (hatch_time - removal_time))

/obj/item/organ/luxbeest_egg/Remove(mob/living/carbon/egg_bearer, special, drop_if_replaced)
	. = ..()
	removal_time = world.time

/obj/item/organ/luxbeest_egg/process(seconds_per_tick)
	if(owner && hatch_time <= world.time)
		pop()

/// Once the egg is fully grown, remove it from the bearer.
/obj/item/organ/luxbeest_egg/proc/pop()
	if(owner)
		owner.visible_message(span_warning("[owner] convulses as the luxbeest egg withers away."))
	qdel(src)

#undef EGG_INCUBATION_TIME
