extends CharacterBody2D


@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var speed = 300.0
@export var jump_velocity = -400.0


func _ready():
	$Phosphorescence.load_rate = 0.007

func _physics_process(delta):
	$AnimatedSprite2D.animation = "idle"
	if not is_on_floor():
		velocity.y += gravity * delta
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * speed
		$AnimatedSprite2D.animation = "run"
		if velocity.x > 0:
			
			$AnimatedSprite2D.flip_h = false
		else:
			#$AnimatedSprite2D.animation = "run"
			$AnimatedSprite2D.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	if move_and_slide():
		for collisions in get_slide_collision_count():
			var collision = get_slide_collision(collisions)
			if collision.get_collider() is RigidBody2D:
				collision.get_collider().apply_force(collision.get_normal() * -2500)

