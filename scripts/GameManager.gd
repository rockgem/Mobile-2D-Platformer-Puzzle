extends Node
# SINGLETON ----------------- !!

signal playername_added

const SAVE_PATH = "user://save"
var savedGame = null

var running = false

var isTutorialShown = false
var isIntroShown = false

var currentQuestion = null
var currentLevel = 1
var currentQuestionIndex = 0
var currentQuestionIndexMax = 0   # maximum number of questions (dynamic size based on how many questions there is)

var playerGold = 0
var playerName = ""
var playerItems = [null, null, null, null]
var playerHP = 20
var playerHPMax = 20
var playerDamage = 30

var score = 0

var isShopNear = false

func newGame():
	running = true
	currentQuestion = null
	currentLevel = 1
	
	playerGold = 0
	playerItems = [null, null, null, null]
	playerHP = 20
	playerHPMax = 20
	isTutorialShown = false
	isIntroShown = false
	get_tree().call_group("UIGroup", "hpUpdated")

# go to the next level
func advanceToLevel():
	currentLevel += 1
	currentQuestionIndex = 0
	get_tree().change_scene("res://scenes/Level %s.tscn" % str(GameManager.currentLevel))


func playerAnswered(answerRes):
	#currentLevel += 1
	if currentQuestionIndex < currentQuestion.correctAnswer.size():
		if answerRes == currentQuestion.correctAnswer[currentQuestionIndex]:
			currentQuestionIndex += 1
			score += 1
			return true
			#get_tree().change_scene("res://scenes/Level %s.tscn" % str(currentLevel))
		else:
			currentQuestionIndex += 1
			return false
			#get_tree().change_scene("res://scenes/Level %s.tscn" % str(currentLevel))
	else:
		return false


func playerLoot(res):
	for i in playerItems.size():
		if playerItems[i] == null:
			playerItems[i] = res
			Almanac.add(res.answerKey, res.meaning)
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
		savedGame.gold = playerGold
		savedGame.hp = playerHP
		savedGame.isTutorialShown = isTutorialShown
		savedGame.isIntroShown = isIntroShown
		savedGame.playerItems = playerItems
		savedGame.almanac = to_json(Almanac.dict)
		ResourceSaver.save(SAVE_PATH + "/save1.tres", savedGame)
	else:
		savedGame = Data.new()
		savedGame.currentLevel = currentLevel
		savedGame.gold = playerGold
		savedGame.hp = playerHP
		savedGame.isTutorialShown = isTutorialShown
		savedGame.isIntroShown = isIntroShown
		savedGame.playerItems = playerItems
		savedGame.almanac = Almanac.dict
		ResourceSaver.save(SAVE_PATH + "/save1.tres", savedGame)


func loadGame():
	var file = File.new()
	if file.file_exists(SAVE_PATH + "/save1.tres"):
		var existingData = ResourceLoader.load(SAVE_PATH + "/save1.tres")
		savedGame = existingData
		currentLevel = savedGame.currentLevel
		playerGold = savedGame.gold
		playerHP = savedGame.hp
		isTutorialShown = savedGame.isTutorialShown
		isIntroShown = savedGame.isIntroShown
		playerItems = savedGame.playerItems
		Almanac.dict = parse_json(savedGame.almanac)
		
		running = true
		get_tree().change_scene("res://scenes/Level %s.tscn" % str(currentLevel))


func gameOver():
	running = false
	get_tree().call_group("UIGroup", "showGameOver")


func changeBackground(player):
	if currentLevel == 1:
		return
	
	var skyColor = Color(currentLevel / 0.2, currentLevel / 0.2, currentLevel / 0.2)
	var bigCloud = Color(currentLevel / 4, currentLevel / 6, currentLevel / 4)
	var smallCloud = Color(currentLevel / 3, currentLevel / 5, currentLevel / 3)
	
	if currentLevel == 2:
		player.get_node("ParallaxBackground/Sky").modulate = Color(.98, .89, .89)
		player.get_node("ParallaxBackground/Big Cloud").modulate = Color(.89, .64, .64)
		player.get_node("ParallaxBackground/Small Cloud").modulate = Color(.90, .68, .68)
	elif currentLevel == 3:
		player.get_node("ParallaxBackground/Sky").modulate = Color(.98, .80, .80)
		player.get_node("ParallaxBackground/Big Cloud").modulate = Color(.89, .60, .60)
		player.get_node("ParallaxBackground/Small Cloud").modulate = Color(.90, .66, .66)
	elif currentLevel == 4:
		player.get_node("ParallaxBackground/Sky").modulate = Color(.98, .74, .74)
		player.get_node("ParallaxBackground/Big Cloud").modulate = Color(.89, .50, .50)
		player.get_node("ParallaxBackground/Small Cloud").modulate = Color(.90, .55, .55)
	elif currentLevel == 5:
		player.get_node("ParallaxBackground/Sky").modulate = Color(.98, .70, .70)
		player.get_node("ParallaxBackground/Big Cloud").modulate = Color(.92, .46, .46)
		player.get_node("ParallaxBackground/Small Cloud").modulate = Color(.94, .50, .50)



