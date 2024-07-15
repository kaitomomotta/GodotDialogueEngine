extends Node

class_name DialogueNode

@export var _content : Array[String]
var _index := 0
@export var _speaker : String

var _active_content : String

func _ready():
	_active_content = _content[0]

func next_text() -> int:
	_index += 1
	if _index >= len(_content):
		return -1
	_active_content = _content[_index]
	return 0
