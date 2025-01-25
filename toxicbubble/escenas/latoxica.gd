extends CharacterBody2D


const SPEED = 300.0
const INTERVALO_CAMBIO_DIRECCION = 2.0

#Dirección inicial
var direction: Vector2 = Vector2(1, 0) 
var timer: float = 0.0

func _ready() -> void:
	#Inicialización de dirección aleatoria
	direction.x = 1 if randf() > 0.5 else -1


func _process(delta: float) -> void:
	
	#actualizar temporizador
	timer += delta
	if timer >= INTERVALO_CAMBIO_DIRECCION:
		timer = 0
		cambiar_direccion()
		
	# Movimiento horizontal
	velocity.x = direction.x * SPEED
	
	#Aplicar movimiento
	move_and_slide()
	
	#Comprobar si hay colisiones
	if get_slide_collision_count() > 0:
		cambiar_direccion()

	
func cambiar_direccion() -> void:
	direction.x *= -1
