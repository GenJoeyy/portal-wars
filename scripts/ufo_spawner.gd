extends Node2D
@onready var ufo_enemy = preload("res://scenes/ufo.tscn")
@onready var player: CharacterBody2D = $"../../Player"
@onready var spawn_cd: Timer = $SpawnCD

func _ready() -> void:
	set_timer()
	spawn_cd.start()

func set_timer():
	var randomTime =randi_range(4, 9)
	spawn_cd.set_wait_time(randomTime)
	spawn_cd.start()

func _on_timer_timeout() -> void:
	var ufo = ufo_enemy.instantiate()
	ufo.position = position 
	get_parent().add_child(ufo)
	set_timer()
