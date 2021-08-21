extends Control

onready var cloudBig = $"ParallaxBackground/Cloud Big"
onready var cloudSmall = $"ParallaxBackground/Cloud Smol"

onready var masterBus = AudioServer.get_bus_index("Master")
onready var sfxBus = AudioServer.get_bus_index("SFX")

func _physics_process(delta):
	cloudBig.motion_offset.x += 3 * delta
	cloudSmall.motion_offset.x += 5 * delta


func _on_Play_pressed():
	$Click.play()
	yield($Click, "finished")
	GameManager.newGame()
	get_tree().change_scene("res://scenes/Level 1.tscn")


func _on_Quit_pressed():
	$Click.play()
	yield($Click, "finished")
	get_tree().quit()


func _on_Load_pressed():
	$Click.play()
	yield($Click, "finished")
	GameManager.loadGame()

# volume --------------------------------------
func _on_MasterSlider_value_changed(value):
	AudioServer.set_bus_volume_db(masterBus, linear2db(value))


func _on_SFXSlider_value_changed(value):
	AudioServer.set_bus_volume_db(sfxBus, linear2db(value))
# ---------------------------------------------


func _on_Settings_pressed():
	$Click.play()
	$SettingsPanel.show()


func _on_Close_pressed():
	$Click.play()
	$SettingsPanel.hide()


func _on_Leaderboard_pressed():
	$Click2.play()
	yield($Click2, "finished")
	get_tree().change_scene("res://addons/silent_wolf/Scores/Leaderboard.tscn")
