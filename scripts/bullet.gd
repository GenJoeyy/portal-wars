extends Area2D
class_name Bullet

@onready var player: CharacterBody2D = $"/root/Game/GameContent/Player"

@export var speed: float = 400
@export var damage: float = 1
@export var is_player_bullet: bool

var direction: Vector2

func _ready() -> void:
	look_at(get_global_mouse_position() if is_player_bullet else player.global_position)

func _process(delta: float) -> void: 
	position -= direction * speed * delta
	
func _on_area_entered(_area: Area2D) -> void:
	queue_free()
