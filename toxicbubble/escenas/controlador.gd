extends Node

var vidas_iniciales = 3  # Número inicial de vidas
var vidas_actuales = vidas_iniciales  # Contador actual de vidas
var burbujas_destruidas = 0  # Contador de burbujas destruidas
var total_burbujas = 0
var derrota = false
var ruta_etiqueta_nivel: Label = null  # Referencia al Label en pantalla
var current_scene: Node = null  # Referencia a la escena actual

var ruta_etiqueta_burbujas= null # Referencia al Label de burbuja en pantalla

@onready var personaje = null  # Referencia al personaje principal+

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
	if derrota:  # Si ya está en derrota, no hacer nada
		return

	# Resta una vida y actualiza la pantalla
	vidas_actuales -= 1
	actualizar_vidas()

	if vidas_actuales <= 0:
		print("Vidas agotadas. Reiniciando nivel...")
		derrota = true  # Marca que el jugador está en derrota
		goto_derrota()  # Cambia a la escena de derrota
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
	vidas_actuales -= 1
	actualizar_vidas()
	if vidas_actuales <= 0:
		derrota = true
		goto_derrota()
	else:
		print("Jugador caído. Reiniciando escena...")
		goto_scene("res://escenas/nivel.tscn")
	
func goto_victoria():
	call_deferred("_deferred_change_scene", "res://escenas/victoria.tscn")

func goto_derrota():
	call_deferred("_deferred_change_scene", "res://escenas/derrota.tscn")

func _deferred_change_scene(ruta: String):
	get_tree().change_scene_to_file(ruta)
	
func asignar_label_burbujas(label_nodo: Label):
	ruta_etiqueta_burbujas = label_nodo
	actualizar_burbujas_label()

func actualizar_burbujas_label():
	if ruta_etiqueta_burbujas:
		ruta_etiqueta_burbujas.text = "BURBUJAS: " + str(burbujas_destruidas)

func actualizar_burbujas_destruidas():
	burbujas_destruidas += 1
	actualizar_burbujas_label()  # Actualiza el Label en pantalla
	if burbujas_destruidas >= total_burbujas:
		goto_victoria()
	print("Burbujas destruidas: ", burbujas_destruidas)
	
func reiniciar_variables():
	# Reinicia las variables del juego
	vidas_actuales = vidas_iniciales  # Reinicia el contador de vidas
	burbujas_destruidas = 0  # Reinicia el contador de burbujas

	# Reinicia las referencias a los Labels (pueden ser reasignadas en _ready)
	ruta_etiqueta_nivel = null
	ruta_etiqueta_burbujas = null
	# Si las referencias a los Labels son válidas, actualiza su texto
	if is_instance_valid(ruta_etiqueta_nivel):
		ruta_etiqueta_nivel.text = "VIDAS: " + str(vidas_actuales)
	if is_instance_valid(ruta_etiqueta_burbujas):
		ruta_etiqueta_burbujas.text = "BURBUJAS: " + str(burbujas_destruidas)
	
