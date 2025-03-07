extends Area2D
@onready var player: CharacterBody2D = $"/root/Game/Player"



@export var speed = 400

var ufo_bullet_direction 

func _ready() -> void:
	look_at(player.global_position)

func _process(delta: float) -> void: 
	position -= ufo_bullet_direction * speed * delta
	
#KollisionsCheck
func _on_area_entered(area: Area2D) -> void:
	queue_free()
