extends Node

signal bomb_dropped(bomb_position: Vector2)

func notify_bomb_dropped(location: Vector2):
	bomb_dropped.emit(location)
