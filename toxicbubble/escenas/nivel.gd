extends Node2D

@onready var label_vidas: Label = $Label  # Referencia al Label en pantalla
@onready var personaje: CharacterBody2D = $personaje  # Referencia al personaje principal
@export var rigidbody_to_change: RigidBody2D

func _ready():
	# Asignar referencias al controlador
	Controlador.asignar_personaje(personaje)
	Controlador.asignar_label_vidas(label_vidas)



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"): 
		
		rigidbody_to_change.gravity_scale = 1
