# En la escena de la habilidad
extends Node2D

var velocidad = Vector2()  # Inicializa la velocidad
var velocidad_base = 500  # La velocidad base con la que se mueve

func _ready():
	# Asignamos la dirección de la habilidad
	velocidad.x = velocidad_base  # A la derecha por defecto
	# O si es hacia la izquierda, usaremos un valor negativo
	if scale.x == -1:
		velocidad.x = -velocidad_base

func _process(delta):
	position += velocidad * delta  # Mover la habilidad según la velocidad
