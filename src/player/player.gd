extends CharacterBody2D


@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var speed = 200.0
@export var jump_velocity = -400.0

enum {IDLE, IDLE_LOW, RUN, JUMP, LOAD, PEE, SLEEP, THROW_UP}

var state = IDLE
var idle = IDLE
var low_battery = false
var charging = false

func idle_mode():
	if low_battery:
		idle = IDLE_LOW
	elif charging:
		idle = LOAD
	else:
		idle = IDLE

		
func shuffle_idle():
	var joke = randi_range(1, 6)
	if joke == 1:
		idle = PEE
		await get_tree().create_timer(2).timeout
		idle_mode()
	elif joke == 2:
		idle = THROW_UP
		await get_tree().create_timer(2).timeout
		idle_mode()
	else:
		idle = IDLE
	

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
			if not $JumpSound.playing:
				$JumpSound.play()
		LOAD:
			$AnimatedSprite2D.animation = "load"
		PEE:
			$AnimatedSprite2D.animation = "pee"
		SLEEP:
			$AnimatedSprite2D.animation = "sleep"
		THROW_UP:
			$AnimatedSprite2D.animation = "throw_up"


func _ready():
	$Phosphorescence.energy = 2.5
	$Phosphorescence.load_rate = 0.007
	

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
		idle_mode()
		state = idle
	if not is_on_floor():
		velocity.y += gravity * delta
		state = JUMP
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
