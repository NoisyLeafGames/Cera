extends Node2D

const food = preload("res://food.tscn")
var foodsNode = null
var foodAreaSize

var lastFoodAdded = 

const halfFoodSize = Vector2(128,128)
const maxFoodCount = 3

func _ready():
	randomize()
	foodsNode = get_node("Foods")
	foodAreaSize = get_node("grass/grass").get_rect().size - halfFoodSize

func _process(delta):
	if foodsNode.get_child_count() <= maxFoodCount:
		var foodToAdd = food.instance()
		
		foodToAdd.position = Vector2(randf(),randf()) * foodAreaSize
		
		foodsNode.add_child(foodToAdd)
