extends Node

var y_direction = 0
var direction = Vector2.ZERO
var top_down_direction = Vector2.ZERO
var has_floor_detector = false


func _ready() -> void:
	has_floor_detector = has_node("../FloorDetector")


func _physics_process(delta) -> void:
	if Globals.is_player(get_parent()):
		if get_node("../../../UI").ChatboxEdit.editable:
			y_direction = 0
			direction = Vector2(0, 1)
			top_down_direction = Vector2.ZERO
		else:
			_calculate_direction_normal()
	else:
		_calculate_direction_normal()


func _calculate_direction_normal() -> void:
	y_direction = Input.get_action_strength("down") - Input.get_action_strength("jump")
	top_down_direction = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("down") - Input.get_action_strength("jump")
	).normalized()
	if has_floor_detector:
		direction = Vector2(
			Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
			-1.0 if Input.is_action_pressed("jump") and get_node("../FloorDetector").is_on_floor else 1.0
		)
	else:
		direction = top_down_direction
	
