extends CharacterBody2D


@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var charging = false

@export var speed = 300.0
@export var jump_velocity = -400.0
@export var energy = 2
@export var radius = 2

func set_energy():
	if charging:
		energy = clamp(energy + 0.01, 0.1, 2)
		$PointLight2D.energy = energy
		$PointLight2D.texture_scale = clamp($PointLight2D.texture_scale + $PointLight2D.texture_scale * 0.01, 0.5, 3)
	else:
		energy = clamp(energy - 0.001, 0.1, 2)
		$PointLight2D.texture_scale = clamp($PointLight2D.texture_scale - $PointLight2D.texture_scale * 0.001, 0.5, 3)
		$PointLight2D.energy = energy

func charge_up():
	charging = true

func charge_down():
	charging = false

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	if move_and_slide():
		for collisions in get_slide_collision_count():
			var collision = get_slide_collision(collisions)
			if collision.get_collider() is RigidBody2D:
				collision.get_collider().apply_force(collision.get_normal() * -2500)
	set_energy()


func _on_area_2d_area_entered(area):
	print("entered")
	if area.is_in_group("light_sources"):
		print("s-enter")
		charging = true


func _on_area_2d_area_exited(area):
	print("exited")
	if area.is_in_group("light_sources"):
		print("s-exit")
		charging = false
