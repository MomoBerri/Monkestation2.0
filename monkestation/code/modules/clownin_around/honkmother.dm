#define HONKMOTHER_CONSUME_RANGE 10
#define HONKMOTHER_GRAV_PULL 10
#define HONKMOTHERSINGULARITY_SIZE 12

/// The honkmother, the deity of Clowns
/obj/honkmother
	name = "honkmother"
	desc = "You feel mirth rising from your very soul as you gaze upon her."
	icon = 'monkestation/icons/obj/honkmother.dmi'
	icon_state = "honkmother"
	anchored = TRUE
	appearance_flags = LONG_GLIDE
	density = FALSE
	gender = FEMALE
	plane = MASSIVE_OBJ_PLANE
	light_color = COLOR_YELLOW
	light_power = 0.9 //brighter than narnar, but not as bright as ratvar
	light_outer_range = 15
	light_outer_range = 6
	move_resist = INFINITY
	obj_flags = CAN_BE_HIT | DANGEROUS_POSSESSION
	pixel_x = -236
	pixel_y = -256
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	flags_1 = SUPERMATTER_IGNORES_1

	/// The singularity component to move around honkmother.
	/// A weak ref in case an admin removes the component to preserve the functionality.
	var/datum/weakref/singularity

/obj/honkmother/Initialize(mapload)
	. = ..()

	SSpoints_of_interest.make_point_of_interest(src)

	singularity = WEAKREF(AddComponent(
		/datum/component/singularity, \
		bsa_targetable = FALSE, \
		consume_callback = CALLBACK(src, PROC_REF(consume)), \
		consume_range = HONKMOTHER_CONSUME_RANGE, \
		disregard_failed_movements = TRUE, \
		grav_pull = HONKMOTHER_GRAV_PULL, \
		roaming = TRUE, \
		singularity_size = HONKMOTHERSINGULARITY_SIZE, \
	))

	desc = ("That's the Honkomther. Rejoice, for she has arrived.")
	send_to_playing_players(span_honkmother("!!! THE HONKMOTHER DESCENDS !!!"))
	sound_to_playing_players('monkestation/sound/effects/honkmother_descends.ogg')

	var/area/area = get_area(src)
	if(area)
		var/mutable_appearance/alert_overlay = mutable_appearance('monkestation/icons/hud/actions.dmi', "honkmother_alert")
		notify_ghosts("The Honkkmother has risen in [area]. Reach out to the Lady to be awarded a new mirthful form!", source = src, \
					alert_overlay = alert_overlay, action = NOTIFY_ATTACK)
