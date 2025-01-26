extends Node2D

@onready var music_player = $AudioStreamPlayer
@onready var label_vidas: Label = $CanvasLayer/LabelVidas  # Referencia al Label en pantalla
@onready var personaje: CharacterBody2D = $personaje  # Referencia al personaje principal
@export var rigidbody_to_change: RigidBody2D  # Export para asignarlo desde el editor

@onready var area_detector: Area2D = $Area2D  # Referencia al Area2D

func _ready():
	music_player.play(1.5)
	
	# Asignar referencias al controlador si existe
	if Controlador:
		Controlador.asignar_personaje(personaje)
		Controlador.asignar_label_vidas(label_vidas)
		Controlador.total_burbujas = 10
		Controlador.vidas_container = $CanvasLayer/VidasContainer

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == personaje:
		print("Personaje ha entrado al área")
		
		if is_instance_valid(rigidbody_to_change):
			print("RigidBody detectado correctamente")
			rigidbody_to_change.freeze = false
			rigidbody_to_change.gravity_scale = 1.0
			rigidbody_to_change.apply_impulse(Vector2.ZERO, Vector2(0, 500))
		else:
			print("El RigidBody2D no está asignado correctamente")

func _on_limite_area_2d_2_body_entered(body: Node2D) -> void:
	if body == personaje:
		print("¡El personaje cayó!")
		Controlador.jugadorCaido()
