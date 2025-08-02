extends Node

@export var scenes : Dictionary[String, PackedScene] = {}

func goToScene(sceneName: String):
	var scene = scenes.get(sceneName);
	if scene:
		get_tree().change_scene_to_packed(scenes[sceneName])
	else:
		push_error(sceneName + ": unknown scene")
