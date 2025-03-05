extends CharacterBody2D

@onready var bullet_scene = preload("res://scenes/player_bullet.tscn")
@onready var timer: Timer = $FireRate
@onready var shot_sound: AudioStreamPlayer2D = $ShotSound

@export var movement_speed : float = 500
var player_direction : Vector2

func _physics_process(delta: float) -> void:
	
	#Mausausrichtung
	look_at(get_global_mouse_position())
	
	#Richtungssteuerung
	player_direction.x = Input.get_axis("Left", "Right")
	player_direction.y = Input.get_axis("Up", "Down")
	
	#Bewegen
	if player_direction:
		velocity = player_direction * movement_speed
	else:
		velocity = velocity.move_toward(Vector2.ZERO, movement_speed)
	move_and_slide()
	
	#Schießen
	if Input.is_action_pressed("Shoot") and timer.is_stopped():
		shoot()
	
	#Schuss von player_bullet
func shoot():
	shot_sound.play()
	var bullet = bullet_scene.instantiate()
	bullet.position = position
	bullet.bullet_direction = (position - get_global_mouse_position()).normalized()
	get_parent().add_child(bullet)
	timer.start()
