extends Node2D

const PORTAL = preload("res://scenes/portal.tscn")
var portal_shape: Vector2i = PORTAL.instantiate().shape
var portal_spawn_borders

var green_portal: Portal
var purple_portal: Portal

func _ready() -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	set_portal_spawn_borders()
	spawn_new_portals()

func set_portal_spawn_borders() -> void:
	portal_spawn_borders = get_viewport().get_size() - portal_shape
	portal_spawn_borders /= 2
	
	# portals shouldnt spawn on the outer border
	portal_spawn_borders *= 0.75

func _process(delta: float) -> void:
	# make portals look at center
	green_portal.look_at(Vector2.ZERO)
	purple_portal.look_at(Vector2.ZERO)

func rand_portal_coords() -> Vector2:
	var min_x = -portal_spawn_borders.x
	var max_x = portal_spawn_borders.x
	var min_y = -portal_spawn_borders.y
	var max_y = portal_spawn_borders.y
	
	return Vector2(
		randf_range(min_x, max_x),
		randf_range(min_y, max_y))

func verify_portal_coords(a: Vector2, b: Vector2) -> bool:
	var distance_a_b = a.distance_to(b) > portal_shape.y * 7
	
	var player = $Player.global_position
	var distance_a_player = a.distance_to(player) > portal_shape.y
	var distance_b_player = b.distance_to(player) > portal_shape.y
	
	return distance_a_b && distance_a_player && distance_b_player
	
func spawn_new_portals():
	var green_pos = rand_portal_coords()
	var purple_pos = rand_portal_coords()
	
	while not verify_portal_coords(green_pos, purple_pos):
		green_pos = rand_portal_coords()
		purple_pos = rand_portal_coords()
	
	green_portal = PORTAL.instantiate()
	purple_portal = PORTAL.instantiate()
	
	green_portal.global_position = green_pos
	purple_portal.global_position = purple_pos
	
	green_portal.target_portal = purple_portal
	
	purple_portal.color =  "purple"
	purple_portal.target_portal = green_portal
	
	add_child(green_portal)
	add_child(purple_portal)

func _on_portal_timer_timeout() -> void:
	green_portal.kill()
	purple_portal.kill()
	
	spawn_new_portals()
