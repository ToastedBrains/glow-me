extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var light_power = 2
@onready var light_radius = 3
@onready var power_up = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func charge_up():
	power_up = true

func charge_down():
	power_up = false

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	if power_up:
#		print("pw up", light_power, " ", $PointLight2D.texture_scale)
		light_power = clamp(light_power + 0.01, 0.1, 2)
		$PointLight2D.energy = light_power
		$PointLight2D.texture_scale = clamp($PointLight2D.texture_scale + $PointLight2D.texture_scale * 0.01, 0.5, 3)
	else:
#		print("pw down", light_power, " ",  $PointLight2D.texture_scale)
		light_power = clamp(light_power - 0.001, 0.1, 2)
		$PointLight2D.texture_scale = clamp($PointLight2D.texture_scale - $PointLight2D.texture_scale * 0.001, 0.5, 3)
		$PointLight2D.energy = light_power
#		$PointLight2D.texture_scale -= $PointLight2D.texture_scale * 0.001


#func _on_area_2d_body_entered(body):
#	print("entered")
#	if body.is_in_group("light_sources"):
#		print("s-enter")
#		power_up = true
#
#
#func _on_area_2d_body_exited(body):
#	print("exited")
#	if body.is_in_group("light_sources"):
#		print("s-exit")
#		power_up = false


func _on_area_2d_area_entered(area):
	print("entered")
	if area.is_in_group("light_sources"):
		print("s-enter")
		power_up = true


func _on_area_2d_area_exited(area):
	print("exited")
	if area.is_in_group("light_sources"):
		print("s-exit")
		power_up = false
