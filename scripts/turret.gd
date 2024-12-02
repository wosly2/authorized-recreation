extends Building
class_name Turret

func _ready() -> void:
	bomb_manager.bomb_dropped.connect(_on_bomb_manager_bomb_dropped)

func _process(delta: float) -> void:
	bullseye.look_at(%Player.global_position)
	
	var direction = (%Player.global_position - global_position).normalized()
	
	chevron.global_position = %Player.global_position - direction*150
	chevron.global_rotation = %Player.global_rotation
	
	if Time.get_time_dict_from_system()["second"] % 2:
		$CircularBorder.rotation = 0.6 * PI
	else:
		$CircularBorder.rotation = 0.5 * PI


func _on_bomb_manager_bomb_dropped(bomb_position: Vector2) -> void:
	if global_position.distance_to(bomb_position) <= radius + 10:
		$Ding.play()
		queue_free()
