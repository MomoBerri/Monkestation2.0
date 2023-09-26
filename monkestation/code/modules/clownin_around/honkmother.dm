//Monkestation's own version of the honkmother, sprite by LME.

#define HONKMOTHER_CONSUME_RANGE 10
#define HONKMOTHER_GRAV_PULL 10
#define NARSIE_MESMERIZE_CHANCE 25
#define NARSIE_MESMERIZE_EFFECT 60
#define HONKMOTHER_SINGULARITY_SIZE 12

// The honkmother, the Deity of Clowns
/obj/honkmother
	name = "honkmother"
	desc = "You feel mirth rising from your very soul as you gaze upon her."
	icon = 'monkestation/icons/obj/honkmother.dmi'
	icon_state = "honkmother"
	anchored = TRUE
	density = FALSE
	appearance_flags = LONG_GLIDE
	gender = FEMALE
	plane = MASSIVE_OBJ_PLANE
	light_color = COLOR_YELLOW //The colour of happiness, and bananas!
	light_power = 0.9 //brighter than narnar, but not as bright as ratvar
	light_outer_range = 15
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
		roaming = FALSE, /* This is set once the animation finishes */ \
		singularity_size = HONKMOTHER_SINGULARITY_SIZE, \
	))

	log_game("!!! THE HONKMOTHER DESCENDS !!!")
	send_to_playing_players(span_reallybig("!!! THE HONKMOTHER DESCENDS !!!"))
	sound_to_playing_players('monkestation/sound/effects/honkmother_descends.ogg')
	START_PROCESSING(SSobj, src)

	var/area/area = get_area(src)
	if(area)
		var/mutable_appearance/alert_overlay = mutable_appearance('monkestation/icons/obj/clock_cult/clockwork_effects.dmi', "ratvar_alert")
		notify_ghosts("The Honkmother has risen in [area]. Reach out to the Lady to be awarded a new mirthful form!", source = src, alert_overlay = alert_overlay, action = NOTIFY_ATTACK)
	narsie_spawn_animation()

/obj/honkmother/attack_ghost(mob/user)
	makeNewConstruct(/mob/living/simple_animal/hostile/construct/harvester, user, cultoverride = TRUE, loc_override = loc)

/// Stun people around Honkmother
/obj/Honkmother/proc/mesmerize()
	for (var/mob/living/carbon/victim in viewers(HONKMOTHER_CONSUME_RANGE, src))
		if (victim.stat == CONSCIOUS)
			to_chat(victim, span_cult("You feel conscious thought crumble away in an instant as you gaze upon [src]..."))
			victim.apply_effect(NARSIE_MESMERIZE_EFFECT, EFFECT_STUN)

/obj/honkmother/Bump(atom/the_atom)
	var/turf/the_turf = get_turf(the_atom)
	if(the_turf == loc)
		the_turf = get_step(the_atom, the_atom.dir)
	forceMove(the_turf)

/obj/honkmother/proc/consume(atom/target)
	if (isturf(target))
		target.narsie_act()

/obj/honkmother/proc/narsie_spawn_animation()
	setDir(SOUTH)
	flick("narsie_spawn_anim", src)
	addtimer(CALLBACK(src, PROC_REF(narsie_spawn_animation_end)), 3.5 SECONDS)

/obj/honkmother/proc/narsie_spawn_animation_end()
	var/datum/component/singularity/singularity_component = singularity.resolve()
	singularity_component?.roaming = TRUE

#undef HONKMOTHER_CONSUME_RANGE
#undef HONKMOTHER_GRAV_PULL
#undef HONKMOTHER_SINGULARITY_SIZE
