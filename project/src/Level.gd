class_name Level
extends Node2D

# Emitted when all enemies are removed
signal complete

# Emitted when the game is over.
# This happens if one player dies and all enemies are removed,
# or if both players died.
signal game_over


const DirtTile := preload("res://src/Tiles/DirtTile.tscn")
const _GEM_CHANCE := 0.05

export var duration := 30
export var enemy_count := 4
export var diamond_chance := 0.04

var _seconds_remaining : float

var _player_spawn_points := [ 2,0, Game.WIDTH-3,0 ]
var _open_points := []

var _remaining_players := 2
var _running := true

onready var _enemies := $Enemies
onready var _tiles := $Tiles

func _ready():
	_seconds_remaining = duration
	
	_add_barriers()
	
	var monster_spawn_points := []
	
	# Determine where to spawn enemies and create openings in the map
	var center_x_options := range(1, Game.WIDTH-2)
	var center_y_options := range(2, Game.HEIGHT-1)
	while monster_spawn_points.size() < enemy_count:
		var x = center_x_options[randi() % center_x_options.size()]
		var y = center_y_options[randi() % center_y_options.size()]
		var spawn_point := Vector2(x,y)
		
		# Make sure we are not already spawning there
		if monster_spawn_points.find(spawn_point) == -1:
			monster_spawn_points.append(spawn_point)
			
			# Spawn the enemy
			var enemy := preload("res://src/Enemy.tscn").instance()
			enemy.position = Vector2(spawn_point.x * Game.TILE_WIDTH, \
									 spawn_point.y * Game.TILE_HEIGHT)
			_enemies.add_child(enemy)
			enemy.connect("died", self, "_on_Enemy_died")
			
			# Equal chance of horizontal or vertical
			if randf()<0.5:
				_open_points.append_array([x-1,y, x,y, x+1,y])
				enemy.set_direction(Vector2.LEFT if randf()<0.5 else Vector2.RIGHT)
			else:
				_open_points.append_array([x,y-1, x,y, x,y+1])
				enemy.set_direction(Vector2.UP if randf()<0.5 else Vector2.DOWN)
			
			
	
	# Create the dirt tiles and diamonds
	# No tiles on the first row.
	for i in range(0, Game.WIDTH):
		for j in range(1, Game.HEIGHT):
			if not _is_open_point(i,j):
				var tile : Node2D = DirtTile.instance()
				_tiles.add_child(tile)
				var tile_position = Vector2(i * Game.TILE_WIDTH, j * Game.TILE_HEIGHT)
				tile.position = tile_position
				if randf() < diamond_chance:
					var diamond :Node2D= preload("res://src/Tiles/Diamond.tscn").instance()
					diamond.position = tile.position
					_tiles.add_child(diamond)

	# Make the players
	for i in range(0,2):
		var player := preload("res://src/Player.tscn").instance()
		player.index = i
		player.position.x = _player_spawn_points[0 + i*2] * Game.TILE_WIDTH
		player.position.y = _player_spawn_points[1 + i*2] * Game.TILE_HEIGHT
		player.connect("died", self, "_on_Player_died")
		add_child(player)


func _process(delta):
	if _running:
		_seconds_remaining = max(0, _seconds_remaining - delta)
		if _seconds_remaining <= 0:
			emit_signal("game_over")
			_running = false


func get_seconds_remaining() -> float:
	return _seconds_remaining


func _add_barriers():
	for i in range(0, Game.WIDTH):
		_add_barrier(i, -1)
		_add_barrier(i, Game.HEIGHT)
	for j in range(0, Game.HEIGHT):
		_add_barrier(-1, j)
		_add_barrier(Game.WIDTH, j)


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
	return _is_in_serial_point_list(x,y,_player_spawn_points)


func _is_in_serial_point_list(x:int, y:int, array)->bool:
	for i in range(0, array.size(), 2):
		if x == array[i] and y == array[i+1]:
			return true
	return false


func _is_open_point(x:int, y:int)->bool:
	return _is_in_serial_point_list(x,y,_open_points)


func _on_Enemy_died()->void:
	var remaining_enemies := 0
	for child in _enemies.get_children():
		if not child.is_dead():
			remaining_enemies += 1
	
	if remaining_enemies == 0:
		if _remaining_players == 2:
			emit_signal("complete")
		else:
			emit_signal("game_over")


func _on_Player_died()->void:
	_remaining_players -= 1
	if _remaining_players == 0:
		emit_signal("game_over")
	
