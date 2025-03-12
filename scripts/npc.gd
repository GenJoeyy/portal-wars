extends CharacterBody2D
class_name NPC

@onready var player: CharacterBody2D = $"/root/Game/GameContent/Player"
@onready var hitbox: Area2D = $Hitbox
@onready var hit_sound: AudioStreamPlayer2D = $HitSound
@onready var death_animation: AnimatedSprite2D = $DeathAnimation
@onready var death_sound: AudioStreamPlayer2D = $DeathSound

@export var is_hostile: bool 
@export var health: float = 1
@export var speed: float = 150
@export var fire_rate: float = 0.5 # if hostile npc

var direction: Vector2
var alive = true
var bullet_scene: PackedScene # if hostile npc
var shoot_timer: Timer # if hostile npc

func _ready() -> void:
	setup_hit_detection()
	if is_hostile:
		setup_shoot_timer()

func _physics_process(delta: float) -> void:
	if alive:
		update_direction(delta)
		position -= direction * speed * delta
	
# can be overridden
func update_direction(delta: float) -> void:
	direction = (position - player.global_position if is_hostile else  direction).normalized()

	
func hit(damage_taken: float) -> void:
	if alive:
		if hit_sound:
			hit_sound.play()
			
		health -= damage_taken
		if health <= 0:
			die()

func die() -> void:
	alive = false
	hitbox.queue_free()
	play_death_animation()

func play_death_animation() -> void:
	if death_animation:
		death_animation.play()
	if death_sound:
		death_sound.play()
	
	death_animation.animation_finished.connect(queue_free)

func setup_hit_detection() -> void:
	hitbox.area_entered.connect(_on_area_2d_area_entered)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is Bullet and area.is_player_bullet:
		var bullet: Bullet = area
		hit(bullet.damage)
	elif area.get_parent() is Player and is_hostile:
		hit(1)


# ---- if hostile npc ----

func setup_shoot_timer() -> void:
	shoot_timer = Timer.new()
	shoot_timer.wait_time = 1 / fire_rate
	shoot_timer.autostart = true
	shoot_timer.one_shot = false
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)
	add_child(shoot_timer)

func _on_shoot_timer_timeout() -> void:
	if alive:
		shoot()

func shoot():
	var bullet = bullet_scene.instantiate()
	bullet.position = position
	bullet.direction = (position - player.position).normalized()
	get_parent().add_child(bullet)
