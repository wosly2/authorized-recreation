class_name Bomb extends Area2D

@onready var bomb_manager = $"../BombManager"

func _ready() -> void:
	$AnimatedSprite2D.set_frame_and_progress(0, 0)
	$AnimatedSprite2D.play("drop")
	await $AnimatedSprite2D.animation_finished
	$Explosion.play()
	bomb_manager.notify_bomb_dropped(global_position)
	$AnimatedSprite2D.set_frame_and_progress(0, 0)
	$AnimatedSprite2D.play("explosion")
	await $AnimatedSprite2D.animation_finished
	queue_free()
