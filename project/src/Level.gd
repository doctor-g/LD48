extends Node2D

# Emitted when all enemies are removed
signal complete

const DirtTile := preload("res://src/Tiles/DirtTile.tscn")
const GemTile := preload("res://src/Tiles/GemTile.tscn")
const _GEM_CHANCE := 0.05

var player_spawn_points := [ 0,0, 6,0 ]
var open_points := [ 1,4, 2,4, 3,4 ]

onready var _enemies := $Enemies

func _ready():
	_add_barriers()
	
	# Populate the level
	for i in range(0, Game.WIDTH):
		for j in range(0, Game.HEIGHT):
			if not _is_player_spawn_point(i,j) and not _is_open_point(i,j):
				var tile : Node2D = (GemTile if randf()<_GEM_CHANCE else DirtTile).instance()
				add_child(tile)
				tile.position = Vector2(i * Game.TILE_WIDTH, j * Game.TILE_HEIGHT)

	# Make the players
	for i in range(0,2):
		var player := preload("res://src/Player.tscn").instance()
		player.index = i
		player.position.x = player_spawn_points[0 + i*2] * Game.TILE_WIDTH
		player.position.y = player_spawn_points[1 + i*2] * Game.TILE_HEIGHT
		add_child(player)
	
	var enemy := preload("res://src/Enemy.tscn").instance()
	enemy.position.x = open_points[0] * Game.TILE_WIDTH
	enemy.position.y = open_points[1] * Game.TILE_HEIGHT
	_enemies.add_child(enemy)
	enemy.connect("tree_exited", self, "_on_Enemy_tree_exited", [], CONNECT_ONESHOT)


func _add_barriers():
	for i in range(0, Game.WIDTH):
		_add_barrier(i, -1)
		_add_barrier(i, Game.HEIGHT+1)
	for j in range(0, Game.HEIGHT):
		_add_barrier(-1, j)
		_add_barrier(Game.WIDTH+1, j)


func _add_barrier(x:int, y:int)->void:
	var barrier := StaticBody2D.new()
	barrier.add_to_group("barriers")
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


func _on_Enemy_tree_exited()->void:
	if _enemies.get_child_count() == 0:
		print("Level Complete")
		emit_signal("complete")
