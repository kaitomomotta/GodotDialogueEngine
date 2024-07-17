extends VBoxContainer

var _actives : Array
var hovered : int
var selected = null
var listening : bool

## display choice UI when there are 2 options
func display2(choices : Array[String]):
	listening = false
	_actives = [get_child(0), get_child(1)]
	$ColorRect.visible = true
	$ColorRect/RichTextLabel.text = choices[0]
	$ColorRect2.visible = true
	$ColorRect2/RichTextLabel.text = choices[1]
	$ColorRect3.visible = false
	selected = null
	hovered = 0
	set_hovered(0)
	await get_tree().create_timer(0.01).timeout
	listening = true
	return

## display choice UI when there are 3 options
func display3(choices : Array[String]):
	listening = false
	_actives = get_children()
	for child in get_children():
		child.visible = true
	$ColorRect/RichTextLabel.text = choices[0]
	$ColorRect2/RichTextLabel.text = choices[1]
	$ColorRect3/RichTextLabel.text = choices[2]
	selected = null
	hovered = 0
	set_hovered(0)
	await get_tree().create_timer(0.01).timeout
	listening = true
	return

func hideall():
	# make choice UI invisible when choice is made
	_actives = []
	for child in get_children():
		child.visible = false
	return

func set_hovered(hovered : int):
	# change currently hovered choice
	for child in get_children():
		(child as ColorRect).color = Color(0, 0, 0, 0.392)
	(get_child(hovered) as ColorRect).color = Color.DARK_ORANGE
	return


# Called when the node enters the scene tree for the first time.
func _ready():
	hideall()
	return


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if _actives == []:
		return
	
	# check inputs
	if Input.is_action_just_pressed("ui_down"):
		hovered = (hovered + 1) % len(_actives)
		set_hovered(hovered)
	if Input.is_action_just_pressed("ui_up"):
		hovered = (hovered - 1 + len(_actives)) % len(_actives)
		set_hovered(hovered)
	if Input.is_action_just_pressed("dialogue_accept") && listening:
		selected = hovered
		hideall()
	return
