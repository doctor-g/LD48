extends "res://src/Tiles/Tile.gd"

var _color := Color.blue

func _draw():
	draw_rect(Rect2(0,0,Game.TILE_WIDTH,Game.TILE_HEIGHT), _color)



