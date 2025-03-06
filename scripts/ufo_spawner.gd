extends Node2D
@onready var ufo_enemy = preload("res://scenes/ufo.tscn")
@onready var player: CharacterBody2D = $"../Player"

func _on_timer_timeout() -> void:
	var ufo = ufo_enemy.instantiate()
	ufo.position = position 
	#ufo.ufo_direction = (position - player.position).normalized()
	get_parent().add_child(ufo)
