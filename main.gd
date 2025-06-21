extends Node

@export var jugador_scene : PackedScene

#variables del juego
var score : int
var game_started : bool = false

#variables jugador
var old_data : Array
var jugador_data : Array
var jugador : Array

#variables de movimiento
var start_pos = Vector2(9, 9)
var up = Vector2(0, -1)
var down = Vector2(0, 1)
var left = Vector2(-1,0)
var right = Vector2(1,0)
var move_direction : Vector2
var can_move: bool

#variables grillas
var cells : int = 15
var cell_size : int = 50

#limites grilla
var limit_up = 2
var limit_down = 16
var limit_left = 2
var limit_right = 16

func _ready():
	new_game()
	
func new_game():
	score = 0
	$CanvasLayer.get_node("ProgresoLabel").text = "Progreso: " + str(score)
	move_direction = up
	can_move = true
	generate_jugador()
	
func generate_jugador():
	old_data.clear()
	jugador_data.clear()
	jugador.clear()
	
	
func add_segment(pos):
	jugador_data.append(pos)
	var JugadorSegment = jugador_scene.instantiate()
	JugadorSegment.position = (pos * cell_size) + Vector2(0, cell_size)
	add_child(JugadorSegment)
	jugador.append(JugadorSegment)
	
func _process(_delta):
	move_jugador()
	add_segment(start_pos + Vector2(0, 1))
	
func move_jugador():
	if can_move:
		
		if Input.is_action_just_pressed("move_down") and move_direction != up:
			move_direction = down
			can_move = false
			if not game_started:
				start_game()
		if Input.is_action_just_pressed("move_up") and move_direction != down:
			move_direction = up
			can_move = false
			if not game_started:
				start_game()
		if Input.is_action_just_pressed("move_left") and move_direction != right:
			move_direction = left
			can_move = false
			if not game_started:
				start_game()
		if Input.is_action_just_pressed("move_right") and move_direction != left:
			move_direction = right
			can_move = false
			if not game_started:
				start_game()
		$MoveTimer.start()
				
func start_game():
	game_started = true
	

func _on_move_timer_timeout() -> void:
	can_move = true
	old_data = [] + jugador_data
	
	if(jugador_data[0][0] < limit_left + 1 and move_direction[0] < 0):
		move_direction[0] = 0
		
	if(jugador_data[0][0] > limit_right - 1 and move_direction[0] > 0):
		move_direction[0] = 0
		
	if(jugador_data[0][1] < limit_up + 1 and move_direction[1] < 0):
		move_direction[1] = 0
		
	if(jugador_data[0][1] > limit_down - 1 and move_direction[1] > 0):
		move_direction[1] = 0
		
	jugador_data[0] += move_direction
	for i in range(len(jugador_data)):
		if i > 0:
			jugador_data[i] = old_data[i - 1]
		jugador[i].position = (jugador_data[i] * cell_size) + Vector2(0, cell_size)
