extends Node2D

const BALL_SCENES = [ # Ball scenes used for background
	preload("res://scenes/ball_scenes/ball_1.tscn"),
	preload("res://scenes/ball_scenes/ball_2.tscn"),
	preload("res://scenes/ball_scenes/ball_3.tscn"),
	preload("res://scenes/ball_scenes/ball_4.tscn"),
	preload("res://scenes/ball_scenes/ball_5.tscn"),
	preload("res://scenes/ball_scenes/ball_6.tscn"),
	preload("res://scenes/ball_scenes/ball_7.tscn")
]

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	spawn_ball()
	set_highscore_label()
	
'''
spawn_ball
- Recursive function
- Spawns a random ball at a random X position above the viewport
'''
func spawn_ball():
	await get_tree().create_timer(randf_range(0.25,1)).timeout
	var x = randi_range(0,576)
	var ball = BALL_SCENES.pick_random().instantiate()
	add_child(ball)
	ball.global_position = Vector2(x,-100)
	ball.z_index = -1
	spawn_ball()
	# Wait for ball to fall for a bit, then queue for deletion - Should be off screen
	await get_tree().create_timer(3).timeout
	ball.queue_free()

'''
set_highscore_label
- Sets the highscore text to the highscore found in the save file
'''
func set_highscore_label():
	var hs = "0"
	if FileAccess.file_exists("user://suika.save"):
		var file = FileAccess.open("user://suika.save", FileAccess.READ)
		hs = file.get_as_text()
		file.close()
	$'GUI/CenterContainer2/Label'.text = "HIGHSCORE:\n" + hs

func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")
func _on_quit_pressed():
	get_tree().quit()
