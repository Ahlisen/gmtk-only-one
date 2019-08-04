extends Node2D

var keyPairs = [
	[KEY_W, KEY_S],
	[KEY_KP_1, KEY_KP_2],
	[KEY_K, KEY_L]
]

var players = []

var plateLocations = [
	Vector3(870,250,70),
	Vector3(1160,490,85),
	Vector3(740,480,110)
]

var fikaCount = 0
var gameHasStarted = false


var snatch = preload("res://audio/snatch1.ogg")
var snatch2 = preload("res://audio/snatch2.ogg")

func add_players(count):
	var size = get_viewport_rect().size
	for i in count:
		var b = keyPairs[i]
		var x = float(i+1) / (count+2) * size.x
		var pos = Vector2(x, size.y)
		var arm = Arm.new(b[0], b[1], fikaCount, pos)
		arm.connect("hit", self, "give_score")
		arm.connect("over", self, "game_over")
		add_child(arm)
		players.append(arm)

func _ready():
	randomize()
#	start_game()
	add_players(3)
	convertPlayersToAI()
		
func start_game():
	var size = get_viewport_rect().size
	
	var radiusw = 100
	var center = Vector2(730,480) #Vector2(size.x/2, size.y/4)
		
	for i in plateLocations:
		var pos = Vector2(i.x,i.y)
		
		if randf() > 0.5:
			var slices = randi()%10 + 5
			create_cake(pos, slices, i.z)
			fikaCount += slices
		else:
			var radius = i.z
			for j in rand_range(10,i.z/4):
				var angle = j
				var pos1 = pos + Vector2(cos(angle)*radius, sin(angle)*radius*0.9)
				var col = Color(0.2,0.7,0.4)
				var b = Ball.new(pos1, i.z/4, col)
				add_child(b)
				fikaCount += 1
				radius -= 3

func create_cake(position: Vector2, numSlices: int, radius: float):
	
	for i in numSlices:
		var sliceAngle = 360.0 / numSlices
		var b = Ball.new(position, radius, Color(0.3,0.7,0.4), i*sliceAngle, (i+1)*sliceAngle)
		add_child(b)
		
func give_score(score):
	var message = ""
	for player in players:
		message += String(player.score) + "\n"
	$HUD.show_message(message)


func game_over():
	gameHasStarted = false
	print("gameVOER")
	$PlayMusic.stop()
	$MenuMusic.play()

func convertPlayersToAI():
	var aiplayers = int($HUD/ColorRect/PlayerSlider.value)
	for i in players.size():
		players[i].isAI = (i >= aiplayers)

func _on_HUD_playerCountChanged():
	convertPlayersToAI()

func _on_HUD_start():
	if !gameHasStarted:
		start_game()
		for player in players:
			player.totalFika = fikaCount
			player.score = 0
			player.velocity = 0.0
		gameHasStarted = true
		$PlayMusic.play()
		$MenuMusic.stop()