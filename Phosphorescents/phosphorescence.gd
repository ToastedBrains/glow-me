extends Node2D

#Quand on rentre dans une zone où il y a de la lumière, on se recharge.
#
#Comment savoir si on rentre dans une zone de lumière ?
#- La zone nous avertit.
#=> si elle a plus d'energie que nous, on peut se charger à hauteur de [calcul, en tenant compte de la décroissance si c'est un phospho]
#=> si c'est une permanente, on charge au max.
#
#- quand on quitte la zone elle nous prévient.
#
#DONC : il faut garder en mémoire dans combien de zones on se trouve !
#on perd le statut charging que si on quitte toutes les sources.
#
#Il faut garder trace de : 
	#- combien il y a de sources
	#- combien d'énergie par source
	#
	#Array[float]

enum {DISCHARGING, CHARGING}

var state = DISCHARGING
var permanent = false
var energy = 3.0
var energy_left = 3.0 # percent
#var energy_min = 1.0 # cheat to avoid being totally invisible
#var energy_max = 100.0 # max energy amount that can be carried at all
var load_rate = 0.05
var unload_rate = 0.01 # percent
var color = Color(0.243, 0.984, 0.694, 1)
var sources : Array[float] = [] 
var id : int


func logV():
	$Label.show()
	$Label.text = "energy_left : {energy_left}\nradius = {radius}\nsources = {sources}".format({
		"energy_left": energy_left,
		"radius": $Halo/CollisionShape2D.scale,
		"sources": sources,
		})

func _on_halo_body_entered(body):
	if body.is_in_group("phosphorescents"):
		var phosphorescent = body.get_node("Phosphorescence")
		if id != phosphorescent.id:
			print("! Phosphorescent: ", body)
			print(energy_left, phosphorescent.energy_left)
			if energy_left > phosphorescent.energy_left:
				print("new source")
				phosphorescent.sources.append(energy_left)

func _on_halo_body_exited(body):
	if body.is_in_group("phosphorescents"):
		var phosphorescent = body.get_node("Phosphorescence")
		if id != phosphorescent.id:
			phosphorescent.sources.clear()
			print("leave")
			#var i = phosphorescent.sources.find(phosphorescent.energy)
			#if i > -1:
				#sources.erase(i)

func _ready():
	randomize()
	id = randi_range(1, 999999)
	get_parent().add_to_group("phosphorescents")
	$PointLight2D.color = Color(
				color.r * clamp(energy_left, 0.1, 1.0),
				color.g * clamp(energy_left, 0.1, 1.0),
				color.b * clamp(energy_left, 0.1, 1.0),
				1,
			)

func _process(_delta):
	if not permanent:
		energy_left = clamp(energy_left - unload_rate, 0.0, energy)
		$PointLight2D.energy = clamp(energy * energy_left, 0.5, 100.0)
		$PointLight2D.texture_scale = clamp(energy_left, 0.25, 1.0)
		$Halo/CollisionShape2D.set_scale(Vector2(
				clamp(energy_left, 0.25, 1.0),
				clamp(energy_left, 0.25, 1.0)),
			)
		$PointLight2D.color = Color(
				color.r * clamp(energy_left, 0.1, 1.0),
				color.g * clamp(energy_left, 0.1, 1.0),
				color.b * clamp(energy_left, 0.1, 1.0),
				1,
			)
	if len(sources) > 0:
		print("source!!!")
		energy_left = clamp(energy_left + load_rate, 0.0, energy)
	logV()


