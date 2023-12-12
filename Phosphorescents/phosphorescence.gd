extends Node2D

enum {DISCHARGING, CHARGING}

var state = DISCHARGING
var permanent = false
var energy = 2.0
var energy_left = 1.0 # percent
var load_rate = 0.003
var unload_rate = 0.001 # percent
var color = Color(0.243, 0.984, 0.694, 1)
var sources : Dictionary
var id : int

var charging = false


func logV():
	$Label.show()
	$Label.text = "energy = {energy}\nenergy_left = {energy_left}%\nradius = {radius}\nsources = {sources}\ncharge = {charging}".format({
		"energy": energy,
		"energy_left": "%3.3f" % energy_left,
		"radius": $Halo/CollisionShape2D.scale,
		"sources": sources,
		"charging": charging,
		})

func emit():
	charging = false
	energy_left = clamp(energy_left - unload_rate, 0.0, energy)
	$PointLight2D.energy = energy * clamp(energy_left, 0.5, 1.0)
	$PointLight2D.texture_scale = clamp(energy_left * energy, 0.25 * energy, 1.0 * energy)
	$Halo/CollisionShape2D.set_scale(Vector2(
			clamp(energy_left * energy, 0.25 * energy, 1.0 * energy),
			clamp(energy_left * energy, 0.25 * energy, 1.0 * energy)),
		)
	$PointLight2D.color = Color(
			color.r * clamp(energy_left, 0.1, 1.0),
			color.g * clamp(energy_left, 0.1, 1.0),
			color.b * clamp(energy_left, 0.1, 1.0),
			1,
		)

func _on_halo_body_entered(body):
	if body.is_in_group("phosphorescents"):
		var phosphorescent = body.get_node("Phosphorescence")
		if id != phosphorescent.id:
			if energy_left * energy > phosphorescent.energy_left * phosphorescent.energy:
				#phosphorescent.sources[id] = energy_left
				phosphorescent.sources[id] = clamp((energy_left * energy + phosphorescent.energy_left * phosphorescent.energy) / 2 / phosphorescent.energy, 0.0, 1.0)


func _on_halo_body_exited(body):
	if body.is_in_group("phosphorescents"):
		var phosphorescent = body.get_node("Phosphorescence")
		if id != phosphorescent.id:
			phosphorescent.sources.erase(id)


func _ready():
	randomize()
	id = randi_range(1, 999999)
	get_parent().add_to_group("phosphorescents")
	$PointLight2D.texture_scale = clamp(energy_left * energy, 0.25 * energy, 1.0 * energy)
	$Halo/CollisionShape2D.set_scale(Vector2(
			clamp(energy_left * energy, 0.25 * energy, 1.0 * energy),
			clamp(energy_left * energy, 0.25 * energy, 1.0 * energy)),
		)
	$PointLight2D.color = Color(
				color.r * clamp(energy_left, 0.1, 1.0),
				color.g * clamp(energy_left, 0.1, 1.0),
				color.b * clamp(energy_left, 0.1, 1.0),
				1,
			)

func _process(_delta):
	if not permanent:
		emit()
	if len(sources) > 0:
		var max = 0.0
		for s in sources:
			if sources[s] > max:
				max = sources[s]
		charging = true
		energy_left = clamp(energy_left + load_rate, 0.0, max)
	logV()


