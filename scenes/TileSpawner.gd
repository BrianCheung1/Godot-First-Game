extends TileMap

@export var monster_scene = preload("res://scenes/monsters/slime.tscn")
@export var number_of_monsters : int = 5 
@export var spawner_layer : int = 3     
var SPAWN_TIME = 10
var spawn_time = 0

func _ready():
	for i in self.get_layers_count():
		print("layer id:", i, self.get_layer_name(i))
		if(self.get_layer_name(i) == "spawner"):
			spawner_layer = i

func spawn_ememy():
	var spawn_positions = get_spawn_positions()
	for i in range(min(number_of_monsters, spawn_positions.size())):
		spawn_monster_at(spawn_positions[i])

func get_spawn_positions() -> Array:
	var spawn_positions = []
	var used_rect = get_used_rect()
	
	for x in range(used_rect.size.x):
		for y in range(used_rect.size.y):
			var cell_pos = Vector2(used_rect.position.x + x, used_rect.position.y + y)
			if not get_cell_tile_data(spawner_layer, cell_pos) == null:
				spawn_positions.append(cell_pos)
	
	return spawn_positions

func spawn_monster_at(cell_pos: Vector2):
	var monster_instance = monster_scene.instantiate()
	var tile_size = tile_set.get_tile_size()
	monster_instance.position = map_to_local(Vector2(cell_pos))
	add_child(monster_instance)
	
func _process(delta):
	if(spawn_time >= 0):
		spawn_time-= delta
		return
	
	spawn_time = SPAWN_TIME
	spawn_ememy()
