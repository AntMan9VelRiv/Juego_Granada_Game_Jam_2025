extends Node2D

@onready var video_player = $VideoStreamPlayer

@onready var credit_label = $ButtonCreditos/PanelCreditos/LabelCreditos
@onready var credit_button = $ButtonCreditos
@onready var credit_panel = $ButtonCreditos/PanelCreditos
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	credit_label.visible = false
	credit_panel.visible = false
	$Sprite2D.visible = false  # Ocultar la imagen al inicio
	video_player.play()  # Inicia el video automáticamente


func _on_video_stream_player_finished() -> void:
	$VideoStreamPlayer.stop()
	$Sprite2D.visible = true  # Mostrar la imagen estática
	print("El video ha terminado y se ha pausado en el último fotograma.")


func _on_button_repetir_pressed() -> void:
	Controlador.reiniciar_variables()
	Controlador.goto_scene("res://escenas/nivel.tscn")

func _on_button_salir_pressed() -> void:
	print("Botón presionado")  # Depuración
	get_tree().quit()

func cambiar_escena():
	var current_scene_path = get_tree().current_scene.get_scene_file_path()
	Controlador.goto_scene(current_scene_path)
	
func _on_button_creditos_pressed():
	credit_label.visible = not credit_label.visible
	credit_panel.visible = not credit_panel.visible
	pass # Replace with function body.
