extends CanvasLayer

var _nodes : Array
var _active_node : DialogueNode = null
var _active_node_index := 0

@onready var _text_window = $TextWindow/RichTextLabel
@onready var _sprite_window = $TextureRect
@onready var _speaker_window = $TextWindow/SpeakerLabel

@export var _text_speed : float = 0.2
var _cooldown_text : float = 0.0
var _inner_index : int = 1

func finish():
	$ChoicesWindow.hideall()
	$TextureRect.visible = false
	$TextWindow.visible = false

func next(dialogues = null):
	if _active_node.next_text() != 0:
		# go to next node
		_nodes.pop_front()
		if dialogues:
			print(dialogues)
			print(_nodes)
			_nodes = dialogues + _nodes
			print(_nodes)
		if len(_nodes) == 0:
			finish()
			return
		_active_node = _nodes[0]
	_text_window.text = _active_node._active_content
	_text_window.set_visible_characters(0)
	_inner_index = 0
	_sprite_window.texture = _active_node._active_texture
	_speaker_window.text = _active_node._speaker
	if _active_node is ChoiceNode:
		if len((_active_node as ChoiceNode)._choices) == 2:
			$ChoicesWindow.display2((_active_node as ChoiceNode)._choices)
		else:
			$ChoicesWindow.display3((_active_node as ChoiceNode)._choices)

# Called when the node enters the scene tree for the first time.
func _ready():
	for node in $DialogueManager.get_children():
		if node is DialogueNode:
			_nodes.append(node)
	if len(_nodes) != 0:
		_active_node = _nodes[0]
	_text_window.text = _active_node._active_content
	_text_window.set_visible_characters(0)
	_sprite_window.texture = _active_node._active_texture
	_speaker_window.text = _active_node._speaker

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# error cases
	if len(_nodes) == 0 or !_active_node:
		return
	
	# advance display
	if len(_text_window.text) >= _inner_index:
		_cooldown_text += delta
		if _cooldown_text >= _text_speed:
			_text_window.set_visible_characters(_inner_index)
			_inner_index += 1
			_cooldown_text = 0
		return
	
	# text is fully printed
	if Input.is_action_just_pressed("ui_accept"):
		if _active_node is ChoiceNode:
			await get_tree().create_timer(0.01).timeout
			var dialogues = (_active_node as ChoiceNode).get_dialogues($ChoicesWindow.selected)
			next(dialogues)
		else:
			next()
			
