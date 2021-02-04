extends TextureRect

func _ready():
	get_node("AnimationPlayer").play("shake")
