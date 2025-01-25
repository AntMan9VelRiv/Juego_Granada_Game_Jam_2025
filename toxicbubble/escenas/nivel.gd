extends Node2D

@onready var label_vidas: Label = $Label  # Referencia al Label en pantalla
@onready var personaje: CharacterBody2D = $personaje  # Referencia al personaje principal
@export var rigidbody_to_change: RigidBody2D  # Export para asignarlo desde el editor

@onready var area_detector: Area2D = $Area2D  # Referencia al Area2D

func _ready():
	# Asignar referencias al controlador si existe
	if Controlador:
		Controlador.asignar_personaje(personaje)
		Controlador.asignar_label_vidas(label_vidas)

	# Conectar la señal del área
	area_detector.body_entered.connect(_on_area_2d_body_entered)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == personaje:  # Asegurarnos de que sea el personaje exacto
		if rigidbody_to_change:
			rigidbody_to_change.freeze = false  # Descongelar el objeto si estaba congelado
			rigidbody_to_change.gravity_scale = 1  # Activar la gravedad
			rigidbody_to_change.apply_impulse(Vector2.ZERO, Vector2(0, 50))  # Pequeño empujón hacia abajo


func _on_limite_area_2d_2_body_entered(body: Node2D) -> void:
	if body.name == "personaje":
		Controlador.jugadorCaido()
	pass
