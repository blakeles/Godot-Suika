extends RigidBody2D
class_name ball_class

var ball_type : int # Used to identify ball in collision
var primary : float # Used to determine which ball should emit ball_emerge
var in_play : bool # If ball has been dropped

signal ball_merge
signal ball_too_high

func _ready():
	randomize()
	contact_monitor = true
	max_contacts_reported = 4
	await get_tree().create_timer(1).timeout
	in_play = true
	
func _physics_process(_delta):
	# If the ball has been dropped and its highest point if above the limit, game over
	if in_play && find_peak() < 250: ball_too_high.emit()
	for contact in get_colliding_bodies():
		if contact is ball_class:
			if contact.get_ball_type() == ball_type:
				if primary > contact.primary: # Decide which ball will send the merge signal, stops duplicate merges
					ball_merge.emit(contact, self)

'''
find_peak
- Find the topmost Y coordinate of the ball
'''
func find_peak():
	var radius = $'CollisionShape2D'.shape.radius
	var local_top_y = -radius
	return global_position.y + local_top_y

'''
decide_primary
- Generates a random float
- Used when deciding which ball will send the merge signal
'''
func decide_primary():
	primary = randf()
	
'''
get_ball_type
- Returns the type of this ball
'''
func get_ball_type():
	return ball_type
