extends Area2D
class_name Portal
func _on_area_entered(area: Area2D) -> void:
	if Teleportable:
		return 
	
