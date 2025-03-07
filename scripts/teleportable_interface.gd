extends Node

class_name Teleportable 

var tp_allowed: bool = true

func enable_tp():
	tp_allowed = true

func disable_tp():
	tp_allowed = false
