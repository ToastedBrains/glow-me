extends Node2D

var permanent = false
var energy = 5.0
var energy_left = 1.0 # percent
var load_rate = 0.003
var unload_rate = 0.001 # percent
var color = Color(0.243, 0.984, 0.694, 1)
var sources : Dictionary
var id : int

var illuminated = false
var tracked_objects : Array[Node2D]

func logV():
	$Label.show()
	$Label.text = "energy = {energy}\nenergy_left = {energy_left}%\nradius = {radius}\nsources = {sources}\ncharge = {illuminated}".format({
		"energy": energy,
		"energy_left": "%3.3f" % energy_left,
		"radius": $Halo/CollisionShape2D.scale,
		"sources": sources,
		"illuminated": illuminated,
		})


func is_in_sight(node_to_check_for_view) -> bool:
	var raycast = RayCast2D.new()
	add_child(raycast)
	raycast.target_position = Vector2(
		node_to_check_for_view.global_position.x - global_position.x,
		node_to_check_for_view.global_position.y - global_position.y,
	)
	raycast.position = Vector2(0, 0)
	raycast.force_raycast_update()
	if raycast.is_colliding():
		var collided_node = raycast.get_collider()
		if collided_node == node_to_check_for_view:
			raycast.queue_free()
			return true
	raycast.queue_free()
	return false


func emit():
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
				tracked_objects.append(body)
				phosphorescent.sources[id] = clamp((energy_left * energy + phosphorescent.energy_left * phosphorescent.energy) / 2 / phosphorescent.energy, 0.0, 1.0)


func _on_halo_body_exited(body):
	if body.is_in_group("phosphorescents"):
		var phosphorescent = body.get_node("Phosphorescence")
		tracked_objects.erase(body)
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
		var max_energy = 0.0
		for s in sources:
			if sources[s] > max_energy:
				max_energy = sources[s]
		energy_left = clamp(energy_left + load_rate, 0.0, max_energy)
	#logV()


func _physics_process(delta):
	if len(tracked_objects) > 0:
		Debug.print("bodies: {v}".format({ "v": len(tracked_objects)}))
		for node in tracked_objects:
			var phosphorescent = node.get_node("Phosphorescence")
			if is_in_sight(node):
				if energy_left * energy > phosphorescent.energy_left * phosphorescent.energy:
					phosphorescent.sources[id] = clamp((energy_left * energy + phosphorescent.energy_left * phosphorescent.energy) / 2 / phosphorescent.energy, 0.0, 1.0)
			else:
				phosphorescent.sources.erase(id)

