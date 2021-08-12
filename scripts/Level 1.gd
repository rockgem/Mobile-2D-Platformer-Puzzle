extends Node2D

export(Resource) var levelQuestion

onready var player = $Player

func _ready():
	GameManager.currentQuestion = levelQuestion
	GameManager.currentQuestionIndexMax = GameManager.currentQuestion.question.size()
	get_tree().call_group("UIGroup", "initQuiz")
	GameManager.newLevel()
	
	if GameManager.currentLevel == 1:
		GameManager.score = 0
		get_tree().call_group("UIGroup", "showStoryDialog")
	
	GameManager.changeBackground(player)
	
	Almanac.emit_signal("word_added")
