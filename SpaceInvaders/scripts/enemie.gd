tool
extends Area2D

export(int , "A", "B", "C") var tipo = 0 setget set_tipo

var score = 0
var frame = 0

signal destroyed(obj) 

var atributos = [
	{
		texture = preload("res://sprites/InvaderA_sheet.png"),
		score = 10
	},
	{
		texture = preload("res://sprites/InvaderB_sheet.png"),
		score = 20
	},
	{
		texture = preload("res://sprites/InvaderC_sheet.png"),
		score = 30
	}
]


func _ready():
	pass

func _draw():
	var atributo = atributos[tipo]
	get_node("sprite").set_texture(atributo.texture)
	score = atributo.score

func set_tipo(val):
	tipo = val
	update()

func destroy(obj):
	emit_signal("destroyed" , self)
	queue_free()

func next_frame():
	if frame == 0:
		frame = 1
	else:
		frame = 0
	get_node("sprite").set_frame(frame)

func _on_enemie_area_enter ( area ):
	if area.has_method("destroy"):
		area.desroy(self)
