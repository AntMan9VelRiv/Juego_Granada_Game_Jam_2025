extends Node

var vidas_iniciales = 3  # Número inicial de vidas
var vidas_actuales = vidas_iniciales  # Contador actual de vidas
var burbujas_destruidas = 0  # Contador de burbujas destruidas
var total_burbujas = 0
var derrota = false

var current_scene: Node = null  # Referencia a la escena actual

@onready var personaje = null  # Referencia al personaje principal
@onready var vidas_container = null  # Contenedor de corazones

var corazones_llenos = []
var corazones_vacios = []
var etiqueta_vidas: Label = null  # Referencia al Label de vidas
var etiqueta_burbujas: Label = null  # Referencia al Label de burbujas

func _ready():
	current_scene = get_tree().current_scene
	if vidas_container:
		print("HBoxContainer encontrado correctamente.")
		for child in vidas_container.get_children():
			if child.name.begins_with("Sprite2DVida") and not child.name.contains("Vacia"):
				corazones_llenos.append(child)
			elif child.name.begins_with("Sprite2DVidaVacia"):
				corazones_vacios.append(child)

		corazones_llenos.sort_custom(Callable(self, "_ordenar_por_nombre"))
		corazones_vacios.sort_custom(Callable(self, "_ordenar_por_nombre"))

		print("Corazones llenos ordenados:", corazones_llenos)
		print("Corazones vacíos ordenados:", corazones_vacios)
	else:
		print("Error: HBoxContainer no asignado.")
	actualizar_vidas()

func _ordenar_por_nombre(a, b):
	var numero_a = int(a.name.replace("Sprite2DVida", "").replace("Vacia", ""))
	var numero_b = int(b.name.replace("Sprite2DVida", "").replace("Vacia", ""))
	return numero_a > numero_b

func asignar_personaje(nodo_personaje: Node):
	if is_instance_valid(nodo_personaje):
		personaje = nodo_personaje
		print("Personaje asignado correctamente")
	else:
		print("Error: Nodo de personaje no válido")

func asignar_label_vidas(label_nodo: Label):
	if is_instance_valid(label_nodo):
		etiqueta_vidas = label_nodo
		actualizar_vidas()

func asignar_label_burbujas(label_nodo: Label):
	if is_instance_valid(label_nodo):
		etiqueta_burbujas = label_nodo
		actualizar_burbujas_label()

func restar_vida():
	if vidas_actuales <= 0:
		print("El jugador ya está en derrota.")
		return

	vidas_actuales -= 1
	actualizar_vidas()

	if vidas_actuales <= 0:
		print("Game Over!")
		goto_derrota()
	else:
		reposicionar_personaje()

func añadir_vida():
	vidas_actuales = min(vidas_actuales + 1, vidas_iniciales)
	actualizar_vidas()

func actualizar_vidas():
	if not corazones_llenos or not corazones_vacios:
		print("Error: No se pueden actualizar las vidas, listas vacías.")
		return

	for i in range(vidas_iniciales):
		corazones_llenos[i].visible = i < vidas_actuales
		corazones_vacios[i].visible = i >= vidas_actuales

	if etiqueta_vidas:
		etiqueta_vidas.text = "VIDAS: " + str(vidas_actuales)

func reposicionar_personaje():
	if is_instance_valid(personaje):
		personaje.position = Vector2(200, 300)
		personaje.velocity = Vector2.ZERO
		if personaje.has_method("reiniciar_estado"):
			personaje.reiniciar_estado()
	else:
		print("Error: No se puede reposicionar, personaje no asignado.")

func jugadorCaido():
	vidas_actuales -= 1
	actualizar_vidas()
	
	if vidas_actuales <= 0:
		derrota = true
		goto_derrota()
	else:
		print("Jugador caído. Reiniciando escena...")
		get_tree().current_scene.queue_free()  # Eliminar la escena actual antes de cargar la nueva
		goto_scene("res://escenas/nivel.tscn")


func actualizar_burbujas_destruidas():
	burbujas_destruidas += 1
	actualizar_burbujas_label()
	if burbujas_destruidas >= total_burbujas:
		goto_victoria()

func actualizar_burbujas_label():
	if etiqueta_burbujas:
		etiqueta_burbujas.text = "BURBUJAS: " + str(burbujas_destruidas)

func goto_scene(path: String):
	call_deferred("_deferred_goto_scene", path)

func _deferred_goto_scene(path: String):
	if is_instance_valid(current_scene):
		current_scene.queue_free()
	var nueva_escena = load(path).instantiate()
	get_tree().root.add_child(nueva_escena)
	get_tree().current_scene = nueva_escena
	current_scene = nueva_escena
	print("Nueva escena cargada:", nueva_escena.name)

func goto_victoria():
	goto_scene("res://escenas/victoria.tscn")

func goto_derrota():
	goto_scene("res://escenas/derrota.tscn")

func reiniciar_variables():
	print("Reiniciando variables del juego...")
	
	# Reiniciar todas las variables del juego a sus valores iniciales
	vidas_actuales = vidas_iniciales
	burbujas_destruidas = 0
	derrota = false
	personaje = null
	vidas_container = null
	current_scene = null
	
	corazones_llenos.clear()
	corazones_vacios.clear()
