extends Node2D

func _ready():
	var rand = randi()%3
	if rand == 0:
		get_node("TextureRect").visible = true
	elif rand == 1:
		get_node("TextureRect2").visible = true
	else:
		get_node("TextureRect3").visible = true
	
	get_node("Area2D").connect("body_entered", self, "food_entered")
	get_node("Area2D").connect("body_exited", self, "food_exited")

func food_entered(body):
	get_parent().get_parent().food_entered(self)

func food_exited(body):
	get_parent().get_parent().food_exited()
