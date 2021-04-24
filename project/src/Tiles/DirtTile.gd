extends "res://src/Tiles/Tile.gd"

func _ready():
	$Sprite.flip_h = randf() < 0.5
	$Sprite.flip_v = randf() < 0.5
