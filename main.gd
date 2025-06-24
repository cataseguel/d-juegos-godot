extends Node

@export var reference_scene : PackedScene
@export var jugador_scene : PackedScene

# Creación del modelo de la grilla a recrear. Los 0 representan los espacios vacíos y los 1 los lleneados con gris
var levels = [
  [],
  [
	# Nivel 1
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[0,0,0,1,1,1,0,0,0,0,0,0,0,0,0],
	[0,0,1,1,0,1,1,0,0,0,0,0,0,0,0],
	[0,1,1,0,0,0,1,1,0,0,0,0,0,0,0],
	[0,1,0,0,0,0,0,1,0,0,0,0,0,0,0],
	[0,1,0,0,0,0,0,1,0,0,0,0,0,0,0],
	[0,1,0,0,0,0,0,1,0,0,0,0,0,0,0],
	[0,1,0,0,0,0,0,-1,0,0,0,0,0,0,0],
	[0,1,0,0,0,0,0,1,0,0,0,0,0,0,0],
	[0,1,0,0,0,0,0,1,0,0,0,0,0,0,0],
	[0,1,1,1,1,1,1,1,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
  ],
  [
	# Nivel 2
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,1,1,1,1,1,1,0,0],
	[0,0,0,0,0,0,0,1,0,0,0,0,1,0,0],
	[0,0,0,0,0,1,1,1,0,0,0,0,1,0,0],
	[0,0,0,0,1,1,0,0,0,0,0,0,1,0,0],
	[0,0,0,0,1,0,0,0,0,0,0,0,1,0,0],
	[0,0,0,1,1,0,0,0,0,0,0,0,1,0,0],
	[0,0,0,1,0,0,0,0,0,1,1,1,1,0,0],
	[0,0,0,1,1,1,1,1,1,1,0,1,1,0,0],
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
  ],
  [
	# Nivel 3
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,1,1,1,1,0,0,0,0,0,0],
	[0,0,0,0,0,1,0,0,1,1,0,0,0,0,0],
	[0,0,0,0,1,1,0,0,0,1,0,0,0,0,0],
	[0,0,0,0,1,0,0,0,0,1,0,0,0,0,0],
	[0,0,0,0,1,0,0,0,0,1,0,0,0,0,0],
	[0,0,0,0,1,0,0,0,0,1,0,0,0,0,0],
	[0,0,0,0,1,0,0,0,0,1,0,0,0,0,0],
	[0,0,0,0,1,0,0,0,0,1,1,1,0,0,0],
	[0,0,0,0,1,0,0,0,0,0,0,1,0,0,0],
	[0,0,0,0,1,0,0,0,0,0,1,1,0,0,0],
	[0,0,0,0,1,1,1,1,1,1,1,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
  ],
]

# Estado del juego general
var game_started : bool = false
var level_index : int = 1
var inside : int = 0
var score : int = 0
var level : Array = []
var time = 100.0
var juego_terminado : bool = false

# Movimiento y estado del jugador
var move_direction = Vector2(0, 0)
var start_pos = Vector2(7, 7)
var offset = Vector2(205, 336)
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
var cell_size_small : int = 16
var cell_size : int = 32
var cells : int = 15
var limit_up = start_pos[1] - 7
var limit_down = start_pos[1] + 7
var limit_left = start_pos[0] - 7
var limit_right = start_pos[0] + 7
var grid_draw: Array
var offset_small = Vector2(1039, 116)

# Cuando el juego esta listo se configuran los estados iniciales
func _ready():
	#Pantalla del resultado del puzzle invisible al inicio
	$CanvasLayer2/PantallaResultado.visible = false
	
	$CanvasLayer.get_node("ProgresoLabel").text = "Progreso: "  + str(score)
	move_direction = Vector2(0, 0)
	level = levels[level_index]
	set_starting_point()
	add_segment(start_pos)
	draw_reference()
	can_move = true

# Cada vez que se mueva el jugador este se desplaza y dibuja la traza
func _process(_delta):
	set_queen_state()
	change_controls()
	move_jugador()
	set_progress()

# Funcion para cambiar los controles dependiendo de la etapa
func change_controls():
	#if level_index == 1:
	#	up = Vector2(0, -1)
	#	right = Vector2(-1,0)
	#	left = Vector2(1,0)
	#	down = Vector2(0, 1)
	return

# Chequea si se hizo click en alguna parte de la pantalla
func _input(event):
	if juego_terminado:
		return  # no aceptar más clicks ni teclas si ya se terminó
	if event is InputEventMouseButton:
		restart_level(event)
		
# Cuando el jugador se mueve dibuja la traza por donde se mueve
func add_segment(pos):
	jugador_data.append(pos)

# Dibuja el trazo del jugador cuando se mueve
func draw_segment(pos):
	var jugador_trace = jugador_scene.instantiate()
	jugador_trace.position = (pos * cell_size) + Vector2(0, cell_size) + offset
	jugador.append(jugador_trace)
	add_child(jugador_trace)

# Encuentra el punto de comienzo del nivel
func draw_reference():
	for i in range(cells):
		for j in range(cells):
			var valor = level[i][j]
			if valor == 1 or valor == -1:
				var ref = reference_scene.instantiate()
				ref.position = Vector2(j, i) * cell_size_small + offset_small

				# Si es -1, cambia el color del Panel
				if valor == -1:
					ref.modulate = Color.ORANGE  # Cambia a otro si prefieres

				add_child(ref)

# Dibuja el trazo de referencia a seguir
func set_starting_point():
	for i in range(cells):
		for j in range(cells):
			if (level[i][j] == -1):
				var pos = Vector2(j, i)
				start_pos = pos
				return

# Mueve el jugador en base a las teclas presionadas
func move_jugador():
	if juego_terminado: #Que no se mueva cuando termina el juego
		return
	move_direction = Vector2(0, 0)
	# Chequear las teclas presionadas por el jugador para moverse
	if can_move:
		if Input.is_action_pressed("move_down"):
			move_direction = down
			can_move = false
			if (game_started == false):
				$ClockTimer.start()
				game_started = true
		if Input.is_action_pressed("move_up"):
			move_direction = up
			can_move = false
			if (game_started == false):
				$ClockTimer.start()
				game_started = true
		if Input.is_action_pressed("move_left"):
			move_direction = left
			can_move = false
			if (game_started == false):
				$ClockTimer.start()
				game_started = true
		if Input.is_action_pressed("move_right"):
			move_direction = right
			can_move = false
			if (game_started == false):
				$ClockTimer.start()
				game_started = true
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
		# Dibuja el segmento si es que se mueve y valida si el paso es correcto
		if (move_direction != Vector2(0, 0)):
			add_segment(jugador_data[0])
			validate_step(jugador_data[0])
		# Dibuja el segmento del trazo
		draw_segment(jugador_data[0])
		#Chequear si se terminó el puzzle
		check_if_finished()
		# Esperar un tiempo antes de seguir moviendo al jugador
		$MoveTimer.start()

# Cambia el estado de la reina dependiendo de cuantos puntos hay dentro
# o fuera del trazo que hay que recrear
func set_queen_state():
	var points = len(jugador_data)
	var errores = points - inside
	if (errores <= 2):
		$Reina.texture = preload("res://img/r-indiferente.png")
		return
	if (errores <= 6):
		$Reina.texture = preload("res://img/r-sorprendida.png")
		return
	if (errores <= 10):
		$Reina.texture = preload("res://img/r-molesta.png")
		return
	$Reina.texture = preload("res://img/r-decepcionada.png")
	return

# Reinicia el nivel al hacer click en el tarrito de borrar
func restart_level(event):
	if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var mouse_pos = event.position
		var borrar_pos = $Borrar.global_position
		var borrar_size = $Borrar.texture.get_size() * $Borrar.scale

		var rect = Rect2(borrar_pos - borrar_size * 0.5, borrar_size)
		
		if rect.has_point(mouse_pos):
			get_tree().reload_current_scene()


# Cuando pase un tiempo permitir al jugador moverse denuevo
func _on_move_timer_timeout() -> void:
	can_move = true

# Valida el paso actual con el correcto
func validate_step(nuevo_paso):
	var x = int(nuevo_paso.x)
	var y = int(nuevo_paso.y)
	var correcto = level[y][x];
	if (correcto == 1):
		inside += 1

# Modifica la barra en base al progreso del jugador
func set_progress():
	var total_correctos := 0
	var total_errores := 0
	var total_objetivo := 0

	# Calcular total de casillas correctas en el nivel actual
	for y in range(level.size()):
		for x in range(level[y].size()):
			if level[y][x] == 1:
				total_objetivo += 1

	# Revisar el recorrido del jugador
	for paso in jugador_data:
		var x := int(paso.x)
		var y := int(paso.y)

		if y >= 0 and y < level.size() and x >= 0 and x < level[y].size():
			if level[y][x] == 1:
				total_correctos += 1
			else:
				total_errores += 1

	# Cálculo ajustado al nivel actual + errores
	var total := total_objetivo + total_errores

	if total > 0:
		var progreso := float(total_correctos) / float(total)
		$CanvasLayer.get_node("Progreso").scale.x = progreso
	else:
		$CanvasLayer.get_node("Progreso").scale.x = 0
		
# Para chequear que se terminó el nivel
func check_if_finished():
	if jugador_data.size() < 2:
		return

# Compara la posición actual del jugador con el punto de inicio
	if jugador_data[-1] == start_pos:
		show_result_screen()

func _on_clock_timer_timeout() -> void:
	$ClockTimer.start()
	$Tiempo.value = time
	time -= 1
	
# Mostrar una pantalla de resultado del puzzle
func show_result_screen():
	juego_terminado = true
	$ClockTimer.stop() #que se detenga el tiempo cuando se termine el nivel
	var total_correctos := 0
	var total_errores := 0
	var total_objetivo := 0

	# Calcular total de casillas correctas en el nivel actual
	for y in range(level.size()):
		for x in range(level[y].size()):
			if level[y][x] == 1:
				total_objetivo += 1

	# Revisar el recorrido del jugador
	for paso in jugador_data:
		var x := int(paso.x)
		var y := int(paso.y)

		if y >= 0 and y < level.size() and x >= 0 and x < level[y].size():
			if level[y][x] == 1:
				total_correctos += 1
			else:
				total_errores += 1

	# Calcular progreso
	var total := total_objetivo + total_errores
	var progreso := 0.0

	if total > 0:
		progreso = float(total_correctos) / float(total)


	# Mostrar pantalla resultado
	var resultado = $CanvasLayer2/PantallaResultado
	resultado.visible = true
	resultado.modulate.a = 0.0

	# Para fade in de la pantalla resultado
	var tween = create_tween()
	tween.tween_property(resultado, "modulate:a", 1.0, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	# Mostrar porcentaje numérico
	var porcentaje := int(progreso * 100)
	$CanvasLayer2/PantallaResultado/VBoxContainer/PorcentajeLabel.text = str(porcentaje) + "% completado"

	# Mostrar tiempo final
	$CanvasLayer2/PantallaResultado/VBoxContainer/TiempoLabel.text = "Tiempo: " + str(int(100.0 - time)) + " segundos"

	# Mostrar comentario según porcentaje
	var comentario := ""
	if porcentaje <= 30:
		comentario = "Necesitas más práctica."
	elif porcentaje <= 60:
		comentario = "¡Vas por buen camino! Inténtalo otra vez."
	else:
		comentario = "¡Excelente trabajo!"

	$CanvasLayer2/PantallaResultado/VBoxContainer/ComentarioLabel.text = comentario

	
	
