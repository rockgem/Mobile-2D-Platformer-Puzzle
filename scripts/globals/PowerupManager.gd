extends Node
# SINGLETON --------------------- !!

signal gold_added

var rng = RandomNumberGenerator.new()
var timer = Timer.new()

var superJumpDuration = 10.0

func _ready():
	add_child(timer)
	timer.connect("timeout", self, "timerExpire")


func powerupLoot(type):
	rng.randomize()
	var randGold = rng.randi_range(1, 10)
	
	match(type):
		0: addGold(randGold)
		1: superJump()
		2: pass


func addGold(amount):
	GameManager.playerGold += amount
	emit_signal("gold_added")


func superJump():
	GlobalPlayer.jumpForce = 600
	GlobalPlayer.superJumpActive = true
	timer.start(superJumpDuration)


func timerExpire():
	GlobalPlayer.jumpForce = GlobalPlayer.defaultJumpForce
	GlobalPlayer.superJumpActive = false
