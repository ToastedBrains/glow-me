extends Node2D

enum {INIT, CHARGING, DISCHARGING, PERMANENT}

var state = INIT
var energy = 2.0
var min_energy = 0.5
var max_energy = 2.0
var max_load = 0.0
var load_rate = 0.005
var unload_rate = 0.001
var min_radius = 1
var color = Color(0.243, 0.984, 0.694, 1)

var sources = []
var id : int

@export var permanent = false



func change_state(
		new_state,
		source_power : float = 0.0,
		#source_rate : float = 0.0,
		#max_load : float = 0.0
	):
	if new_state == PERMANENT:
		energy = max_energy
		$PointLight2D.texture_scale = max_energy
		$Halo/CollisionShape2D.set_scale(Vector2(max_energy, max_energy))
	else:
		match new_state:
			INIT:
				energy = min_energy
			CHARGING:
				sources.append(source_power / 2)
				#load_rate += source_rate
				max_load = sources.max()
			DISCHARGING:
				#load_rate = clamp(load_rate - source_rate, 0, 99)
				var i = sources.find(source_power)
				if i > -1:
					sources.erase(i)
	state = new_state


func set_energy():
	# The body is always unloading energy.
	if state != PERMANENT:
		energy = clamp(energy - unload_rate * 1, min_energy, max_energy)
		$PointLight2D.texture_scale = clamp($PointLight2D.texture_scale - $PointLight2D.texture_scale * unload_rate, min_radius, max_energy)
		$PointLight2D.energy = energy
		$Halo/CollisionShape2D.set_scale(Vector2(energy, energy))

	var r = energy / max_energy
	$PointLight2D.color = Color(color.r * r, color.g * r, color.b * r, 1)
		
	if state == CHARGING:
		energy = clamp(energy + load_rate, min_energy, max_load)
		$PointLight2D.energy = energy
		$PointLight2D.texture_scale = clamp($PointLight2D.texture_scale + $PointLight2D.texture_scale * load_rate, min_radius, max_load)
		$Halo/CollisionShape2D.set_scale(Vector2(energy, energy))

func emit():
	pass

func absorb():
	pass
	

func _ready():
	randomize()
	id = randi_range(1, 999999)
	#$Halo/CollisionShape2D.disabled = true
	#await get_tree().create_timer(5).timeout
	#$Halo/CollisionShape2D.disabled = false
	change_state(INIT)
	get_parent().add_to_group("phosphorescents")
	#if permanent:
		#change_state(PERMANENT)

func _process(delta):
	set_energy()
	$Label.text = "energy : {energy}\nload_rate = {load_rate}".format({
		"energy": energy,
		"load_rate": load_rate,
		})


func _on_halo_body_entered(body):
	#print("enter ", body.name)
	if body.is_in_group("phosphorescents"):
		print("Is Phosphorescence! => ", body)
		var phosphorescent = body.get_node("Phosphorescence")
		if id != phosphorescent.id:
		#print("ID of this: ", id, " - Body's ID: ", phosphorescent.id)
		#print(phosphorescent)
		#phosphorescent.sources
			phosphorescent.change_state(1, energy)
		#print(phosphorescent.state)


func _on_halo_body_exited(body):
	#print("exit")
	if body.is_in_group("phosphorescents"):
		var phosphorescent = body.get_node("Phosphorescence")
		if id != phosphorescent.id:
			phosphorescent.change_state(2, energy)


