extends Node2D

func _ready():
	for i in range(0, Game.WIDTH):
		for j in range(0, Game.HEIGHT):
			if not (i==0 and j==0):
				var tile : Node2D = preload("res://src/DirtTile.tscn").instance()
				add_child(tile)
				tile.position = Vector2(i * Game.TILE_WIDTH, j * Game.TILE_HEIGHT)

	var player := preload("res://src/Player.tscn").instance()
	add_child(player)
