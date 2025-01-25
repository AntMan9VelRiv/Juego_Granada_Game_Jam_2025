extends Node2D  # Manteniendo Node2D

var velocidad = Vector2()  # Inicializa la velocidad
var velocidad_base = 500  # La velocidad base con la que se mueve

var animacion_actual = null

# Referencia al Area2D
@onready var area = $Area2D  # Asegúrate de que el Area2D sea hijo de este nodo

func _ready():
	# Conectar la señal body_entered de manera correcta
	area.body_entered.connect(_on_Habilidad_body_entered)
	
	# Asignamos la dirección de la habilidad
	velocidad.x = velocidad_base  # A la derecha por defecto
	cambiar_animacion("habilidad_derecha")
	
	# O si es hacia la izquierda, usamos un valor negativo
	if scale.x == -1:
		velocidad.x = -velocidad_base

func _process(delta):
	position += velocidad * delta  # Mover la habilidad según la velocidad

# Detectar colisiones con cuerpos
func _on_Habilidad_body_entered(body: Node) -> void:
	if body.is_in_group("enemigo"):  # Si golpea un enemigo (burbuja)
		if body.has_method("recibir_golpe"):  # Verifica que el enemigo tenga el método "recibir_golpe"
			body.recibir_golpe()  # Llama al método de la burbuja para manejar el golpe
	queue_free()  # La habilidad siempre se destruye después de colisionar
	
func cambiar_animacion(nueva_animacion):
	if nueva_animacion != animacion_actual:
		$Sprite2D/AnimationPlayer.play(nueva_animacion)
		animacion_actual = nueva_animacion
