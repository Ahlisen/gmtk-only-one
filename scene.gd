extends Node2D

var keyPairs = [
	[KEY_W, KEY_S],
	[KEY_KP_1, KEY_KP_2],
	[KEY_K, KEY_J]
]

var players = []

var fikaCount = 0

func _ready():
	start_game()
		
func start_game():
	var size = get_viewport_rect().size
	for i in 5:
		var pos = Vector2(randf()*size.x, randf()*size.y)
		var b = Ball.new(pos, 15)
		add_child(b)
		fikaCount += 1
		
	for i in 10:
		var pos = Vector2(randf()*size.x, randf()*size.y)
		var slices = randi()%6 + 4
		create_cake(pos, slices)
		fikaCount += slices
	
	for i in keyPairs.size():
		var b = keyPairs[i]
		var x = float(i) / keyPairs.size() * size.x
		var pos = Vector2(x, size.y)
		var arm = Arm.new(b[0], b[1], fikaCount, pos)
		arm.connect("hit", self, "give_score")
		add_child(arm)
		players.append(arm)

func create_cake(position: Vector2, numSlices: int):
	
	for i in numSlices:
		var sliceAngle = 360.0 / numSlices
		var b = Ball.new(position, 150, i*sliceAngle, (i+1)*sliceAngle)
		add_child(b)
		
func give_score(score):
	var message = ""
	for player in players:
		message += String(player.score) + "\n"
	$HUD.show_message(message)