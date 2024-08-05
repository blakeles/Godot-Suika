extends Node2D

const BALL_TYPES = { # Types of ball that can be spawned
	"Ball_1": {"scale": Vector2(0.1,0.1), "colour": Color(255,0,0)},
	"Ball_2": {"scale": Vector2(0.15,0.15), "colour": Color(0,255,0)},
	"Ball_3": {"scale": Vector2(0.2,0.2), "colour": Color(0,0,255)}
}

signal dropped_ball
signal game_over

@export var min_y : int # The y position that balls are dropped from
@export var min_x : int # The furthest left a ball can be dropped
@export var max_x : int # The furthest right a ball can be dropped

var current_ball : String # The type that a ball is
var dragging : bool = false # If player is dragging the ball
 
func _ready():
	randomize()
	choose_ball()

func _process(_delta):
	if $'Sprite2D'.visible:
		var pos = ensure_position(get_viewport().get_mouse_position())
		if dragging: global_position = pos
		
		if Input.is_action_just_pressed("click"): # Player begins to drag
			dragging = true
		elif Input.is_action_just_released("click"): # Player releases drag
			dragging = false
			if pos: 
				drop(pos)
		
'''
drop
- Tells game to drop ball
'''
func drop(dropping_position : Vector2):
	dropped_ball.emit(dropping_position, current_ball)
	$'Sprite2D'.visible = false
	await get_tree().create_timer(0.64).timeout
	choose_ball()
		
'''
choose_ball
- Selects a random ball type
'''
func choose_ball():
	current_ball = BALL_TYPES.keys().pick_random()
	$'Sprite2D'.scale = BALL_TYPES[current_ball]["scale"]
	$'Sprite2D'.self_modulate = BALL_TYPES[current_ball]["colour"]
	$'Sprite2D'.visible = true

'''
ensure_position
- Clamps the given position to the set bounds
'''
func ensure_position(current_position : Vector2):
	if current_position.x < min_x: current_position.x = min_x
	if current_position.x > max_x: current_position.x = max_x
	current_position.y = min_y
	
	return current_position
