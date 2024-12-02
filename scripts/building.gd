extends Node2D
class_name Building

@export var radius = 25

@onready var bullseye: Sprite2D = $Bullseye
@onready var chevron: Sprite2D = $Chevron
@onready var bomb_manager = $"../../BombManager"

func _ready() -> void:
	bomb_manager.bomb_dropped.connect(_on_bomb_manager_bomb_dropped)

func _process(delta: float) -> void:
	bullseye.global_rotation = %Player.global_rotation
	
	var direction = (%Player.global_position - global_position).normalized()
	
	chevron.global_position = %Player.global_position - direction*150
	chevron.look_at(bullseye.global_position)

func _on_bomb_manager_bomb_dropped(bomb_position: Vector2) -> void:
	if global_position.distance_to(bomb_position) <= radius + 10:
		$Ding.play()
		queue_free()
