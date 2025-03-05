extends Enemy
@onready var animated_sprite_2d_2: AnimatedSprite2D = $AnimatedSprite2D2
@onready var timer: Timer = $Timer
@onready var explosion: AudioStreamPlayer2D = $Explosion

var alive = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

#Tod
func _on_area_2d_area_entered(area: Area2D) -> void:
	if alive:
		alive = false
		timer.start()
		explosion.play()
		animated_sprite_2d_2.play("Explosion")


func _on_timer_timeout() -> void:
	queue_free()
