extends Node2D

@onready var game: Node2D = $".."
@onready var button_play: Button = $Buttons/ButtonPlay
@onready var button_ship: Button = $Buttons/ButtonShip
@onready var button_quit: Button = $Buttons/ButtonQuit

var enabled = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Title.play("zoom in")
	$"TitleTimer".start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not enabled:
		visible = false
		button_play.disabled = true
		button_ship.disabled = true
		button_quit.disabled = true
		return
	else:
		visible = true
		button_play.disabled = false
		button_ship.disabled = true
		button_quit.disabled = false

func _on_title_timer_timeout() -> void:
	$Title.play("static")
	$Buttons.visible = true


func _on_button_play_pressed() -> void:
	game.start_game()

func _on_button_ship_pressed() -> void:
	pass # Replace with function body.

func _on_button_quit_pressed() -> void:
	get_tree().quit()
