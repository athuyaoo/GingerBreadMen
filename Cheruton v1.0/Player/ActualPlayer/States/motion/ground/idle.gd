extends groundState

func enter():
	owner.play_anim("idle")
	owner.queue_anim("idle_continious")

func handle_input(event):
	return .handle_input(event)

func update(delta):
	owner.velocity = Vector2.DOWN  * 10  # DOWN so we have collision response
	owner.move()

	if get_input_direction().x:
		emit_signal("finished", "run")
	.update(delta)


