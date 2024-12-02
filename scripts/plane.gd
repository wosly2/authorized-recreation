class_name Airplane extends CharacterBody2D

@export var bomb_prefab: PackedScene

@onready var collisionShape = $CollisionShape2D
@onready var animatedSprite = $CollisionShape2D/AnimatedSprite2D
@onready var gui = $Camera2D/GUI
@onready var debug_label = $Camera2D/GUI/Debug
@onready var camera = $Camera2D
@onready var audioStreamPlaneSound = $PlaneSound
@onready var audioStreamChookSound = $ChookSound
@onready var audioStreamBombOutSound = $Out

@export var SENSITIVITY = .05
@export var TILT_DRAG = .05

var forward_velocity = 2
var tilt_velocity = 0
var height_bump = randf()
var base_scale: Vector2

var bomb_number = 30

func round_nth(value: float, n: int) -> float:
	var factor = pow(10, n)
	return round(value * factor) / factor

func _ready() -> void:
	animatedSprite.play("flying")
	audioStreamPlaneSound.stream.loop = true
	audioStreamPlaneSound.play()

func _process(delta: float) -> void:
	# Input
	if Input.is_action_pressed("gas"):
		forward_velocity += 1 * delta
	if Input.is_action_pressed("brake"):
		forward_velocity -= .5 * delta
	if Input.is_action_pressed("tilt_left"):
		tilt_velocity -= 1*SENSITIVITY * delta
		forward_velocity -= 0.05 * delta
	if Input.is_action_pressed("tilt_right"):
		tilt_velocity += 1*SENSITIVITY * delta
		forward_velocity -= 0.05 * delta
	if Input.is_action_just_pressed("fire"):
		if bomb_number:
			var bomb = bomb_prefab.instantiate()
			bomb.global_rotation = global_rotation
			if Input.is_action_just_pressed("fire_left"):
				bomb.global_position = $BombDrop1.global_position
			if Input.is_action_just_pressed("fire_right"):
				bomb.global_position = $BombDrop2.global_position
			bomb_number -= 1
			get_parent().add_child(bomb)
			audioStreamChookSound.play()
		else:
			audioStreamBombOutSound.play()
		
	forward_velocity = min(max(2, forward_velocity), 5)
	tilt_velocity = min(max(-0.02, tilt_velocity), 0.02)
	
	animatedSprite.scale = Vector2(1+(height_bump/100), 1+(height_bump/100))
	camera.zoom = Vector2(2+(height_bump/300), 2+(height_bump/300))
		
	# GUI
	debug_label.text = "FV:"+str(forward_velocity)+"\nTV:"+str(tilt_velocity)
	gui.get_node("Altitude").text = "ALTITUDE:" + str(round_nth(15000+height_bump*5, 2))
	gui.get_node("Bombs").text = "BOMBS:" + str(bomb_number)
	
	# Sound
	audioStreamPlaneSound.pitch_scale = 1 + ((forward_velocity-2.5)/5)*.3

func _physics_process(delta: float) -> void:
	height_bump = randf()
	rotation += tilt_velocity
	tilt_velocity *= (1-TILT_DRAG)
	
	var direction = Vector2.UP.rotated(rotation)
	var movement = direction * forward_velocity
	position += movement
	move_and_slide()
