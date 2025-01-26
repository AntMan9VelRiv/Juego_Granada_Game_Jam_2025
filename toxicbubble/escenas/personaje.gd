extends CharacterBody2D

const VELOCIDAD = 300.0
const VELOCIDAD_SALTO = -500.0

# Dirección inicial del disparo (por defecto hacia la derecha)
var direccion_disparo = Vector2.RIGHT

@export var habilidad: PackedScene # Obtener la habilidad como nodo hijo

# Distancia extra para evitar que la habilidad se choque con el personaje
var espacio_entre_habilidad_personaje = 48.0
var distancia_ejey_habilidad = 0  # Ajustar esta variable para mover la habilidad hacia abajo

# Se usará el offset para lanzar la habilidad a una altura más baja
var altura_offset = 10.0  # Ajusta este valor para mover la habilidad hacia abajo más desde el personaje

# Representa la animacion actual
var animacion_actual = null

func _ready() -> void:
	$Sprite2D/AnimationPlayer.play("quieto")
	animacion_actual = "quieto"
	Controlador.asignar_personaje(self)  # Asegurar que el controlador reconoce al personaje
	add_to_group("personaje")  # Asegurar que el personaje está en el grupo correcto

func _physics_process(delta: float) -> void:
	# Aplicar gravedad
	if not is_on_floor():
		velocity.y += ProjectSettings.get_setting("physics/2d/default_gravity") * delta
		
	var direccion := Input.get_axis("ui_left", "ui_right")

	# Manejar salto
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = VELOCIDAD_SALTO
		if direccion > 0:
			cambiar_animacion("saltar_derecha")
		elif direccion < 0:
			cambiar_animacion("saltar_izquierda")
		else:
			# Si está quieto y salta, elige la animación según la última dirección de disparo
			if direccion_disparo == Vector2.RIGHT:
				cambiar_animacion("saltar_derecha")
			else:
				cambiar_animacion("saltar_izquierda")

	# Manejar movimiento del personaje
	if direccion:
		velocity.x = direccion * VELOCIDAD
		if direccion > 0:
			cambiar_animacion("andar_derecha")
			direccion_disparo = Vector2.RIGHT  
		elif direccion < 0:
			cambiar_animacion("andar_izquierda")
			direccion_disparo = Vector2.LEFT  
	else:
		velocity.x = move_toward(velocity.x, 0, VELOCIDAD)
		
		# Si el personaje está en el suelo, cambiar animación a quieto
		if is_on_floor():
			cambiar_animacion("quieto")

	# Detectar si está en el aire y cambiar animación según dirección
	if not is_on_floor():
		if direccion_disparo == Vector2.RIGHT:
			cambiar_animacion("saltar_derecha")
		else:
			cambiar_animacion("saltar_izquierda")

	move_and_slide()


	# Comprobar colisión después de moverse
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if collision.get_collider().is_in_group("enemigo"):
			Controlador.reposicionar_personaje()
			Controlador.restar_vida()

func _on_hurt():
	Controlador.restar_vida()

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
		nuevaHabilidad.position.y = self.position.y + altura_offset  # Ajuste de altura en Y

		# Agregamos la habilidad como hijo de la escena del jugador
		get_parent().add_child(nuevaHabilidad)

		# Reproducir el sonido de la habilidad
		$AudioHabilidad.play()
		
func cambiar_animacion(nueva_animacion):
	if nueva_animacion != animacion_actual:
		$Sprite2D/AnimationPlayer.play(nueva_animacion)
		animacion_actual = nueva_animacion
		
	
func reiniciar_estado():
	# Reiniciar el estado del personaje al ser reposicionado
	velocity = Vector2.ZERO
	cambiar_animacion("quieto")
