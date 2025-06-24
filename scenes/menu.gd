extends Control



#Botón que inicia el juego
func _on_nueva_partida_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/historia.tscn")


#botón de ajustes 
func _on_ajustes_pressed() -> void:
	pass # Replace with function body.


#botón de salir
func _on_salir_pressed() -> void:
	get_tree().quit()
