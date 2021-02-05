extends KinematicBody2D

var foodIcon = preload("res://assets/cutlery.png")
var sleepIcon = preload("res://assets/zs.png")
var drinkIcon = preload("res://assets/genericItem_color_118.png")
var sawIcon = preload("res://assets/saw.png")
var hammerIcon = preload("res://assets/hammer.png")
var paintIcon = preload("res://assets/paintbrush.png")

var target = Vector2(500,1100)
var speed = 5
var isMoving = false
var lastEnteredFoodInstance = null

var buildProgress = 1

func _ready():
	get_node("AnimationPlayer").play("stand")

func _input(event):
	if event is InputEventMouseButton:
		target = event.position

func _process(delta):
	get_node("Node2D/Sad Mouth").visible = !get_parent().getHealthy()
	get_node("Node2D/Happy Mouth").visible = get_parent().getHealthy()
	
	if !get_parent().isSleeping():
		var current_speed = speed
		
		if get_parent().getSleepLevel() <= 0:
			current_speed = speed / 2
		
		var velocity = (target - position).normalized() * current_speed
		
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

func canDrink():
	return get_parent().getSleepLevel() > 10 && get_parent().getDrinkLevel() < 95

func showDrink(body):
	if canDrink():
		get_node("Prompt").show()
		get_node("Prompt/icon").texture = drinkIcon

func drink():
	get_parent().changeDrinkLevel(30)
	get_parent().changeSleepLevel(-10)
	get_parent().lastDrunk = OS.get_ticks_msec()
	
	if !canDrink():
		hidePrompt(null)

func canEat():
	return get_parent().getSleepLevel() > 10 && get_parent().getFoodLevel() < 95

func showEat(foodInstance):
	if canEat():
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
	
	if !canEat():
		hidePrompt(null)

func showSleep(body):
	get_node("Prompt").show()
	get_node("Prompt/icon").texture = sleepIcon

func sleep():
	get_parent().lastSlept = OS.get_ticks_msec()

func canBuild():
	return get_parent().getVeryHealthy() && buildProgress < 12

func showBuild(body):
	if canBuild():
		get_node("Prompt/icon").texture = paintIcon
		if buildProgress < 5:
			get_node("Prompt/icon").texture = hammerIcon
		if buildProgress < 3:
			get_node("Prompt/icon").texture = sawIcon
		
		get_node("Prompt").show()

func build():
	get_parent().changeFoodLevel(-50)
	get_parent().changeDrinkLevel(-50)
	get_parent().changeSleepLevel(-50)
	
	buildProgress += 1
	
	get_parent().get_node("picture").texture = load("res://assets/final-banner-" + str(buildProgress) + ".png")
	
	if !canBuild():
		hidePrompt(null)

func hidePrompt(body):
	get_node("Prompt").hide()

func Prompt_clicked():
	if get_node("Prompt/icon").texture == drinkIcon:
		drink()
	elif get_node("Prompt/icon").texture == foodIcon:
		eat()
	elif get_node("Prompt/icon").texture == sleepIcon:
		sleep()
	else:
		build()
