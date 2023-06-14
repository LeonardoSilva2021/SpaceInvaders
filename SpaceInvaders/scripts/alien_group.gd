extends Node2D

const vel = Vector2(6, 0)

var pre_alien_shot = preload("res://scenes/alien_shot.tscn")
var pre_alien_explosion = preload("res://scenes/alien_explosion.tscn")
var pre_mother_ship = preload("res://scenes/mother_ship.tscn")

var dir = 1

signal enemy_down(obj)
signal Ready
signal earth_dominated
signal victory


func _ready():
	restart_timer_mother_ship()
	for alien in get_node("aliens").get_children():
		alien.hide()
		alien.connect("destroyed" , self, "on_alien_destroyed")
		
	for alien in get_node("aliens").get_children():
		get_node("timer_pause").start()
		yield(get_node("timer_pause") , "timeout")
		alien.show()
		
	emit_signal("Ready")
	start_all()

func shot():
	var n_aliens = get_node("aliens").get_child_count()
	if n_aliens > 0:
		var alien =  get_node("aliens").get_child(randi() % n_aliens)
		var alien_shot = pre_alien_shot.instance()
		get_parent().add_child(alien_shot)
		alien_shot.set_global_position(alien.get_global_position())	

func _on_timer_shot_timeout():
	get_node("timer_shot").set_wait_time(rand_range(.5 , 2))
	shot()

func _on_timer_move_timeout():
	
	var border = false
	
	for alien in get_node("aliens").get_children():
		alien.next_frame()
		if alien.get_global_position().x > 170 and dir > 0:
			dir = -1
			border = true
		if alien.get_global_position().x < 10 and dir < 0:
			dir = 1
			border = true
	
		if alien.get_global_position(). y > 267:
			emit_signal("earth_dominated")
	
	if border:
		translate(Vector2(0,8))
		if get_node("timer_move").get_wait_time() > .11:
			get_node("timer_move").set_wait_time(get_node("timer_move").get_wait_time() - .07)
	else:
		translate(vel * dir)

func on_alien_destroyed(alien):
	emit_signal("enemy_down" , alien)
	var alien_exp = pre_alien_explosion.instance()
	get_parent().add_child(alien_exp)
	alien_exp.set_global_position(alien.get_global_position())
	if get_node("aliens").get_child_count() == 1:
		stop_all()
		emit_signal("victory")

func _on_timer_mother_ship_timeout():
	var mother_ship = pre_mother_ship.instance()
	mother_ship.connect("destroyed" , self, "on_alien_destroyed")
	get_parent().add_child(mother_ship)
	restart_timer_mother_ship()

func restart_timer_mother_ship():
	get_node("timer_mother_ship").set_wait_time(rand_range(6 , 15))
	get_node("timer_mother_ship").start()

func stop_all():
	get_node("timer_mother_ship").stop()
	get_node("timer_shot").stop()
	get_node("timer_move").stop()

func start_all():
	get_node("timer_mother_ship").start()
	get_node("timer_shot").start()
	get_node("timer_move").start()

