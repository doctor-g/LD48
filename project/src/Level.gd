extends Node2D

var player_spawn_points := [ 0,0, 6,0]
var open_points := [1,4, 2,4, 3,4]

func _ready():
	_add_barriers()
	
	# Populate the level
	for i in range(0, Game.WIDTH):
		for j in range(0, Game.HEIGHT):
			if not _is_player_spawn_point(i,j) and not _is_open_point(i,j):
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
	
	var enemy := preload("res://src/Enemy.tscn").instance()
	enemy.position.x = open_points[0] * Game.TILE_WIDTH
	enemy.position.y = open_points[1] * Game.TILE_HEIGHT
	add_child(enemy)


func _add_barriers():
	for i in range(0, Game.WIDTH):
		_add_barrier(i, -1)
		_add_barrier(i, Game.HEIGHT+1)
	for j in range(0, Game.HEIGHT):
		_add_barrier(-1, j)
		_add_barrier(Game.WIDTH+1, j)


func _add_barrier(x:int, y:int)->void:
	var barrier := StaticBody2D.new()
	barrier.add_to_group("tiles")
	var collision := CollisionShape2D.new()
	collision.position = Game.TILE_SIZE / 2
	collision.shape = RectangleShape2D.new()
	collision.shape.extents = Game.TILE_SIZE / 2
	barrier.add_child(collision)
	barrier.position.x = Game.TILE_WIDTH * x
	barrier.position.y = Game.TILE_HEIGHT * y
	add_child(barrier)
	

func _is_player_spawn_point(x:int, y:int)->bool:
	return _is_in_serial_point_list(x,y,player_spawn_points)


func _is_in_serial_point_list(x:int, y:int, array)->bool:
	for i in range(0, array.size(), 2):
		if x == array[i] and y == array[i+1]:
			return true
	return false


func _is_open_point(x:int, y:int)->bool:
	return _is_in_serial_point_list(x,y,open_points)
