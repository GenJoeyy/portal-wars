extends CharacterBody2D

@onready var bullet_scene = preload("res://scenes/player_bullet.tscn")
@onready var timer: Timer = $FireRate
@onready var shot_sound: AudioStreamPlayer2D = $ShotSound
@onready var hit_sound: AudioStreamPlayer2D = $HitSound
@onready var blue_skin: AnimatedSprite2D = $BlueSkin

@export var skin = "Y-Wing"
@export var movement_speed: float = 500
@export var health = 3

var player_direction: Vector2
var alive = true

func _physics_process(_delta: float) -> void:
	if skin == "Y-Wing" : 
		$"Y-WingSkin".play(skin + " Boost" if player_direction else skin)
		$BlueSkin.visible = false
		$"Y-WingSkin".visible = true
	elif skin == "Blue" :
		$BlueSkin.play(skin + " Boost" if player_direction else skin)
		$"Y-WingSkin".visible = false
		$BlueSkin.visible = true
	
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
	
	# clamp player to visible screen
	var screen_size = get_viewport().get_size() / 2 
	screen_size -= Vector2i(25, 25) # Player Size
	position.x = clamp(position.x, -screen_size.x, screen_size.x)
	position.y = clamp(position.y, -screen_size.y, screen_size.y)
	
	
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


func _on_area_area_entered(area: Area2D) -> void:
	if alive:
		if health == 1:
			get_tree().reload_current_scene()
		else:
			health -= 1
			hit_sound.play()
	pass 
