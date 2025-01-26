extends Node2D

@onready var label_vidas: Label = $LabelVidas # Referencia al Label en pantalla
@onready var personaje: CharacterBody2D = $personaje  # Referencia al personaje principal
@export var rigidbody_to_change: RigidBody2D  # Export para asignarlo desde el editor

@onready var area_detector: Area2D = $Area2D  # Referencia al Area2D
@onready var label_burbujas: Label = $LabelBurbujas # Referencia al label de burbujas en pantalla

func _ready():
	# Asignar referencias al controlador si existe
	if Controlador:
		Controlador.asignar_personaje(personaje)
		Controlador.asignar_label_vidas(label_vidas)
		Controlador.asignar_label_burbujas(label_burbujas)
		Controlador.total_burbujas = 1	

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
	if body.name == "personaje":
		Controlador.jugadorCaido()
	pass
