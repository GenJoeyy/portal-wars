extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Title.play("zoom in")
	$"TitleTimer".start()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_title_timer_timeout() -> void:
	$Title.play("static")
