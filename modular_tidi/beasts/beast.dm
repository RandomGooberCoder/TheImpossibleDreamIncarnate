/datum/beast/var/datum/mind/owner

/datum/beast/New(datum/mind/newuser)
	if(!istype(newuser))
		CRASH("[type] instantiated without an owner!")
	owner = newuser

/datum/beast/Destroy()
	owner = null
	return ..()
