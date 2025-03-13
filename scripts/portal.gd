extends Area2D
class_name Portal

static var shape = Vector2(25, 85)

static var tp_allowed_dict = {} # holds (tp_allowed: bool) for every object

@export var color: String = "green" # Default color
@export var target_portal: Portal = null

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

func _on_spawn_timer_timeout() -> void:
	active_sprite.play("idle")
	$CollisionShape2D.disabled = false

func kill() -> void:
	$DespawnTimer.start()
	$CollisionShape2D.disabled = true
	active_sprite.play("despawn")

func _on_despawn_timer_timeout() -> void:
	active_sprite.visible = false
	queue_free()

func _on_area_entered(object):
	if not target_portal:
		push_error("Target Portal not defined for " + name)
		return
		
	# Player or Enemy
	if object.get_parent() is CharacterBody2D:
		#Global.score += 1
		object = object.get_parent()

	if tp_allowed(object):
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
	if object is NPC and object.is_hostile: 
		Global.score += 3
	var id = object.get_instance_id()
	tp_allowed_dict[id] = true
	
func disable_tp(object):
	var id = object.get_instance_id()
	tp_allowed_dict[id] = false
