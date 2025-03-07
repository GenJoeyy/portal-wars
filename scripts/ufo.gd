extends Enemy
@onready var timer: Timer = $TimerDeath
@onready var explosion_sprite: AnimatedSprite2D = $ExplosionSprite
@onready var player: CharacterBody2D = $"/root/Game/Player"
@onready var hit: AudioStreamPlayer2D = $Hit
@onready var explosion_sound: AudioStreamPlayer2D = $Explosion_Sound
@onready var ubullet_scene = preload("res://scenes/ufo_bullet.tscn")


var alive = true
var ufo_direction 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	
	
func _physics_process(delta: float) -> void:
	ufo_direction = (position - player.position).normalized()
	position -= ufo_direction * movement_speed * delta
	
#Tod
func _on_area_2d_area_entered(_area: Area2D) -> void:
	if alive:
		if health == 1:
			alive = false
			movement_speed = 0
			$Area2D/CollisionShape2D.disabled = true
			timer.start()
			explosion_sprite.play()
			explosion_sound.play()
		else:
			health -= 1
			hit.play()

#TodTimer
func _on_timer_timeout() -> void:
	queue_free()

#SchussTimer 
func _on_timer_shoot_timeout() -> void:
	if alive:
		shoot()
	
func shoot():
	var ubullet = ubullet_scene.instantiate()
	ubullet.position = position
	ubullet.ufo_bullet_direction = (position - player.position).normalized()
	#ubullet.look_at(player.global_position)
	get_parent().add_child(ubullet)
	pass
