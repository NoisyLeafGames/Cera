extends KinematicBody2D

var target = Vector2(500,1100)
var speed = 5

func _ready():
	get_node("AnimationPlayer").play("stand")

func _input(event):
	if event is InputEventMouseButton:
		target = event.position

func _process(delta):
	var velocity = (target - position).normalized() * speed
	
	if (target - position).length() > 10:
		
		var collision = move_and_collide(velocity)
		
		if collision != null:
			get_node("AnimationPlayer").play("stand")
		else:
			get_node("AnimationPlayer").play("run")
		
		if velocity.x < 0:
			rotation = 0
			scale = Vector2(-0.3, 0.3)
		else:
			rotation = 0
			scale = Vector2(0.3, 0.3)
	else:
		get_node("AnimationPlayer").play("stand")
