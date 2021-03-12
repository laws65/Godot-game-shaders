extends Node

onready var LeftTop = get_node("LeftTop")
onready var LeftBottom = get_node("LeftBottom")
onready var RightTop = get_node("RightTop")
onready var RightBottom = get_node("RightBottom")

export var width : int
export var height : int

var on_left_wall = false
var on_right_wall = false
func _ready():
	#I have no idea why this works, possibly the sprite is not positioned at the center of the coordinates
	LeftTop.position.x = -width
	LeftTop.position.y = -height/2
	LeftBottom.position.x = -width
	LeftBottom.position.y = height/2
	RightTop.position.x = width/2
	RightTop.position.y = -height/2
	RightBottom.position.x = width/2
	RightBottom.position.y = height/2
	for raycast in get_children():
		raycast.add_exception(get_parent())

func _physics_process(delta: float) -> void:
	on_left_wall = (LeftTop.is_colliding() or LeftBottom.is_colliding())
	on_right_wall = (RightTop.is_colliding() or RightBottom.is_colliding())
