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
	var object = area.get_parent()
	print(object)
	#if area.tp_allowed:
	#	area.position = other.position
	#	area.tp_allowed = false

func _on_area_exited(area):
	var object = area.get_parent()
	print(object)
	#if not area.tp_allowed:
	#	area.tp_allowed = true
