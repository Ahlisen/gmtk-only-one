extends Node2D

class_name Arm, "res://arm.gd"

var handPosition: Vector2 = Vector2(0,0)
var oldHandPosition: Vector2 = Vector2(0,0)
var oldShoulderPosition: Vector2 = Vector2(0,0)
var shoulderPosition: Vector2 = Vector2(0,0)
var bodyPosition: Vector2 = Vector2(0,0)
var targetPosition: Vector2 = Vector2(0,0)
var target: WeakRef = null
var progress: float = 0
var velocity: float = 0
var keyUp: int
var keyDown: int

var angle1: float = 0
var angle2: float = 0

var length1 = 300
var length2 = 250

func _init(keyUp: int, keyDown: int):
	self.keyUp = keyUp
	self.keyDown = keyDown

func _ready():
	var size = get_viewport_rect().size
	bodyPosition = Vector2(0, randf()*size.y)
	shoulderPosition = bodyPosition
	oldHandPosition = shoulderPosition
	oldShoulderPosition = shoulderPosition
	velocity = 0

func _process(delta):
	
	velocity += (float(Input.is_key_pressed(keyUp)) - float(Input.is_key_pressed(keyDown))) * 0.01
	velocity = clamp(velocity, 0, 5)
        
	if target == null:
		reset_target()
	else:
		var ref = target.get_ref()
		
		if ref:
			targetPosition = ref.pos
		else:
			reset_target()
			
		if progress < 1:
			progress += velocity * delta
		else:
			if ref:
				ref.delete()
			target = null
	
		var dist = bodyPosition.distance_to(targetPosition)
		var comp = max(dist - (length1+length2), 0)
		var stretchShoulderRatio = comp / dist
		var stretchShoulderPosition = bodyPosition.linear_interpolate(targetPosition, stretchShoulderRatio)
		shoulderPosition = oldShoulderPosition.linear_interpolate(stretchShoulderPosition, progress)
		handPosition = oldHandPosition.linear_interpolate(targetPosition, progress)
		ik()
		update()

func _draw():
	var arm1 = Vector2(shoulderPosition.x + cos(angle1) * length1, shoulderPosition.y + sin(angle1) * length1)
	var arm2 = Vector2(arm1.x + cos(angle2 + angle1) * length2, arm1.y + sin(angle2 + angle1) * length2)
	draw_line(shoulderPosition, arm1, Color(1,0.5,0.6), 15)
	draw_line(arm1, arm2, Color(1,0.85,0.6), 10)
	draw_line(bodyPosition, shoulderPosition, Color(0.25,0.75,1), 40)
	draw_circle(arm2, 20, Color(1,0.75,0.6))
	
func clear_target():
	target = null
	
func reset_target():
	var targets = get_tree().get_nodes_in_group("balls")
	if targets.size() != 0:
		var index = randi()%targets.size()
		target = weakref(targets[index])
		oldHandPosition = handPosition
		oldShoulderPosition = shoulderPosition
		shoulderPosition = bodyPosition
		progress = 0
		
func ik():
	
	var targetX = handPosition.x - shoulderPosition.x
	var targetY = handPosition.y - shoulderPosition.y
	
	var epsilon = 0.0001
	
	var solvePosAngle2 = true
	var foundValidSolution = true
	
	var targetDistSqr = targetX*targetX + targetY*targetY
	
	var sinAngle2: float
	var cosAngle2: float
	
	var cosAngle2_denom = 2*length1*length2;

	if (cosAngle2_denom > epsilon):
		cosAngle2 =   (targetDistSqr - length1*length1 - length2*length2) / (cosAngle2_denom);
		  
		if( (cosAngle2 < -1.0) || (cosAngle2 > 1.0) ):
			foundValidSolution = false;
		  
		cosAngle2 = max(-1, min( 1, cosAngle2 ) );
		  
		angle2 = acos( cosAngle2 );
		  
		if( !solvePosAngle2 ):
			angle2 = -angle2;
		  
		sinAngle2 = sin( angle2 );
	else:
		var totalLenSqr: float = (length1 + length2) * (length1 + length2);
		if(targetDistSqr < (totalLenSqr-epsilon) || targetDistSqr > (totalLenSqr+epsilon) ):
			foundValidSolution = false
		
		angle2    = 0.0;
		cosAngle2 = 1.0;
		sinAngle2 = 0.0;
	
	var triAdjacent = length1 + length2*cosAngle2;
	var triOpposite = length2*sinAngle2;
	  
	var tanY = targetY*triAdjacent - targetX*triOpposite;
	var tanX = targetX*triAdjacent + targetY*triOpposite;
	
	angle1 = atan2( tanY, tanX );
	  
	return foundValidSolution;