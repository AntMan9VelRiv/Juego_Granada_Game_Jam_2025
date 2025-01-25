extends CharacterBody2D


const SPEED = 300.0
const FLOAT_AMPLITUDE = 10.0  # Amplitud del movimiento vertical
const FLOAT_SPEED = 3.0  # Velocidad de oscilación vertical
const INTERVALO_CAMBIO_DIRECCION = 2.0

const SEPARACION = 20.0  # Distancia mínima para separar al objeto tras colisión

# Nueva variable para los golpes necesarios para destruir la burbuja
var golpes_necesarios = 3
var golpes_recibidos = 0  # Contador de golpes recibidos

#Dirección inicial
var direction: Vector2 = Vector2(1, 0) 
var base_y: float = 0.0  # Posición base en Y
var timer: float = 0.0

var puede_cambiar_direccion: bool = true  # Bandera para controlar el cambio de dirección

@onready var animation_player: AnimationPlayer = $Sprite2D/AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D

@onready var area = $Area2D

func _ready() -> void:
	add_to_group("enemigo")  # Se agrega el enemigo a un grupo para facilitar la detección
	direction.x = 1 if randf() > 0.5 else -1
	base_y = position.y  
	animation_player.play("mover")
	actualizar_sprite()


func _process(delta: float) -> void:
	timer += delta
		
	# Movimiento horizontal
	velocity.x = direction.x * SPEED
	
	# Movimiento flotante vertical
	position.y = base_y + FLOAT_AMPLITUDE * sin(FLOAT_SPEED * timer)
	
	#Aplicar movimiento
	move_and_slide()
	
	#Comprobar si hay colisiones
	if get_slide_collision_count() > 0 and puede_cambiar_direccion:
		cambiar_direccion()
		
	# Manejar animación basada en movimiento
	if velocity.length() > 0:
		if not animation_player.is_playing() or animation_player.current_animation != "mover":
			animation_player.play("mover")
	else:
		animation_player.stop()

	
func cambiar_direccion() -> void:
	# Cambiar dirección horizontal
	direction.x *= -1
	puede_cambiar_direccion = false

	# Ajustar el sprite para reflejar la dirección
	actualizar_sprite()

	# Separar al objeto inmediatamente para evitar quedarse pegado
	position.x += direction.x * SEPARACION

	# Pausar temporalmente el movimiento para evitar rebotes
	velocity.x = 0

	# Habilitar cambio de dirección después de un intervalo
	await get_tree().create_timer(INTERVALO_CAMBIO_DIRECCION).timeout

	# Reanudar movimiento
	puede_cambiar_direccion = true
	velocity.x = direction.x * SPEED

	
func actualizar_sprite() -> void:
	sprite.scale.x = -1 if direction.x < 0 else 1
		


func recibir_golpe():
	golpes_recibidos += 1
	print("Golpes recibidos: ", golpes_recibidos)  # Depuración en consola

	if golpes_recibidos >= golpes_necesarios:
		queue_free()  # Destruir la burbuja si alcanza el número de golpes necesarios
		var controlador = get_tree().get_root().get_node("Controlador")
		if controlador:
			controlador.actualizar_burbujas_destruidas()

func _on_area_2d_body_entered(body: Node2D) -> void:
	
	if body.is_in_group("habilidad"):  # Detectar si el objeto colisionado es una habilidad
		golpes_recibidos += 1  # Incrementar el contador de golpes
		print("Golpes recibidos: ", golpes_recibidos)  # Depuración en consola

		if golpes_recibidos >= golpes_necesarios:
			# Destruir la burbuja si alcanza el número de golpes necesarios
			queue_free()
			var controlador = get_tree().get_root().get_node("Controlador")
			if controlador:
				controlador.actualizar_burbujas_destruidas()
