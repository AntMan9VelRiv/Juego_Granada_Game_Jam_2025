extends CharacterBody2D

const VELOCIDAD = 300.0
const VELOCIDAD_SALTO = -400.0

# Dirección inicial del disparo (por defecto hacia la derecha)
var direccion_disparo = Vector2.RIGHT

@export var habilidad: PackedScene # Obtener la habilidad como nodo hijo

# Distancia extra para evitar que la habilidad se choque con el personaje
var espacio_entre_habilidad_personaje = 40.0
var distancia_ejey_habilidad = 0  # Ajustar esta variable para mover la habilidad hacia abajo

# Se asume que el personaje tiene un Sprite o un CollisionShape2D
# Se usará el offset para lanzar la habilidad a una altura más baja
var altura_offset = 10.0  # Ajusta este valor para mover la habilidad hacia abajo más desde el personaje

func _physics_process(delta: float) -> void:
	# Aplicar gravedad
	if not is_on_floor():
		velocity.y += ProjectSettings.get_setting("physics/2d/default_gravity") * delta

	# Manejar salto
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = VELOCIDAD_SALTO

	# Manejar movimiento del personaje
	var direccion := Input.get_axis("ui_left", "ui_right")
	if direccion:
		velocity.x = direccion * VELOCIDAD
		if direccion > 0:
			direccion_disparo = Vector2.RIGHT  # Actualizar dirección del disparo
		elif direccion < 0:
			direccion_disparo = Vector2.LEFT  # Actualizar dirección del disparo
	else:
		velocity.x = move_toward(velocity.x, 0, VELOCIDAD)

	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("habilidad"):
		# Instanciamos la habilidad solo cuando se presiona la tecla
		var nuevaHabilidad = habilidad.instantiate()  # Instanciamos la habilidad
		nuevaHabilidad.position = self.position  # Posicionamos la habilidad en el personaje

		# Ajustamos la dirección y posición de la habilidad según la dirección del personaje
		if direccion_disparo == Vector2.RIGHT:
			nuevaHabilidad.position.x += espacio_entre_habilidad_personaje  # Desplazamos a la derecha
			nuevaHabilidad.scale.x = 1  # La habilidad va a la derecha
			nuevaHabilidad.set("velocity", Vector2(500, 0))  # Establecer la velocidad
		elif direccion_disparo == Vector2.LEFT:
			nuevaHabilidad.position.x -= espacio_entre_habilidad_personaje  # Desplazamos a la izquierda
			nuevaHabilidad.scale.x = -1  # La habilidad se voltea hacia la izquierda
			nuevaHabilidad.set("velocity", Vector2(-500, 0))  # Establecer la velocidad

		# Ajustamos la posición en Y para que la habilidad aparezca más baja
		# Ajustamos la altura con base en la posición Y del personaje y el offset
		nuevaHabilidad.position.y = self.position.y + altura_offset  # Ajuste de altura en Y

		# Agregamos la habilidad como hijo de la escena del jugador
		get_parent().add_child(nuevaHabilidad)
