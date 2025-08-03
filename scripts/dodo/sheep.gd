extends CharacterBody2D

enum State {
	IDLE,
	WALK
}

var moveSpeed = 5
var active: bool = true
var direction = Vector2(0, 0)
var random = RandomNumberGenerator.new()

var current_state: State = State.IDLE
var state_timer: float = 0.0
var footstep_timer: float = 0.0
var footstep_interval: float = 1.0
var idle_duration_min: float = 1.0
var idle_duration_max: float = 3.0
var walk_duration_min: float = 2.0
var walk_duration_max: float = 5.0
var state_change_time: float = 0.0

@export var footsteps: Array[AudioStream]
@export var cry: Array[AudioStream]
@onready var FootstepsAudioPlayer: AudioStreamPlayer2D = $FootstepsAudioPlayer
@onready var CryAudioPlayer: AudioStreamPlayer2D = $CryAudioPlayer

func _ready():
	random.randomize()
	var start_state = State.IDLE if random.randf() < 0.5 else State.WALK
	setState(start_state)

func setState(new_state: State):
	current_state = new_state
	state_timer = 0.0
	
	match current_state:
		State.IDLE:
			direction = Vector2.ZERO
			footstep_timer = 0.0
			state_change_time = random.randf_range(idle_duration_min, idle_duration_max)
		State.WALK:
			chooseDirection()
			footstep_timer = 0.0
			state_change_time = random.randf_range(walk_duration_min, walk_duration_max)

func chooseDirection():
	direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0))
	direction = direction.normalized()

func _process(delta: float) -> void:
	state_timer += delta
	
	match current_state:
		State.IDLE:
			handleIdleState(delta)
		State.WALK:
			handleWalkState(delta)
	
	# Check if it's time to change states
	if state_timer >= state_change_time:
		changeState()

func handleIdleState(delta: float):
	pass

func handleWalkState(delta: float):
	footstep_timer += delta
	
	# Play footstep sound at regular intervals
	if footstep_timer >= footstep_interval:
		playFootstepSound()
		footstep_timer = 0.0
	var collision = move_and_collide(direction * moveSpeed * delta)
	if collision:
		onCollision(collision)

func changeState():
	match current_state:
		State.IDLE:
			setState(State.WALK)
		State.WALK:
			setState(State.IDLE)

func onCollision(collision: KinematicCollision2D):
	direction = direction.bounce(collision.get_normal())

func playFootstepSound():
	if FootstepsAudioPlayer and footsteps.size() > 0:
		# Pick a random footstep sound from the array
		var random_footstep = footsteps[random.randi() % footsteps.size()]
		FootstepsAudioPlayer.stream = random_footstep
		FootstepsAudioPlayer.play()

func catch():
	z_index = 100
	setState(State.IDLE)
	direction = Vector2.ZERO
	footstep_timer = 0.0
	FootstepsAudioPlayer.stop()
	set_collision_layer_value(1, false)
	set_collision_layer_value(2, false)
	set_collision_mask_value(1, false)
	set_collision_mask_value(2, false)
	if CryAudioPlayer and cry.size() > 0:
		# Pick a random cry sound from the array
		var random_cry = cry[random.randi() % cry.size()]
		CryAudioPlayer.stream = random_cry
		print("Play sound")
		CryAudioPlayer.play()
	
	var tween = create_tween()
	tween.set_parallel(true)  # Allow multiple animations to run simultaneously
	
	# Calculate random upward direction with slight angle variation
	var fly_angle = random.randf_range(-30.0, 30.0)  # Random angle between -30 and 30 degrees
	var fly_direction = Vector2.UP.rotated(deg_to_rad(fly_angle))
	var fly_distance = 800.0  # How far the sheep flies
	var fly_duration = 1.5  # Animation duration in seconds
	
	# Animate position (flying upward and off-screen)
	var target_position = global_position + fly_direction * fly_distance
	tween.tween_property(self, "global_position", target_position, fly_duration)
	
	# Animate rotation (spinning while flying)
	var rotation_amount = random.randf_range(720.0, 1440.0)  # 2-4 full rotations
	tween.tween_property(self, "rotation_degrees", rotation_degrees + rotation_amount, fly_duration)
	
	# Optional: Animate scale (sheep gets smaller as it flies away)
	tween.tween_property(self, "scale", Vector2(0.3, 0.3), fly_duration)
	
	# Wait for both the cry sound and animation to finish
	var tasks = []
	if CryAudioPlayer.is_playing():
		tasks.append(CryAudioPlayer.finished)
	tasks.append(tween.finished)
	
	# Wait for whichever takes longer
	if tasks.size() > 0:
		await tasks[0]
	self.queue_free()
