extends CharacterBody2D


@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var speed = 200.0
@export var jump_velocity = -400.0

enum {IDLE, IDLE_LOW, RUN, JUMP, LOAD, PEE, SLEEP, THROW_UP}

var state = IDLE
var idle = IDLE
var low_battery = false
var charging = false

var can_play_jump_sound = true

func idle_mode():
	if low_battery:
		return IDLE_LOW
	elif charging:
		return LOAD
	else:
		return IDLE

		
func shuffle_idle():
	var joke = randi_range(1, 23)
	if joke == 7:
		idle = PEE
		await get_tree().create_timer(2).timeout
		idle = idle_mode()
	elif joke == 13:
		idle = THROW_UP
		await get_tree().create_timer(2).timeout
		idle = idle_mode()
	elif joke == 17:
		idle = SLEEP
		await get_tree().create_timer(2).timeout
		idle = idle_mode()
	else:
		idle = idle_mode()
	Debug.print([idle])
	

func set_animation():
	match state:
		IDLE:
			$AnimatedSprite2D.animation = "idle"
		IDLE_LOW:
			$AnimatedSprite2D.animation = "idle_low"
		RUN:
			$AnimatedSprite2D.animation = "run"
			if not $StepsSound.playing:
				$StepsSound.play()
				
		JUMP:
			$AnimatedSprite2D.animation = "jump"
			if not $JumpSound.playing and can_play_jump_sound:
				can_play_jump_sound = false
				$JumpSound.play()
				
		LOAD:
			$AnimatedSprite2D.animation = "load"
			if not $LoadSound.playing:
				$LoadSound.play()
		PEE:
			$AnimatedSprite2D.animation = "pee"
			if not $PeeSound.playing:
				$PeeSound.play()
		SLEEP:
			$AnimatedSprite2D.animation = "sleep"
			if not $SleepSound.playing:
				$SleepSound.play()
		THROW_UP:
			$AnimatedSprite2D.animation = "throw_up"
			if not $ThrowUpSound.playing:
				$ThrowUpSound.play()


func _ready():
	$Phosphorescence.energy = 2.5
	$Phosphorescence.load_rate = 0.007
	$JumpSound.volume_db = -80
	await get_tree().create_timer(0.5).timeout
	$JumpSound.volume_db = -15

func _physics_process(delta):
	if $Phosphorescence.energy_left < 0.5:
		low_battery = true
	else:
		low_battery = false
	if len($Phosphorescence.sources) > 0:
		charging = true
	else:
		charging = false
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * speed
		state = RUN
		if velocity.x > 0:
			$AnimatedSprite2D.flip_h = false
		else:
			$AnimatedSprite2D.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		#idle_mode()
		state = idle
	if not is_on_floor():
		velocity.y += gravity * delta
		state = JUMP
	else:
		can_play_jump_sound = true
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity
		state = JUMP
		shuffle_idle()
	if move_and_slide():
		for collisions in get_slide_collision_count():
			var collision = get_slide_collision(collisions)
			if collision.get_collider() is RigidBody2D:
				collision.get_collider().apply_force(collision.get_normal() * -2500)
	set_animation()

