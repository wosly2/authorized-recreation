extends Button

func _ready() -> void:
	$"../../Song".play()

func _on_pressed() -> void:
	$"../../Song".stop()
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	
func _on_link_pressed() -> void:
	OS.shell_open("https://af.mil")
