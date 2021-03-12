extends Sprite

onready var Player = get_node("../YSort/Player")
onready var Tilemap = get_node("../TileMap")
var light_values = []
var snap_step = 128
var size_in_tiles = Vector2.ZERO
var LightShader = get_material()
var initialised = false


func _ready() -> void:
	scale = get_size()


func _process(delta: float) -> void:
	if not initialised:
		init_block_lights()
		append_empty_values()
		initialised = true
	set_pos()
	set_shader_tiles()


func append_empty_values() -> void:
	for x in range(Tilemap.get_used_rect().size.x):
		light_values.append([])
		for y in range(Tilemap.get_used_rect().size.y):
			light_values[x].append(0)


func init_block_lights() -> void:
	for x in range(light_values.size()):
		for y in range(light_values[x].size()):
			light_values[x][y] = 1 if Tilemap.get_cell(x, y) == -1 else 0


func get_size() -> Vector2:
	var size = get_viewport_rect().size + Vector2(snap_step, snap_step) * 2 * Vector2(1.5, 1.5)
	size.x = stepify(size.x, 32)
	size.y = stepify(size.y, 32)
	size_in_tiles.x = int(size.x / 16)
	size_in_tiles.y = int(size.y / 16)
	return size


func set_pos() -> void:
	var pos_x = stepify(Player.position.x, snap_step) - scale.x / 2
	var pos_y = stepify(Player.position.y, snap_step) - scale.y / 2
	position = Vector2(pos_x, pos_y)


func set_shader_tiles() -> void:
	var start_x = int(position.x / 16)
	var start_y = int(position.y / 16)
	var region_tile_info = []
	
	for y in range(start_y, start_y + size_in_tiles.y):
		for x in range(start_x, start_x + size_in_tiles.x):
			if within_bounds(x, y):
				region_tile_info.append(light_values[x][y] * 255)
			else:
				region_tile_info.append(255)
	
	var img = Image.new()
	img.create_from_data(size_in_tiles.x, size_in_tiles.y, false, Image.FORMAT_L8, region_tile_info)

	var tex = ImageTexture.new()
	tex.create_from_image(img)
	LightShader.set_shader_param("light_values", tex)
	img.save_png("res://src/map.png")


func within_bounds(x, y):
	return (x < light_values.size() and
			x >= 0 and
			y < light_values[x].size() and
			y >= 0)
