extends Node2D

@onready var friendly_scene = preload("res://scenes/friendly_ship.tscn")
@onready var spawn_cd: Timer = $SpawnCD


func _ready() -> void:
	set_timer()
	spawn_cd.start()

func set_timer():
	var random_time = randi_range(4, 8)
	spawn_cd.set_wait_time(random_time)
	spawn_cd.start()

func _on_timer_timeout() -> void:
	var random_dir = pow(-1, randi() % 2) # returns -1  or 1
	var rand_x = random_dir * 1200
	var rand_y = randf_range(-600, 600)
	position = Vector2(rand_x, rand_y) 
	
	var friendly = friendly_scene.instantiate()
	friendly.position = position
	friendly.direction = position - Vector2(-position.x, position.y)
	if friendly.position.x > 0:
		friendly.flip() #Facing the direction they are flying 
	get_parent().add_child(friendly)
	set_timer()
