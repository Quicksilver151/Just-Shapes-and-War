extends TileMap

export(PackedScene) var enemy:PackedScene

func _ready():
	for cellpos in get_used_cells():
		if get_cellv(cellpos) == 1:
			set_cellv(cellpos,-1)
			var instance = enemy.instance()
			add_child(instance)
			instance.position = map_to_world(cellpos)+Vector2(16,16)


