extends baseState

const JUMP_VEL = -750

var goal_pos

func enter():
	owner.play_anim("jump")

func jump(): #called by animation player
	owner.velocity.y =  JUMP_VEL

func update( delta ):
	if owner.return_to_sleep:
		goal_pos = owner.initial_pos
	else:
		goal_pos = owner.player.global_position

	owner.velocity.x = clamp(goal_pos.x - owner.global_position.x, -owner.MAX_X_VEL, owner.MAX_X_VEL)
	owner.velocity.y = min( owner.TERMINAL_VELOCITY, owner.velocity.y + owner.GRAVITY * delta)
	owner.look_dir = Vector2(sign(owner.velocity.x),0)

	if owner.velocity.y > 0:
		emit_signal("finished","fall")

	owner.move()