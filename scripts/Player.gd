extends CharacterBody2D

@onready var bullet_scene = preload("res://scenes/player_bullet.tscn")
@onready var timer: Timer = $FireRate

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
@export var movement_speed : float = 500
var player_direction : Vector2

func _physics_process(delta: float) -> void:
	look_at(get_global_mouse_position())
	player_direction.x = Input.get_axis("Left", "Right")
	player_direction.y = Input.get_axis("Up", "Down")
	if player_direction:
		velocity = player_direction * movement_speed
	else:
		velocity = velocity.move_toward(Vector2.ZERO, movement_speed)
	move_and_slide()
	
	if Input.is_action_pressed("Shoot") and timer.is_stopped():
		shoot()
	
func shoot():
	var bullet = bullet_scene.instantiate()
	bullet.position = position
	bullet.bullet_direction = (position - get_global_mouse_position()).normalized()
	get_parent().add_child(bullet)
	timer.start()
