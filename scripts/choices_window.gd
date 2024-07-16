extends VBoxContainer

var _actives : Array
var hovered : int
var selected = null
var listening : bool

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

func hideall():
	_actives = []
	for child in get_children():
		child.visible = false

func set_hovered(hovered : int):
	for child in get_children():
		(child as ColorRect).color = Color(0, 0, 0, 0.392)
	(get_child(hovered) as ColorRect).color = Color.DARK_ORANGE


# Called when the node enters the scene tree for the first time.
func _ready():
	hideall()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if _actives == []:
		return
	if Input.is_action_just_pressed("ui_down"):
		hovered = (hovered + 1) % len(_actives)
		set_hovered(hovered)
	if Input.is_action_just_pressed("ui_up"):
		hovered = (hovered - 1 + len(_actives)) % len(_actives)
		set_hovered(hovered)
	if Input.is_action_just_pressed("ui_accept") && listening:
		selected = hovered
		hideall()
