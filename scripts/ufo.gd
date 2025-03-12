extends NPC

func _ready() -> void:
	super()
	bullet_scene = preload("res://scenes/ufo_bullet.tscn")

func update_direction(delta: float) -> Vector2:
	return position - player.global_position
