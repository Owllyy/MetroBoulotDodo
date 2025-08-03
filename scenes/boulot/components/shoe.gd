extends CharacterBody2D

@onready var sprite = $Sprite

var is_dragging: bool = false
var color: int = 0  # 0 = white, 1 = black

# Variable partagée entre tous les objets : l'objet actuellement drag
static var current_dragged: CharacterBody2D = null

func _process(delta: float) -> void:
	if is_dragging:
		global_position = get_global_mouse_position()
	if GameManager.is_dark == true:
		#modulate pour mettre en noir
		pass
	else:
		#remettre le sprite en normal
		pass
		
func _unhandled_input(event):
	# Si on clique sur ce collider (via input_event), on commence à drag
	if is_dragging and event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			# Relâchement du clic -> arrêter de drag
			is_dragging = false
			scale = Vector2(1, 1)
			current_dragged = null

# Déclenché quand on clique sur le collider du CharacterBody2D
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			# Si aucun autre objet n'est en train d'être drag
			if current_dragged == null:
				is_dragging = true
				scale = Vector2(1.5, 1.5)
				current_dragged = self
