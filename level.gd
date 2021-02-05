extends Node2D

const food = preload("res://food.tscn")
var foodsNode = null
var foodAreaSize = Vector2(-1,-1)

const foodRefeshTime = 5000
const halfFoodSize = Vector2(128,128)
const foodGrowthBorderSize = Vector2(256, 256)
const maxFoodCount = 4

const sleepTime = 3000

var lastFoodSpawned = OS.get_ticks_msec()
var lastSlept = OS.get_ticks_msec()
var lastEaten = OS.get_ticks_msec()
var lastDrunk = OS.get_ticks_msec()

var lastTick = OS.get_ticks_msec()

func _ready():
	randomize()
	foodsNode = get_node("Foods")
	foodAreaSize = get_node("grass/grass").get_rect().size - halfFoodSize - foodGrowthBorderSize 

func _process(delta):
	var currentTick = OS.get_ticks_msec()

	if lastTick + 100 < currentTick:
		lastTick = currentTick
		
		if lastEaten + 2000 < currentTick:
			changeFoodLevel(-0.1)
		if lastDrunk + 2000 < currentTick:
			changeDrinkLevel(-0.1)
		if get_node("Cera").isMoving:
			changeSleepLevel(-0.2)
		if isSleeping():
			changeSleepLevel(2)

	if lastFoodSpawned + foodRefeshTime < currentTick:
		lastFoodSpawned = currentTick
		
		if foodsNode.get_child_count() < maxFoodCount:
			var foodToAdd = food.instance()
			
			foodToAdd.position = Vector2(randf(),randf()) * foodAreaSize + foodGrowthBorderSize / 2
			
			foodsNode.add_child(foodToAdd)

func isSleeping():
	return lastSlept + sleepTime >= OS.get_ticks_msec()

func getSleepLevel():
	return get_node("Bars/Sleep").value

func getFoodLevel():
	return get_node("Bars/Food").value

func getDrinkLevel():
	return get_node("Bars/Drink").value

func getHealthy():
	return get_node("Bars/Sleep").value > 0 && get_node("Bars/Food").value > 0 && get_node("Bars/Drink").value > 0

func getVeryHealthy():
	return get_node("Bars/Sleep").value > 60 && get_node("Bars/Food").value > 60 && get_node("Bars/Drink").value > 60

func changeFoodLevel(amount):
	get_node("Bars/Food").value += amount

func changeDrinkLevel(amount):
	get_node("Bars/Drink").value += amount

func changeSleepLevel(amount):
	get_node("Bars/Sleep").value += amount

func food_entered(foodInstance):
	get_node("Cera").showEat(foodInstance)

func food_exited():
	get_node("Cera").hidePrompt(null)
