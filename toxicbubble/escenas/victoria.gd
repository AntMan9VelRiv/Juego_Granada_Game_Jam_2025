extends Node2D

@onready var video_player = $VideoStreamPlayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite2D.visible = false  # Ocultar la imagen al inicio
	video_player.play()  # Inicia el video automáticamente


func _on_video_stream_player_finished() -> void:
	$VideoStreamPlayer.stop()
	$Sprite2D.visible = true  # Mostrar la imagen estática
	print("El video ha terminado y se ha pausado en el último fotograma.")
	


func _on_button_salir_pressed() -> void:
	print("Botón presionado")  # Depuración
	get_tree().quit()


func _on_button_repetir_pressed() -> void:
	Controlador.reiniciar_variables()
	get_tree().change_scene_to_file("res://escenas/nivel.tscn")
	
func cambiar_escena():
	var current_scene_path = get_tree().current_scene.get_scene_file_path()
	get_tree().change_scene_to_file(current_scene_path)
