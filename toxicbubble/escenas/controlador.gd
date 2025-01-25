extends Node

var vidas_iniciales = 3  # Número inicial de vidas
var vidas_actuales = vidas_iniciales  # Contador actual de vidas

var ruta_etiqueta_nivel = null  # Referencia al Label en pantalla
var current_scene = null  # Referencia a la escena actual

@onready var personaje = null  # Referencia al personaje principal

func _ready():
	# Inicializar la escena actual
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)

func asignar_personaje(nodo_personaje: Node):
	# Asigna el personaje principal al controlador
	personaje = nodo_personaje

func asignar_label_vidas(label_nodo: Label):
	# Asigna el Label para mostrar las vidas
	ruta_etiqueta_nivel = label_nodo
	actualizar_vidas()

func restar_vida():
	# Resta una vida y actualiza la pantalla
	vidas_actuales -= 1
	actualizar_vidas()

	if vidas_actuales <= 0:
		print("Vidas agotadas. Reiniciando nivel...")
		goto_scene("res://escenas/nivel.tscn")  # Cambia esta ruta según tu nivel
	else:
		reposicionar_personaje()

func actualizar_vidas():
	# Actualiza el texto del contador en pantalla
	if ruta_etiqueta_nivel:
		ruta_etiqueta_nivel.text = "VIDAS: " + str(vidas_actuales)

func reposicionar_personaje():
	if personaje:
		personaje.position = Vector2(200, 300)  # Ajusta la posición de reaparición
		personaje.velocity = Vector2.ZERO
		personaje.reiniciar_estado()

func goto_scene(path: String):
	# Cambia de escena con seguridad
	call_deferred("_deferred_goto_scene", path)

func _deferred_goto_scene(path: String):
	# Libera la escena actual y carga la nueva
	current_scene.free()
	var nueva_escena = ResourceLoader.load(path).instantiate()
	get_tree().root.add_child(nueva_escena)
	get_tree().current_scene = nueva_escena
	
