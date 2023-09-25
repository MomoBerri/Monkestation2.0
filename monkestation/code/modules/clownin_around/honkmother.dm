#define HONKMOTHER_CHANCE_TO_PICK_NEW_TARGET 5
#define HONKMOTHER_CONSUME_RANGE 10
#define HONKMOTHER_GRAV_PULL 10
#define HONKMOTHERSINGULARITY_SIZE 12

/// The honkmother, the God of Clowns
/obj/honkmother
	name = "Honkmother"
	desc = "You feel mirth rising from your very soul as you gaze upon her."
	icon = 'icons/obj/cult/narsie.dmi'
	icon_state = "narsie"
	anchored = TRUE
	appearance_flags = LONG_GLIDE
	density = FALSE
	gender = FEMALE
	plane = MASSIVE_OBJ_PLANE
	light_color = COLOR_YELLOW
	light_power = 0.9
	light_outer_range = 15
	light_outer_range = 6
	move_resist = INFINITY
	obj_flags = CAN_BE_HIT | DANGEROUS_POSSESSION
	pixel_x = -236
	pixel_y = -256
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	flags_1 = SUPERMATTER_IGNORES_1

	/// The singularity component to move around Nar'Sie.
	/// A weak ref in case an admin removes the component to preserve the functionality.
	var/datum/weakref/singularity

	var/list/souls_needed = list()
	var/soul_goal = 0
	var/souls = 0
	var/resolved = FALSE

/obj/narsie/Initialize(mapload)
	. = ..()

	SSpoints_of_interest.make_point_of_interest(src)

	singularity = WEAKREF(AddComponent(
		/datum/component/singularity, \
		bsa_targetable = FALSE, \
		consume_callback = CALLBACK(src, PROC_REF(consume)), \
		consume_range = NARSIE_CONSUME_RANGE, \
		disregard_failed_movements = TRUE, \
		grav_pull = NARSIE_GRAV_PULL, \
		roaming = FALSE, /* This is set once the animation finishes */ \
		singularity_size = NARSIE_SINGULARITY_SIZE, \
	))
