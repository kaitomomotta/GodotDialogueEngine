extends DialogueNode

class_name ChoiceNode

@export var _choices : Array[String]

func get_dialogues(selected : int):
	var choice = get_child(selected)
	return choice.get_children()
