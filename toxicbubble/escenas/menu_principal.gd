extends Node2D

@onready var music_player = $AudioStreamPlayer

@onready var info_label = $ButtonInformacion/Panel/SpriteInformacion
@onready var info_button = $ButtonInformacion
@onready var info_panel = $ButtonInformacion/Panel
@onready var info_lore = $ButtonInformacion/Panel/LabelLore

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	info_label.visible = false
	info_panel.visible = false
	info_lore.visible = false
	music_player.play()
	music_player.seek(5.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_jugar_pressed() -> void:
	Controlador.reiniciar_variables()
	get_tree().change_scene_to_file("res://escenas/nivel.tscn")
	


func _on_button_salir_pressed() -> void:
	print("Botón presionado")  # Depuración
	get_tree().quit()


func _on_button_informacion_pressed() -> void:
	info_label.visible = not info_label.visible
	info_panel.visible = not info_panel.visible
	info_lore.visible = not info_lore.visible
	pass # Replace with function body.
