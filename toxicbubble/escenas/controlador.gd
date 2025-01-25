extends Node

var vidas_iniciales = 3  # Número inicial de vidas
var vidas_actuales = vidas_iniciales  # Contador actual de vidas

var ruta_etiqueta_nivel: Label = null  # Referencia al Label en pantalla
var current_scene: Node = null  # Referencia a la escena actual

@onready var personaje: Node = null  # Referencia al personaje principal

func _ready():
	# Inicializar la escena actual
	current_scene = get_tree().current_scene

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
		if personaje.has_method("reiniciar_estado"):
			personaje.reiniciar_estado()

func goto_scene(path: String):
	# Cambia de escena con seguridad
	call_deferred("_deferred_goto_scene", path)

func _deferred_goto_scene(path: String):
	print("Intentando cambiar a la escena:", path)
	
	# Libera la escena actual de manera segura.
	if is_instance_valid(current_scene):
		print("Liberando la escena actual:", current_scene.name)
		current_scene.queue_free()

	# Carga la nueva escena.
	var nueva_escena_resource = ResourceLoader.load(path)
	if nueva_escena_resource:
		var nueva_escena = nueva_escena_resource.instantiate()
		get_tree().root.add_child(nueva_escena)
		get_tree().current_scene = nueva_escena
		current_scene = nueva_escena  # Actualiza la referencia a la escena actual.
		print("Nueva escena cargada:", nueva_escena.name)
	else:
		print("Error: No se pudo cargar la escena en la ruta:", path)

func jugadorCaido():
	print("Jugador caído. Reiniciando escena...")
	goto_scene("res://escenas/nivel.tscn")
