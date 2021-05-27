extends Area2D

var directionRight = true

var maxLifetime = 2.0
var tick = 0.0

func _ready():
	print("spawned!")

func spawn():
	pass

func _physics_process(delta):
	tick += delta
	
	if tick >= maxLifetime:
		print("gone.")
		queue_free()
