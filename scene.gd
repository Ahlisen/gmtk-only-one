extends Node2D

# Called when the node enters the scene tree for the first time.

var keyPairs = [
	[KEY_W, KEY_S],
	[KEY_KP_1, KEY_KP_2],
	[KEY_K, KEY_J]
]

func _ready():
	
	var size = get_viewport_rect().size
	for i in 5:
		var pos = Vector2(randf()*size.x, randf()*size.y)
		var b = Ball.new(pos, 15)
		add_child(b)
		
	for i in 10:
		var pos = Vector2(randf()*size.x, randf()*size.y)
		create_cake(pos)
	
	for i in keyPairs:
		var arm = Arm.new(i[0], i[1])
		add_child(arm)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
		
func create_cake(position: Vector2):
	var slices = randi()%6 + 4
	
	for i in slices:
		var sliceAngle = 360.0 / slices
		var b = Ball.new(position, 30, i*sliceAngle, (i+1)*sliceAngle)
		add_child(b)