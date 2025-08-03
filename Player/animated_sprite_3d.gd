extends AnimatedSprite3D

enum AnimationState {IDLE, TURNING_LEFT, TURNING_RIGHT, TURNING_BACK, TURNED}
enum Direction {STRAIGHT, LEFT, RIGHT}

var state: AnimationState = AnimationState.IDLE
var finished_animation: String = ""
var direction: Direction = Direction.STRAIGHT
var pressed_directions: Dictionary = {
	Direction.STRAIGHT: false,
	Direction.LEFT: false,
	Direction.RIGHT: false
}

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("turn_left"):
		pressed_directions[Direction.LEFT] = true
	elif event.is_action_released("turn_left"):
		pressed_directions[Direction.LEFT] = false

	if event.is_action_pressed("turn_right"):
		pressed_directions[Direction.RIGHT] = true
	elif event.is_action_released("turn_right"):
		pressed_directions[Direction.RIGHT] = false

	if event.is_action_pressed("accelerate"):
		pressed_directions[Direction.STRAIGHT] = true
	elif event.is_action_released("accelerate"):
		pressed_directions[Direction.STRAIGHT] = false

func _process(_delta: float) -> void:
	# IDLE -> TURNING_LEFT
	if (
		state == AnimationState.IDLE and
		pressed_directions[Direction.LEFT]
	):
		state = AnimationState.TURNING_LEFT
		direction = Direction.LEFT
		flip_h = true
		play("turning")

	# IDLE -> TURNING_RIGHT
	elif (
		state == AnimationState.IDLE and
		pressed_directions[Direction.RIGHT]
	):
		state = AnimationState.TURNING_RIGHT
		direction = Direction.RIGHT
		flip_h = false
		play("turning")

	# TURNING_LEFT -> TURNED
	if (
		state == AnimationState.TURNING_LEFT and
		finished_animation == "turning" and
		pressed_directions[Direction.LEFT]
	):
		state = AnimationState.TURNED
		play("turned")

	# TURNING_RIGHT -> TURNED
	elif (
		state == AnimationState.TURNING_RIGHT and
		finished_animation == "turning" and
		pressed_directions[Direction.RIGHT]
	):
		state = AnimationState.TURNED
		play("turned")

	# TURNING_LEFT -> TURNING_BACK
	elif (
		state == AnimationState.TURNING_LEFT and
		finished_animation == "turning" and
		(
			pressed_directions[Direction.RIGHT] or
			not pressed_directions[Direction.LEFT] and not pressed_directions[Direction.RIGHT]
		)
	):
		state = AnimationState.TURNING_BACK
		speed_scale = 1.3
		play_backwards("turning")
		speed_scale = 1

	# TURNING_RIGHT -> TURNING_BACK
	elif (
		state == AnimationState.TURNING_RIGHT and
		finished_animation == "turning" and
		(
			pressed_directions[Direction.LEFT] or
			not pressed_directions[Direction.LEFT] and not pressed_directions[Direction.RIGHT]
		)
	):
		state = AnimationState.TURNING_BACK
		speed_scale = 1.3
		play_backwards("turning")
		speed_scale = 1

	# TURNING_BACK -> IDLE
	elif (
		state == AnimationState.TURNING_BACK and
		finished_animation == "turning"
	):
		state = AnimationState.IDLE
		direction = Direction.STRAIGHT
		play("idle")

	# TURNED -> TURNING_BACK
	elif (
		state == AnimationState.TURNED and
		(not pressed_directions[Direction.LEFT] and not pressed_directions[Direction.RIGHT])
	):
		state = AnimationState.TURNING_BACK
		speed_scale = 1.3
		play_backwards("turning")
		speed_scale = 1
	pass


func _on_animation_finished() -> void:
	finished_animation = animation
