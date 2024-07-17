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

func init_dialogue(dialogueManager : Node) -> void:
	# clean eventual trash
	_nodes = []
	_active_node = null
	
	# populate _nodes
	var dialogues : Array[Node] = dialogueManager.get_children()
	for child in dialogues:
		if child is DialogueNode:
			child._ready()
			_nodes.append(child)
	if len(_nodes) != 0:
		_active_node = _nodes[0]
	
	# display everything
	_text_window.text = _active_node._active_content
	_inner_index = 0
	_text_window.set_visible_characters(0)
	_sprite_window.texture = _active_node._active_texture
	_speaker_window.text = _active_node._speaker
	$TextureRect.visible = true
	$TextWindow.visible = true
	return

func finish():
	# end dialogue in a clean way, ready to call init_dialogue again
	$ChoicesWindow.hideall()
	$TextureRect.visible = false
	$TextWindow.visible = false
	_nodes = []
	_active_node = null
	print_rich("[color=Springgreen]Dialogue finished safely")
	return

func next(dialogues = null):
	# check if current active node is finished
	if _active_node.next_text() != 0:
		_nodes.pop_front()
		if dialogues:
			# coming from choice node
			for child in dialogues:
				if child is DialogueNode:
					child._ready()
			_nodes = dialogues + _nodes
		if len(_nodes) == 0:
			# no mre nodes to display
			finish()
			return
		_active_node = _nodes[0]
	
	# start displaying new text
	_text_window.text = _active_node._active_content
	_text_window.set_visible_characters(0)
	_inner_index = 0
	_sprite_window.texture = _active_node._active_texture
	_speaker_window.text = _active_node._speaker
	
	# choice node case, display choice UI
	if _active_node is ChoiceNode:
		if len((_active_node as ChoiceNode)._choices) == 2:
			$ChoicesWindow.display2((_active_node as ChoiceNode)._choices)
		else:
			$ChoicesWindow.display3((_active_node as ChoiceNode)._choices)
	return

# Called when the node enters the scene tree for the first time.
func _ready():
	#init_dialogue($DialogueManager)
	$ChoicesWindow.hideall()
	$TextureRect.visible = false
	$TextWindow.visible = false
	_nodes = []
	_active_node = null
	Linking.DialogueUI = self
	return

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# error cases
	if len(_nodes) == 0 or !_active_node:
		return
	
	# advance display
	if len(_text_window.text) >= _inner_index:
		_cooldown_text += delta
		if _cooldown_text >= _text_speed or Input.is_action_pressed("dialogue_ffwd"):
			_text_window.set_visible_characters(_inner_index)
			_inner_index += 1
			_cooldown_text = 0
		return
	
	# text is fully printed
	if _active_node is ChoiceNode: 
		if Input.is_action_just_pressed("dialogue_accept"):
			await get_tree().create_timer(0.01).timeout
			var dialogues = (_active_node as ChoiceNode).get_dialogues($ChoicesWindow.selected)
			next(dialogues)
		return
	if Input.is_action_just_pressed("dialogue_accept") or Input.is_action_pressed("dialogue_ffwd"):
		next()
	return
