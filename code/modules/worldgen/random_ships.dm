/**
 * ORIGINAL RANDOM ROOM TEXT, DUE TO BE REPLACED. THIS WHOLE FILE IS NON FUNCTIONAL
 *
 * Wanna make a room for a S P A C E S H I P ???? Cool!!!!!! All you have to do is make your prefab, name it
 * whatever, (has to be either 3x3 or 5x3 for now), and throw it in assets/maps/random_ships/(cargo or room)/size
 * NOTE: ALL PREFABS HAVE TO HAVE THE CLEAR_AREA AREA, AND ALL CARGO PREFABS MUST HAVE BOTH CLEAR_TURF AND CLEAR_AREA <3
 */


TYPEINFO(/datum/mapPrefab/random_ship)
	folder = "random_ships"

/datum/mapPrefab/random_ship
	maxNum = 1 // Might be useful to add a way to override if someone ever wants that

	post_init()
		var/regex/size_regex = regex(@"^(\d+)x(\d+)$")
		for(var/tag in src.tags)
			if(size_regex.Find(tag))
				src.prefabSizeX = text2num(size_regex.group[1])
				src.prefabSizeY = text2num(size_regex.group[2])

		var/filename = filename_from_path(src.prefabPath)
		var/regex/probability_regex = regex(@"^.*_(\d+)\.dmm$")
		if(probability_regex.Find(filename))
			src.probability = text2num(probability_regex.group[1])

/datum/mapPrefab/random_ship
	maxNum = null

	post_init()
		var/regex/size_regex = regex(@"^(\d+)x(\d+)$")
		for(var/tag in src.tags)
			if(size_regex.Find(tag))
				src.prefabSizeX = text2num(size_regex.group[1])
				src.prefabSizeY = text2num(size_regex.group[2])

		var/filename = filename_from_path(src.prefabPath)
		var/regex/probability_regex = regex(@"^.*_(\d+)\.dmm$")
		if(probability_regex.Find(filename))
			src.probability = text2num(probability_regex.group[1])

proc/buildRandomShips() //This is byond a terrible fix which likely doesn't function anyway. A better way to do this would be to create two landmarks, one for the ships and another for the rooms.
	shuffle_list(by_type[/obj/landmark/random_ship])
	for_by_tcl(landmark, /obj/landmark/random_ship)
		landmark.apply()
	shuffle_list(by_type[/obj/landmark/random_ship_room]) //this happens twice, as the first landmark would be the 30x25 which then introduces many other ship landmarks that must be generated
	for_by_tcl(landmark, /obj/landmark/random_ship_room)
		landmark.apply()


/obj/landmark/random_ship_room
	var/size = null
	var/roomclass = null
	deleted_on_start = FALSE
	add_to_landmarks = FALSE

	New()
		..()
		START_TRACKING

	disposing()
		STOP_TRACKING
		..()

	proc/apply()
		var/datum/mapPrefab/random_ship/ship_prefab = pick_map_prefab(/datum/mapPrefab/random_ship, list(roomclass,size))
		if(isnull(ship_prefab))
			CRASH("No random ship prefab found for size: " + size + ", and of type: " + roomclass)
		ship_prefab.applyTo(src.loc)
		logTheThing("debug", null, null, "Applied random ship prefab: [ship_prefab] to [log_loc(src)]")
		qdel(src)

	room3x3
		size = "3x3"
		roomclass = "room"
	#ifdef IN_MAP_EDITOR
		icon = 'icons/map-editing/random-rooms/3x3.dmi'
		icon_state = "cargo"
	#endif

	room5x3
		size = "5x3"
		roomclass = "room"
	#ifdef IN_MAP_EDITOR
		icon = 'icons/map-editing/random-rooms/5x3.dmi'
		icon_state = "cargo"
	#endif

	cargo5x3
		size = "5x3"
		roomclass = "cargo"
	#ifdef IN_MAP_EDITOR
		icon = 'icons/map-editing/random-rooms/5x3.dmi'
		icon_state = "cargo"
	#endif



/obj/landmark/random_ship
	var/size = null
	deleted_on_start = FALSE
	add_to_landmarks = FALSE

	New()
		..()
		START_TRACKING

	disposing()
		STOP_TRACKING
		..()

	proc/apply()
		var/datum/mapPrefab/random_ship/ship_prefab = pick_map_prefab(/datum/mapPrefab/random_ship, list(size))
		if(isnull(ship_prefab))
			CRASH("No random ship prefab found for size: " + size)
		ship_prefab.applyTo(src.loc)
		logTheThing("debug", null, null, "Applied random ship prefab: [ship_prefab] to [log_loc(src)]")


	size30x25
		size = "30x25"
	#ifdef IN_MAP_EDITOR
		icon = 'icons/map-editing/random-rooms/30x25.dmi'
	#endif
