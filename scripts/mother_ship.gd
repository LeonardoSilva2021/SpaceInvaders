extends Node2D

signal destroyed(obj)

var score = 200


func _ready():
	get_node("anim").play("default")
	yield(get_node("anim"), "animation_finished")
	queue_free()

func destroy(obj):
	emit_signal("destroyed" , self)
	queue_free()
