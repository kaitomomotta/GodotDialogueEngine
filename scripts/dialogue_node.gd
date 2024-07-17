extends Node

class_name DialogueNode

@export var _content : Array[String]
@export var _sprites : Array[Texture2D]
var _index := 0
@export var _speaker : String

var _active_content : String
var _active_texture : Texture2D

func _ready():
	_active_content = _content[0]
	_active_texture = _sprites[0]
	_index = 0
	return

func next_text() -> int:
	_index += 1
	if _index >= len(_content):
		return -1
	_active_content = _content[_index]
	_active_texture = _sprites[_index]
	return 0
