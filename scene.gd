extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	
	var size = get_viewport_rect().size
	for i in 50:
		var pos = Vector2(randf()*size.x, randf()*size.y)
		var b = Ball.new(pos)
		add_child(b)
	
	for i in 2:
		var arm = Arm.new()
		add_child(arm)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
		