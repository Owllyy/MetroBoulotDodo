extends CollisionShape2D

@onready var test = $"../../test"

func _ready() -> void:
	test.hide()
	
func _on_tri_zone_body_entered(body: Node2D) -> void:
	test.show()

func _on_tri_zone_body_exited(body: Node2D) -> void:
	test.hide()
