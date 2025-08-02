extends CollisionShape2D

@onready var boulotscene = $"../.."
@onready var test = $"../../test"

var current_zone : String = "none"

func _ready() -> void:
	test.hide()
	
func _on_tri_zone_body_entered(body: Node2D) -> void:
	current_zone = "trizone"
	test.show()

func _on_tri_zone_body_exited(body: Node2D) -> void:
	current_zone = "none"
	test.hide()

func _input(event):
	if event.is_action_pressed("interact"):
		boulotscene._openclose_minigame(current_zone)
