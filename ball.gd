extends Node2D

class_name Ball, "res://ball.gd"

var pos = Vector2(0,0)
var radius: float
var angle_from: float
var angle_to: float

func _init(pos: Vector2, radius: float, angle_from: float = 0.0, angle_to: float = 360.0):
	self.pos = pos
	self.radius = radius
	self.angle_from = angle_from
	self.angle_to = angle_to

func _ready():
	add_to_group("balls")

func _draw():
	draw_circle_arc_poly(pos, radius, angle_from, angle_to, Color(0.5,0.9,0.6))
	
func delete():
	queue_free()
	
func draw_circle_arc_poly(center, radius, angle_from, angle_to, color):
    var nb_points = 32
    var points_arc = PoolVector2Array()
    points_arc.push_back(center)
    var colors = PoolColorArray([color])

    for i in range(nb_points + 1):
        var angle_point = deg2rad(angle_from + i * (angle_to - angle_from) / nb_points - 90)
        points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
    draw_polygon(points_arc, colors)