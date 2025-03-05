extends Area2D


@export var speed = 700
var bullet_direction
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position -= bullet_direction * speed * delta
