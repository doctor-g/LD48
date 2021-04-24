extends Node2D

var player_spawn_points := [ 0,0, 6,0]

func _ready():
	for i in range(0, Game.WIDTH):
		for j in range(0, Game.HEIGHT):
			if not _is_player_spawn_point(i,j):
				var tile : Node2D = preload("res://src/DirtTile.tscn").instance()
				add_child(tile)
				tile.position = Vector2(i * Game.TILE_WIDTH, j * Game.TILE_HEIGHT)

	var player1 := preload("res://src/Player.tscn").instance()
	player1.position.x = player_spawn_points[0] * Game.TILE_WIDTH
	player1.position.y = player_spawn_points[1] * Game.TILE_HEIGHT
	add_child(player1)
	
	var player2 := preload("res://src/Player.tscn").instance()
	player2.prefix = "p2_"
	player2.position.x = player_spawn_points[2] * Game.TILE_WIDTH
	player2.position.y = player_spawn_points[3] * Game.TILE_HEIGHT
	add_child(player2)


func _is_player_spawn_point(x:int, y:int)->bool:
	for i in range(0, player_spawn_points.size(), 2):
		if x == player_spawn_points[i] and y == player_spawn_points[i+1]:
			return true
	return false
