extends Node2D

func _ready():
	var rand = randi()%3
	if rand == 0:
		get_node("TextureRect").visible = true
	elif rand == 1:
		get_node("TextureRect2").visible = true
	else:
		get_node("TextureRect3").visible = true
