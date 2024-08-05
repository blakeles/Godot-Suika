extends Node2D

const BALLS = { # All ball scenes
	"Ball_1": preload("res://scenes/ball_scenes/ball_1.tscn"),
	"Ball_2": preload("res://scenes/ball_scenes/ball_2.tscn"),
	"Ball_3": preload("res://scenes/ball_scenes/ball_3.tscn"),
	"Ball_4": preload("res://scenes/ball_scenes/ball_4.tscn"),
	"Ball_5": preload("res://scenes/ball_scenes/ball_5.tscn"),
	"Ball_6": preload("res://scenes/ball_scenes/ball_6.tscn"),
	"Ball_7": preload("res://scenes/ball_scenes/ball_7.tscn"),
	"Ball_8": preload("res://scenes/ball_scenes/ball_8.tscn")
}

var score : int = 0

'''
spawn_ball
- Spawns a ball of the given type at the given position
'''
func spawn_ball(pos : Vector2, ball_type : String):
	var dropped_ball = BALLS[ball_type].instantiate()
	add_child(dropped_ball)
	dropped_ball.position = pos
	dropped_ball.ball_merge.connect(_on_ball_merge)
	dropped_ball.ball_too_high.connect(_on_ball_too_high)
	
'''
update_score
- Score is simply the the amount of balls merged multiplied by their ball IDs
'''
func update_score(ball_type : int):
	var oldScore = score
	score += ball_type * 2
	for i in range(oldScore, score+1):
		await get_tree().create_timer(0.05).timeout
		$'CenterContainer/Score'.text = str(i)
	
'''
save_game
- Reads the highscore in the saved file and compares it to the score this game
- Saves the score if it is higher than the highscore OR if there is no highscore
'''	
func save_game():
	if FileAccess.file_exists("user://suika.save"):
		var file = FileAccess.open("user://suika.save", FileAccess.READ)
		var highscore = int(file.get_as_text())
		file.close()
		if highscore > score: return
	var file = FileAccess.open("user://suika.save", FileAccess.WRITE)
	file.store_string(str(score))
	
'''
game_over
- Saves the game and exits to the menu, nothing fancy
'''
func game_over():
	save_game()
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

'''
_on_ball_merge
- Deletes both balls from the game
- Replaces them with a single ball of the next tier
- If ball is of highest tier, do nothing
'''
func _on_ball_merge(b1 : Object, b2 : Object):
	var type = b1.get_ball_type()
	if type == BALLS.size(): return
	var new_ball_type : String = "Ball_"+str(type + 1)
	var new_ball_pos : Vector2 = b1.global_position
	b2.queue_free()
	b1.queue_free()
	spawn_ball(new_ball_pos, new_ball_type)
	update_score(type)
	
func _on_ball_too_high():
	game_over()
func _on_ball_spawner_dropped_ball(pos : Vector2, ball_type : String):
	spawn_ball(pos, ball_type)
func _on_ball_spawner_game_over():
	game_over()
func _on_back_button_pressed():
	game_over()
