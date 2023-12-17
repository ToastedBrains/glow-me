extends Node2D

var energy = 2.0
var permanent = false
var energy_left = 0.0 # percent
var load_rate = 0.003
var unload_rate = 0.001 # percent
var color = Color(0.243, 0.984, 0.694, 1)
var sources : Dictionary
var id : int

var has_emitted = false
var tracked_objects : Array[Node2D]


func set_permanent():
	permanent = true
	energy_left = 1.0
	color = Color(0, 1, 0, 1)
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

func logV():
	$Label.show()
	$Label.text = "color = {color}\nenergy = {energy}\ne_left = {e_left}%\nradius = {radius}\nsources = {sources}".format({
		"energy": energy,
		"color": color,
		"e_left": "%3.3f" % energy_left,
		"radius": $Halo/CollisionShape2D.scale,
		"sources": sources,
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
	has_emitted = true
	

func _on_halo_body_entered(body):
	if body.is_in_group("phosphorescents"):
		var phosphorescent = body.get_node("Phosphorescence")
		#if id != phosphorescent.id:
			#if energy_left * energy > phosphorescent.energy_left * phosphorescent.energy:
				#tracked_objects.append(body)
				#phosphorescent.sources[id] = clamp((energy_left * energy + phosphorescent.energy_left * phosphorescent.energy) / 2 / phosphorescent.energy, 0.0, 1.0)
		if id != phosphorescent.id:
			tracked_objects.append(body)

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
	await get_tree().create_timer(0.01).timeout
	$PointLight2D.color = Color(
				color.r * clamp(energy_left, 0.1, 1.0),
				color.g * clamp(energy_left, 0.1, 1.0),
				color.b * clamp(energy_left, 0.1, 1.0),
				1,
			)


func _process(_delta):
	
	if not permanent:
		var is_player = get_parent() is CharacterBody2D
		if has_emitted and energy_left >= 1.0 and not is_player:
			Debug.print(["full"])
			#permanent = true
			set_permanent()
		else:
			emit()
		
	if len(sources) > 0:
		var max_energy = 0.0
		for s in sources:
			if sources[s] > max_energy:
				max_energy = sources[s]
		energy_left = clamp(energy_left + load_rate, 0.0, max_energy)
	#logV( )


func _physics_process(delta):
	if len(tracked_objects) > 0:
		#Debug.print("bodies: {v}".format({ "v": len(tracked_objects)}))
		for node in tracked_objects:
			var phosphorescent = node.get_node("Phosphorescence")
			if is_in_sight(node):
				if energy_left * energy > phosphorescent.energy_left * phosphorescent.energy:
					phosphorescent.sources[id] = clamp((energy_left * energy + phosphorescent.energy_left * phosphorescent.energy) / 2 / phosphorescent.energy, 0.0, 1.0)
			else:
				phosphorescent.sources.erase(id)

