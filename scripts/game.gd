extends Node2D

@onready var heartcontainer: HBoxContainer = $Health/Heartcontainer
@onready var player: CharacterBody2D = $GameContent/Player

const PORTAL = preload("res://scenes/portal.tscn")
const UFO = preload("res://scenes/ufo.tscn")

var game_running = false
var portal_shape: Vector2i = PORTAL.instantiate().shape
var portal_spawn_borders

var green_portal: Portal
var purple_portal: Portal

func _ready() -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	start_game()

func _process(delta: float) -> void:
	if game_running:
		# make portals look at center
		green_portal.look_at(Vector2.ZERO)
		purple_portal.look_at(Vector2.ZERO)

func start_game() -> void:
	game_running = true
	
	setup_ufo_spawners()
	setup_friendly_spawner()
	setup_portal_spawns()
	setup_heartcontainer()
	setup_highscore()

func setup_ufo_spawners() -> void:
	var spawns = [
		Vector2(-1200, 0),
		Vector2(1200, 0),
		Vector2(-900, -700),
		Vector2(900, -700),
		Vector2(0, -700),
	]
	var spawner_scene = preload("res://scenes/ufo_spawner.tscn")
	for spawn in spawns:
		var spawner = spawner_scene.instantiate()
		spawner.position = spawn
		add_child(spawner)

func setup_friendly_spawner() -> void:
	var friendlySpawner = preload("res://scenes/friendly_spawner.tscn")
	add_child(friendlySpawner.instantiate())

func rand_canvas_coords() -> Vector2:
	var spawn_borders = get_viewport().get_size() * 0.8 # padding
	spawn_borders /= 2
	
	var min_x = -spawn_borders.x
	var max_x = spawn_borders.x
	var min_y = -spawn_borders.y
	var max_y = spawn_borders.y
	
	return Vector2(
		randf_range(min_x, max_x),
		randf_range(min_y, max_y))

func setup_portal_spawns() -> void:
	spawn_new_portals()
	$GameContent/PortalTimer.start()

func verify_portal_coords(a: Vector2, b: Vector2) -> bool:
	var distance_a_b = a.distance_to(b) > portal_shape.y * 7
	
	var player = $GameContent/Player.global_position

	var distance_a_player = a.distance_to(player) > portal_shape.y
	var distance_b_player = b.distance_to(player) > portal_shape.y
	
	return distance_a_b && distance_a_player && distance_b_player
	
func spawn_new_portals():
	var green_pos = rand_canvas_coords()
	var purple_pos = rand_canvas_coords()
	
	while not verify_portal_coords(green_pos, purple_pos):
		green_pos = rand_canvas_coords()
		purple_pos = rand_canvas_coords()
	
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

func setup_heartcontainer() -> void:
	heartcontainer.set_Max_Hearts(player.health)
	heartcontainer.update_Hearts(player.current_health)
	player.healthChanged.connect(heartcontainer.update_Hearts)

func setup_highscore() -> void:
	$GameContent/ScoreContainer/Highscore.text =  str(SaveLoad.highscore)
