extends Enemy
@onready var timer: Timer = $Timer
@onready var explosion_sprite: AnimatedSprite2D = $ExplosionSprite
@onready var player: CharacterBody2D = $"../Player"
@onready var hit: AudioStreamPlayer2D = $Hit
@onready var explosion_sound: AudioStreamPlayer2D = $Explosion_Sound

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
func _on_area_2d_area_entered(area: Area2D) -> void:
	if alive:
		if health == 0:
			alive = false
			timer.start()
			explosion_sprite.play()
			explosion_sound.play()
		else: 
			health -= 1
			hit.play()



func _on_timer_timeout() -> void:
	queue_free()
