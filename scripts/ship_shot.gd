extends Area2D

var vel = 200 # variavel para velocidade do disparo
var dir = Vector2(0,-1) # variavel para direção do disparo 


func _ready():
	add_to_group("ship_shot")
	set_process(true)
	
func _process(delta):
	translate(dir * vel * delta) # Efetua disparo
	
	if get_global_position().y < 0:
		queue_free()

func _on_ship_shot_area_entered(area):
	if area.has_method("destroy"):
		area.destroy(self)
		destroy(self)
		
func destroy(obj):
	queue_free()
