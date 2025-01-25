extends Node2D

@onready var label_vidas: Label = $Label  # Referencia al Label en pantalla
@onready var personaje: CharacterBody2D = $personaje  # Referencia al personaje principal

func _ready():
	# Asignar referencias al controlador
	Controlador.asignar_personaje(personaje)
	Controlador.asignar_label_vidas(label_vidas)
