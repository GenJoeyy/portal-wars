extends Area2D

@export var speed = 400

var ufo_bullet_direction 


func _process(delta: float) -> void: 
	position -= ufo_bullet_direction * speed * delta
	
#KollisionsCheck
func _on_area_entered(area: Area2D) -> void:
	queue_free()
