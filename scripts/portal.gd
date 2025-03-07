extends Area2D
class_name Portal

@export var color: String = "green" # Default color
@export var target_portal: Portal = null

static var tp_allowed_dict = {} # holds (tp_allowed: bool) for every object

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
	$CollisionShape2D.disabled = true
	active_sprite.play("despawn")

func _on_despawn_timer_timeout() -> void:
	queue_free()

func _on_area_entered(area):
	if not target_portal:
		push_error("Target Portal not defined for " + name)
		
	var object = area.get_parent()
	
	if tp_allowed(object):
		
		# Player or Enemy
		if object is CharacterBody2D:
			object.global_position = target_portal.global_position
		
		disable_tp(object)

func _on_area_exited(area):
	var object = area.get_parent()
	if not tp_allowed(object):
		enable_tp(object)

func tp_allowed(object) -> bool:
	var id = object.get_instance_id()
	if not tp_allowed_dict.has(id):
		tp_allowed_dict[id] = true
	return tp_allowed_dict[id]
	
func enable_tp(object):
	var id = object.get_instance_id()
	tp_allowed_dict[id] = true
	
	
func disable_tp(object):
	var id = object.get_instance_id()
	tp_allowed_dict[id] = false
