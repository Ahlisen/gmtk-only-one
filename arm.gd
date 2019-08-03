extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# Called when the node enters the scene tree for the first time.

class_name Arm, "res://arm.gd"

var handPosition: Vector2 = Vector2(0,0)
var startPosition: Vector2 = Vector2(0,0)
var target: WeakRef = null
var progress: float = 0
var speed: float = 0.02

func _ready():
	var size = get_viewport_rect().size
	startPosition = Vector2(0, randf()*size.y)
	speed = randf() * 0.01 + 0.01

func _process(delta):
	
	if target == null:
		reset_target()
	else:
		var ref = target.get_ref()
	
		if ref:
			handPosition = startPosition.linear_interpolate(ref.pos, progress)
			if progress < 1:
				progress += speed
			else:
				ref.delete()
				target = null
			update()
		else:
			reset_target()

func _draw():
	draw_line(startPosition, handPosition, Color(0.5,1,1), 10)
	
func clear_target():
	target = null
	
func reset_target():
	var targets = get_tree().get_nodes_in_group("balls")
	if targets.size() != 0:
		var index = randi()%targets.size()
		target = weakref(targets[index])
		handPosition = startPosition
		progress = 0
		update()