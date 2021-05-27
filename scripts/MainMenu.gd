extends Control

onready var cloudBig = $"ParallaxBackground/Cloud Big"
onready var cloudSmall = $"ParallaxBackground/Cloud Smol"

func _physics_process(delta):
	cloudBig.motion_offset.x += 3 * delta
	cloudSmall.motion_offset.x += 5 * delta


func _on_Play_pressed():
	GameManager.newGame()
	get_tree().change_scene("res://scenes/Level 1.tscn")


func _on_Quit_pressed():
	get_tree().quit()


func _on_Load_pressed():
	GameManager.loadGame()
