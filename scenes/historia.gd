extends Node2D

# Referencias a nodos importantes
@onready var bodegon = $"Bodegon-d1"
@onready var reina = $"Reina-historia"
@onready var texto_label = $"Reina-historia/Control2/TextoReina"

# Variables para controlar el diálogo
var dialogos : Array = []
var indice_dialogo : int = 0

func _ready():
	# Ocultar la parte de la reina al inicio
	reina.visible = false
	# Cargar los textos desde el JSON
	cargar_dialogos()

# Función llamada al apretar el primer botón (de Bodegon-d1)
func _on_button_1_pressed() -> void:
	# Oculta el bodegón inicial
	bodegon.visible = false
	# Muestra la reina y su interfaz
	reina.visible = true
	# Muestra el primer diálogo
	mostrar_dialogo()

# Carga los textos del JSON
func cargar_dialogos():
	var file = FileAccess.open("res://dialogos/reina_historia.json", FileAccess.READ)
	if file:
		var contenido = file.get_as_text()
		var data = JSON.parse_string(contenido)
		if data and data.has("dialogos"):
			dialogos = data["dialogos"]

# Muestra el texto actual según el índice
func mostrar_dialogo():
	if indice_dialogo < dialogos.size():
		texto_label.text = dialogos[indice_dialogo]

# Función para avanzar el texto (botón dentro de Reina-historia)
func _on_button_2_pressed() -> void:
	indice_dialogo += 1
	if indice_dialogo < dialogos.size():
		mostrar_dialogo()
	else:
		#pasa a la escena del puzzle
		get_tree().change_scene_to_file("res://main.tscn")
		
