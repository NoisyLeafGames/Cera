extends KinematicBody2D

var foodIcon = preload("res://assets/cutlery.png")
var sleepIcon = preload("res://assets/zs.png")
var drinkIcon = preload("res://assets/genericItem_color_118.png")

var target = Vector2(500,1100)
var speed = 5
var isMoving = false

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
			setRunning(false)
			
			var a = collision.get_collider_id()
		else:
			setRunning(true)
		
		if velocity.x < 0:
			rotation = 0
			scale = Vector2(-0.3, 0.3)
		else:
			rotation = 0
			scale = Vector2(0.3, 0.3)
	else:
		setRunning(false)

func setRunning(running):
	isMoving = running
	
	if running:
		get_node("AnimationPlayer").play("run")
	else:
		get_node("AnimationPlayer").play("stand")
	

func showDrink(body):
	get_node("Prompt").show()
	get_node("Prompt/icon").texture = drinkIcon

func drink():
	get_node("Prompt").hide()

func showEat(body):
	get_node("Prompt").show()
	get_node("Prompt/icon").texture = foodIcon

func eat():
	get_node("Prompt").hide()

func showSleep(body):
	get_node("Prompt").show()
	get_node("Prompt/icon").texture = sleepIcon

func sleep():
	get_node("Prompt").hide()

func hidePrompt(body):
	get_node("Prompt").hide()

func Prompt_clicked():
	if get_node("Prompt/icon").texture == drinkIcon:
		drink()
	elif get_node("Prompt/icon").texture == foodIcon:
		eat()
	else:
		sleep()
