extends airState

const RELEASE_TIMER = .05 # time before player can zip/release rope from hands

const SWING_CONTROL_STRENGTH = .15
const SWING_GRAVITY = 135 # increasing this will indirectly increase swing speed
const SWING_SPEED = 56.5 # 70 for funzz 56.5 for the realz
const MIN_WIRE_LENGTH = 200
var MAX_WIRE_LENGTH = 600 #
var PLAYER_LENGTH_CONTROL = 280 # 400 for fun 280 for realism 0 # players influence with REEL, too much may may make movements not smooth at the end
const REEL_LERP_FACTOR = 3.4 # factor multiplied to delta for lep
const TOP_SPEED = 1500

var release_timer

var hit_ceil = false
var hit_wall = false
var close_to_floor = false

var cur_pos = Vector2()
var next_pos = Vector2()
var length_rope = 0.0
var desired_length_rope = 0.0
var tip_pos # tip of hook/ attach point

func enter():
	release_timer = RELEASE_TIMER
	tip_pos = owner.tip_pos

	# Integration variables
	next_pos = owner.global_position
	cur_pos = owner.previous_position
	length_rope = (owner.global_position - tip_pos).length()
	MAX_WIRE_LENGTH = length_rope * 1.1
	desired_length_rope = length_rope

	owner.arm_rotate.visible = true
	owner.play_anim("swing")
	owner.play_sound("hook_hit")

# Invariant : hook tip already planted
func update(delta):
	if owner.is_on_ceiling():
		hit_ceil = true
	if owner.is_on_wall():
		hit_wall = true
	if owner.is_on_floor():
		emit_signal("finished", "run")
	if owner.close_to_floor():
		close_to_floor = true

	release_timer -= delta
	if Input.is_action_just_pressed("jump") and release_timer < 0:
		release_hook()
		return
#
#	if owner.global_position.y < tip_pos.y: # release when player above hook point
#		release_hook()
#		return

	_update( delta )
	_constrain( )
	_adjust()
	owner.move()

	DataResource.dict_player.player_pos = owner.global_position # main update in owner is too slow rope lags

func update_idle(delta):
	owner.get_node("bodyPivot").rotation =  owner.global_position.angle_to_point(tip_pos) - PI/2

# INTEGRATION
func _update(delta):
	var input_dir = get_input_direction()
	var vel = next_pos - cur_pos # uses previous values to calculate current

	cur_pos = owner.global_position # as next_pos no longer matched the player position due to constrains
	next_pos = cur_pos

	if not (hit_ceil or hit_wall or close_to_floor) and length_rope <= MAX_WIRE_LENGTH + 15:  # player control if no collision
		desired_length_rope += input_dir.y * delta * PLAYER_LENGTH_CONTROL

	if hit_ceil:
		vel.y = 0
		hit_ceil = false
	if hit_wall:
		vel.x = 0
		hit_wall = false
	if close_to_floor:
		close_to_floor = false
		vel.y *= .7

	next_pos += vel + Vector2(0,(SWING_GRAVITY * delta * sin(owner.global_position.angle_to_point(tip_pos)))) + input_dir * SWING_CONTROL_STRENGTH
	desired_length_rope = clamp(desired_length_rope, MIN_WIRE_LENGTH, MAX_WIRE_LENGTH)

	length_rope = lerp(length_rope, desired_length_rope, delta*REEL_LERP_FACTOR)

func _constrain():
	var next_length = (next_pos - tip_pos).length()
	if next_length > length_rope or desired_length_rope > next_length: # constrains player to a circle ceneted at hook tip
		next_pos = (next_pos - tip_pos).normalized() * length_rope + tip_pos

func _adjust():
	owner.velocity = (next_pos - cur_pos )*SWING_SPEED
	owner.velocity.x = clamp (owner.velocity.x, -TOP_SPEED, TOP_SPEED)
	owner.velocity.y = clamp (owner.velocity.y, -TOP_SPEED, TOP_SPEED)
func release_hook():
	owner.chain_release()
	emit_signal("finished", "fall")

func exit():
	owner.get_node("bodyPivot").rotation =  0
	owner.arm_rotate.visible = false
