extends Node2D

var animacion_actual = null;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cambiar_animacion("salida_alcantarilla")
	animacion_actual = "salida_alcantarilla"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func cambiar_animacion(nueva_animacion):
	if nueva_animacion != animacion_actual:
		$Sprite2D/AnimationPlayer.play(nueva_animacion)
		animacion_actual = nueva_animacion
