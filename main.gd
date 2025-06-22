extends Node

@export var jugador_scene : PackedScene

# Estado del juego general
var game_started : bool = false
var score : int = 0

# Movimiento y estado del jugador
var move_direction = Vector2(0, 0)
var start_pos = Vector2(13.4, 17.5)
var up = Vector2(0, -1)
var right = Vector2(1,0)
var left = Vector2(-1,0)
var down = Vector2(0, 1)
var can_move: bool = true

# Estado de los segmentos
var jugador_data : Array = []
var old_data : Array = []
var jugador : Array = []

# Tamano de grillas y limites
var cells : int = 15
var cell_size : int = 32
var limit_up = start_pos[1] - 7
var limit_down = start_pos[1] + 7
var limit_left = start_pos[0] - 7
var limit_right = start_pos[0] + 7
var grid_draw: Array

# Cuando el juego esta listo
func _ready():
	$CanvasLayer.get_node("ProgresoLabel").text = "Progreso: " + str(score)
	move_direction = Vector2(0, 0)
	add_segment(start_pos)
	can_move = true

# Cuando el jugador se mueve dibuja la traza por donde se mueve
func add_segment(pos):
	jugador_data.append(pos)
	var jugador_trace = jugador_scene.instantiate()
	jugador_trace.position = (pos * cell_size) + Vector2(0, cell_size)
	jugador.append(jugador_trace)
	add_child(jugador_trace)
	
# Cada vez que se mueva el jugador este se desplaza y dibuja la traza
func _process(_delta):
	set_queen_state()
	move_jugador()
	
# Mueve el jugador en base a las teclas presionadas
func move_jugador():
	move_direction = Vector2(0, 0)
	# Chequear las teclas presionadas por el jugador para moverse
	if can_move:
		if Input.is_action_pressed("move_down") and move_direction != up:
			move_direction = down
			can_move = false
		if Input.is_action_pressed("move_up") and move_direction != down:
			move_direction = up
			can_move = false
		if Input.is_action_pressed("move_left") and move_direction != right:
			move_direction = left
			can_move = false
		if Input.is_action_pressed("move_right") and move_direction != left:
			move_direction = right
			can_move = false
		# Agrega el movimiento a la traza
		old_data = [] + jugador_data
		# Limita al jugador dentro de los limites de la grilla
		if (len(jugador_data) > 0):
			if(jugador_data[0][0] < limit_left + 1 and move_direction[0] < 0):
				move_direction[0] = 0
			if(jugador_data[0][0] > limit_right - 1 and move_direction[0] > 0):
				move_direction[0] = 0
			if(jugador_data[0][1] < limit_up + 1 and move_direction[1] < 0):
				move_direction[1] = 0
			if(jugador_data[0][1] > limit_down - 1 and move_direction[1] > 0):
				move_direction[1] = 0
			jugador_data[0] += move_direction
			# Si se ha movido antes entonces agregar a la traza
			for i in range(len(jugador_data)):
				if i > 0:
					jugador_data[i] = old_data[i - 1]
				jugador[i].position = (jugador_data[i] * cell_size) + Vector2(0, cell_size)
		# Dibuja el segmento si es que se mueve
		if (move_direction != Vector2(0, 0)):
			add_segment(jugador_data[0])
		# Esperar un tiempo antes de seguir moviendo al jugador
		$MoveTimer.start()

func set_queen_state():
	var points = len(jugador_data)
	print("Largo de la traza del jugador")
	print(points)
	if (points > 10 and points < 20):
		$Reina.texture = preload("res://img/r-indiferente.png")
		return
	if (points > 20):
		$Reina.texture = preload("res://img/r-decepcionada.png")
		return
	return

# Empieza el estado general del juego
func start_game():
	game_started = true

# Cuando pase un tiempo permitir al jugador moverse denuevo
func _on_move_timer_timeout() -> void:
	can_move = true
