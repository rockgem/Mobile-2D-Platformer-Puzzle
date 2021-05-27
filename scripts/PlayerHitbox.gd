extends Area2D


func _ready():
	$CollisionShape2D.disabled = true

func enabled():
	$CollisionShape2D.disabled = false

func disabled():
	$CollisionShape2D.disabled = true
