extends TextureRect

func _ready():
	texture = GameManager.getCurrentGameLostTexture()
