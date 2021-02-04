extends KinematicBody2D

var foodIcon = preload("res://assets/cutlery.png")
var sleepIcon = preload("res://assets/zs.png")
var drinkIcon = preload("res://assets/genericItem_color_118.png")

var target = Vector2(500,1100)
var speed = 5
var isMoving = false
var lastEnteredFoodInstance = null

func _ready():
	get_node("AnimationPlayer").play("stand")

func _input(event):
	if event is InputEventMouseButton:
		target = event.position

func _process(delta):
	if !get_parent().isSleeping():
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
	get_parent().changeDrinkLevel(30)
	get_parent().changeSleepLevel(-10)
	get_parent().lastDrunk = OS.get_ticks_msec()

func showEat(foodInstance):
	get_node("Prompt").show()
	get_node("Prompt/icon").texture = foodIcon
	
	lastEnteredFoodInstance = foodInstance

func eat():
	get_parent().changeFoodLevel(10)
	get_parent().changeSleepLevel(-10)
	get_parent().lastEaten = OS.get_ticks_msec()
	
	lastEnteredFoodInstance.hide()
	lastEnteredFoodInstance.queue_free()
	hidePrompt(null)

func showSleep(body):
	get_node("Prompt").show()
	get_node("Prompt/icon").texture = sleepIcon

func sleep():
	if !get_parent().isSleeping():
		get_parent().changeSleepLevel(50)
		get_parent().lastSlept = OS.get_ticks_msec()

func hidePrompt(body):
	get_node("Prompt").hide()

func Prompt_clicked():
	if get_node("Prompt/icon").texture == drinkIcon:
		drink()
	elif get_node("Prompt/icon").texture == foodIcon:
		eat()
	else:
		sleep()
