extends RayCast2D

var is_on_floor = false


func _process(delta):
	if is_colliding() and (get_collider() is TileMap or KinematicBody2D):
		is_on_floor = true 
	else:
		is_on_floor = false
