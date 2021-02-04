extends Node2D

const food = preload("res://food.tscn")
var foodsNode = null
var foodAreaSize = Vector2(-1,-1)

const foodRefeshTime = 5000
const halfFoodSize = Vector2(128,128)
const maxFoodCount = 4

var lastFoodSpawned = OS.get_ticks_msec()
var lastEaten = OS.get_ticks_msec()
var lastDrunk = OS.get_ticks_msec()
var lastSlept = OS.get_ticks_msec()

var lastTick = OS.get_ticks_msec()

func _ready():
	randomize()
	foodsNode = get_node("Foods")
	foodAreaSize = get_node("grass/grass").get_rect().size - halfFoodSize

func _process(delta):
	var currentTick = OS.get_ticks_msec()

	if lastTick + 100 < currentTick:
		lastTick = currentTick
		
		if lastEaten + 5000 < currentTick:
			get_node("Bars/Food").value -= 0.1
		if lastDrunk + 5000 < currentTick:
			get_node("Bars/Drink").value -= 0.1
		if get_node("Cera").isMoving:
			get_node("Bars/Sleep").value -= 0.1

	if lastFoodSpawned + foodRefeshTime < currentTick:
		lastFoodSpawned = currentTick
		
		if foodsNode.get_child_count() < maxFoodCount:
			var foodToAdd = food.instance()
			
			foodToAdd.position = Vector2(randf(),randf()) * foodAreaSize
			
			foodsNode.add_child(foodToAdd)
