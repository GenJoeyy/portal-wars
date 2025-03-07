extends Area2D
@export var speed = 700
@export var damage = 1

var bullet_direction

func _ready() -> void:
	look_at(get_global_mouse_position())
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position -= bullet_direction * speed * delta
#Kollisionscheck
func _on_area_entered(area: Area2D) -> void:
	queue_free()
