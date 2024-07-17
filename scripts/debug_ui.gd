extends CanvasLayer

func _on_spawn_test_dialogue_button_pressed():
	Linking.DialogueUI.init_dialogue($TestDialogue)
	pass # Replace with function body.

func _on_quit_button_pressed():
	get_tree().quit()
	pass # Replace with function body.
