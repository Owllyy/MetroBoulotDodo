extends Node2D

@export var music: AudioStream

@onready var trigame = $MiniGameTri

@onready var darkness = $Camera2D/DarkOverlay/dark

@onready var score_text = $Camera2D/UI/Score
@onready var light_timer = $LightTimer

var game_timer: Timer
@onready var timerSlider = $TimerBar

const color_dark = Color(0,0,0,0.5)
const color_bright = Color(0,0,0,0)

var difficulty = 0
var current_shoes : int = 0
var quota : int = 5

var life = 3

func _ready() -> void:
	start(GameManager.getDayCount())
	trigame.show()
	GameManager.playMusic(music)

func start(iteration: int):
	# Change if you want to give more or less time per iteration
	setupTimer(25 + 2 * iteration)
	quota = 5 + (4 * iteration)
	$MiniGameTri/SpawnTimer.wait_time = (1.1 - (0.2 * iteration))
	update_score_display()
	trigame.set_shoe_speed(90 * (0.8 * iteration))
	darkness.color = color_bright
	light_timer.wait_time = 6 - iteration
	light_timer.start()
	trigame.hide()
	game_timer.start()

func _process(delta: float) -> void:
	if darkness.color == color_dark:
		Globals.is_dark = true
	else :
		Globals.is_dark = false
	timerSlider.value = game_timer.time_left

func setupTimer(timer_duration: float):
	game_timer = Timer.new()
	game_timer.wait_time = timer_duration
	#print(game_timer.wait_time)
	
	timerSlider.max_value = timer_duration
	game_timer.one_shot = true
	game_timer.timeout.connect(_on_timer_timeout)
	add_child(game_timer)

func _on_timer_timeout():
	gameFail()
	
func lose_life():
	life -= 1
	if (life <= 0):
		gameFail()

func gameFail():
	GameManager.goToLooseScreen()
	print("Game Failed - Time's up!")

func set_difficulty(difficulty : int):
	#on regarde le jour et on set
	pass

func light_blink():
	switch_light()
	await get_tree().create_timer(1.5).timeout
	switch_light()
	
func switch_light():
	if darkness.color == color_bright:
		darkness.color = color_dark
	else:
		darkness.color = color_bright

func update_score():
	current_shoes += 1
	update_score_display()
	if current_shoes >= quota:
		game_timer.stop()
		GameManager.goToNextStage()
	
func update_score_display():
	score_text.text = str(current_shoes) + " / " + str(quota)
	
func _on_light_timer_timeout() -> void:
	var onoff = randi() & 1
	if onoff == 1 :
		light_blink()
