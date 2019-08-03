extends Node2D

class_name Ball, "res://ball.gd"

var pos = Vector2(0,0)

func _init(pos: Vector2):
	self.pos = pos

func _ready():
	add_to_group("balls")

func _process(delta):
	pos.x = pos.x + 0.1
	update()
	
func _draw():
	draw_circle(pos, 10, Color(0.5,0.7,0.6))
	
func delete():
	queue_free()