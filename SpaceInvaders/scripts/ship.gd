extends Area2D

const vel = 80 # Constante de velocidade da nave

var prev_shot = preload("res://scenes/ship_shot.tscn")

var x
var y
var z
var left # Variavel de direção da nave 
var right # Variavel de direção da nave 
var lazer # Variavel de disparo
var prev_lazer = false # Variavel para verificação de disparo

var dir = 0

var alive = true

signal destroyed
signal respawn


func _ready():
	hide()
	#set_process(true)
	
func _process(delta):
	
	dir = 0
	
	right = Input.is_action_pressed("ui_right") # Recebe rusultado do botão para movimentação da nave para esquerda
	left = Input.is_action_pressed("ui_left")  # Recebe rusultado do botão para movimentação da nave para esquerda
	lazer = Input.is_action_pressed("disparo") # Recebe rusultado do botão para disparo da nave
	
	if right:
		dir += 1
		 
	if left:
		dir -= 1

	translate(Vector2(1,0) * vel * dir * delta) # movimentação da nave
	
	set_global_position(Vector2(clamp(get_global_position().x, 7, 173), get_global_position().y)) # Limita a movimentação da nave
	
	if lazer and not prev_lazer and get_tree().get_nodes_in_group("ship_shot").size() == 0 : # Efetua disparos e limita quantidade de disparos
		var shot = prev_shot.instance()
		get_parent().add_child(shot)
		shot.set_global_position(get_global_position())
		
	prev_lazer = lazer
	
func start():
	show()
	set_process(true)
	
func disable():
	hide()
	set_process(false)
	alive = false

func destroy(obj):
	if alive:
		alive = false
		set_process(false)
		emit_signal("destroyed")
		get_node("anim").play("explode")
		yield(get_node("anim"), "animation_finished")
		emit_signal("respawn")
		set_process(true)
		alive = true
		get_node("sprite").set_frame(0)
