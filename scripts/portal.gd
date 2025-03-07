extends Area2D
class_name Portal

@export var color: String = "green" # Default color
@export var other: Portal = null

var active_sprite: AnimatedSprite2D = null

func _ready():
	connect("area_entered", Callable(self, "_on_area_entered"))
	connect("area_exited", Callable(self, "_on_area_exited"))
	set_color()
	birth()

func set_color() -> void:
	if color == "green":
		active_sprite = $GreenPortal
	elif color  == "purple":
		active_sprite = $PurplePortal

func birth() -> void:
	active_sprite.visible = true
	$SpawnTimer.start()
	active_sprite.play("spawn")
	
# TODO ------------
	$TTL.start()

func _on_ttl_timeout() -> void:
	kill()
# TODO ------------

func _on_spawn_timer_timeout() -> void:
	active_sprite.play("idle")
	$CollisionShape2D.disabled = false

func kill() -> void:
	$DespawnTimer.start()
	active_sprite.play("despawn")

func _on_despawn_timer_timeout() -> void:
	queue_free()

func _on_area_entered(area):
	if area is Teleportable and other:
		object_entered(area)

func _on_area_exited(area):
	if area is Teleportable:
		object_exited(area)

func object_entered(object: Teleportable) -> void:
	if object.tp_allowed:
		object.position = other.position
		object.disable_tp()
		
func object_exited(object: Teleportable) -> void:
	if not object.tp_allowed:
		object.enable_tp()
