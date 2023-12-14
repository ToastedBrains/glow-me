extends StaticBody2D


func _ready():
	$Phosphorescence.energy = 6.0
	$Phosphorescence.permanent = true
	$Phosphorescence.color = Color(0.843, 0.284, 0.094, 1)

func _process(_delta):
	pass


