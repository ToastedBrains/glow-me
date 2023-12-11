extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	
	$Phosphorescence.min_energy = 2.0
	$Phosphorescence.max_energy = 2.0
	$Phosphorescence.load_rate = 0.002
	$Phosphorescence.color = Color(0.743, 0.484, 0.094, 1)
	$Phosphorescence.change_state(3)
	
	#@onready var energy = 2.0
#@onready var min_energy = 0.5
#@onready var max_energy = 2.0
#@onready var max_load = 2.0
#@onready var load_rate = 0.005
#@onready var unload_rate = 0.001
#@onready var min_radius = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


