extends ColorRect

@onready var anim_player: AnimationPlayer = $AnimationPlayer

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		pause()

func unpause():
	anim_player.play("Unpause")
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func pause():
	anim_player.play("Pause")
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_resume_button_pressed():
	unpause()


func _on_quit_button_pressed():
	get_tree().quit()
