extends Node2D

var target = Vector2(0,0)
var speed = 5

func _ready():
	get_node("AnimationPlayer").play("stand")

func _input(event):
	if event is InputEventMouseButton:
		target = event.position

func _process(delta):
	var velocity = (target - position).normalized() * speed
	
	if (target - position).length() > 5:
		get_node("AnimationPlayer").play("run")
		
		position += velocity
	else:
		get_node("AnimationPlayer").play("stand")
	
	if velocity.x < 0:
		set_scale(Vector2(-1,1))
	else:
		set_scale(Vector2(1,1))
