extends RigidBody2D

# Referencias a los cuerpos secundarios (los escalones)
@onready var escalon1: RigidBody2D = $Escalon1
@onready var escalon2: RigidBody2D = $Escalon2

# Áreas de detección de colisión
@onready var area_escalon1: Area2D = $Escalon1/Area2D
@onready var area_escalon2: Area2D = $Escalon2/Area2D

# Posiciones iniciales
var escalon1_pos_inicial
var escalon2_pos_inicial

# Altura máxima que se moverán los escalones
var ALTURA_SUBIDA = 50
var VELOCIDAD_MOVIMIENTO = 0.5  # Tiempo en segundos para moverse

func _ready() -> void:
	# Guardar las posiciones iniciales de los escalones
	escalon1_pos_inicial = escalon1.position
	escalon2_pos_inicial = escalon2.position

	# Aplicar la escala de la escena a los escalones
	escalon1.scale = self.scale
	escalon2.scale = self.scale

	# Conectar señales de colisión a las áreas
	area_escalon1.connect("body_entered", Callable(self, "_on_escalon_colision"))
	area_escalon2.connect("body_entered", Callable(self, "_on_escalon_colision"))

# Función para manejar la colisión
func _on_escalon_colision(body: Node) -> void:
	# Verificar si el cuerpo pertenece al grupo "personaje"
	if body.is_in_group("personaje"):
		print("El personaje tocó la escalera.")
		mover_escalones()

# Función para mover los escalones suavemente hacia arriba y luego devolverlos
func mover_escalones() -> void:
	# Crear tweens para escalones
	var tween1 = get_tree().create_tween()
	var tween2 = get_tree().create_tween()

	# Mover escalones hacia arriba de forma suave
	tween1.tween_property(escalon1, "position", escalon1_pos_inicial - Vector2(0, ALTURA_SUBIDA), VELOCIDAD_MOVIMIENTO)
	tween2.tween_property(escalon2, "position", escalon2_pos_inicial - Vector2(0, ALTURA_SUBIDA), VELOCIDAD_MOVIMIENTO)

	await get_tree().create_timer(1.0).timeout  # Esperar un segundo

	# Mover escalones de regreso a su posición original
	tween1 = get_tree().create_tween()
	tween2 = get_tree().create_tween()
	tween1.tween_property(escalon1, "position", escalon1_pos_inicial, VELOCIDAD_MOVIMIENTO)
	tween2.tween_property(escalon2, "position", escalon2_pos_inicial, VELOCIDAD_MOVIMIENTO)

	print("Escalones regresan a su posición.")
