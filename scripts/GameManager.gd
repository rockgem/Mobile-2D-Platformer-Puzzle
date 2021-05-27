extends Node
# SINGLETON ----------------- !!

const SAVE_PATH = "user://save"
var savedGame = null

var isTutorialShown = false
var isIntroShown = false

var currentQuestion = null
var currentLevel = 1

var playerName = ""
var playerItems = [null, null, null, null]
var playerHP = 20
var playerHPMax = 20
var playerDamage = 30

func newGame():
	currentQuestion = null
	currentLevel = 1
	
	playerItems = [null, null, null, null]
	playerHP = 20
	playerHPMax = 20
	isTutorialShown = false
	isIntroShown = false
	get_tree().call_group("UIGroup", "hpUpdated")

func playerAnswered(answerRes):
	currentLevel += 1
	if answerRes == currentQuestion.correctAnswer:
		return true
#		get_tree().change_scene("res://scenes/Level %s.tscn" % str(currentLevel))
	else:
		return false
#		get_tree().change_scene("res://scenes/Level %s.tscn" % str(currentLevel))

func playerLoot(res):
	for i in playerItems.size():
		if playerItems[i] == null:
			playerItems[i] = res
			break
	
	get_tree().call_group("UIGroup", "updateItemDisplay")

func playerHeal(amount):
	playerHP += amount
	HealSfx.play()
	get_tree().call_group("UIGroup", "hpUpdated")

func newLevel():
	for i in range(0, GameManager.playerItems.size()):
		GameManager.playerItems[i] = null

func restartLevel():
	get_tree().change_scene("res://scenes/Level %s.tscn" % str(currentLevel))

func saveGame():
	var dir = Directory.new()
	if !dir.dir_exists(SAVE_PATH):
		dir.make_dir_recursive(SAVE_PATH)
	
	var file = File.new()
	if file.file_exists(SAVE_PATH + "/save1.tres"):
		print("existing file found!")
#		var existingData = ResourceLoader.load(SAVE_PATH + "/save1.tres")
		savedGame = Data.new()
		savedGame.currentLevel = currentLevel
		savedGame.hp = playerHP
		savedGame.isTutorialShown = isTutorialShown
		savedGame.isIntroShown = isIntroShown
		savedGame.playerItems = playerItems
		ResourceSaver.save(SAVE_PATH + "/save1.tres", savedGame)
	else:
		savedGame = Data.new()
		savedGame.currentLevel = currentLevel
		savedGame.hp = playerHP
		savedGame.isTutorialShown = isTutorialShown
		savedGame.isIntroShown = isIntroShown
		savedGame.playerItems = playerItems
		ResourceSaver.save(SAVE_PATH + "/save1.tres", savedGame)

func loadGame():
	var file = File.new()
	if file.file_exists(SAVE_PATH + "/save1.tres"):
		var existingData = ResourceLoader.load(SAVE_PATH + "/save1.tres")
		savedGame = existingData
		currentLevel = savedGame.currentLevel
		playerHP = savedGame.hp
		isTutorialShown = savedGame.isTutorialShown
		isIntroShown = savedGame.isIntroShown
		playerItems = savedGame.playerItems
		get_tree().change_scene("res://scenes/Level %s.tscn" % str(currentLevel))

func gameOver():
	get_tree().call_group("UIGroup", "showGameOver")


