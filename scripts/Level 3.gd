extends Node2D

export(Resource) var levelQuestion

func _ready():
	GameManager.currentQuestion = levelQuestion
	GameManager.currentQuestionIndexMax = GameManager.currentQuestion.question.size()
	get_tree().call_group("UIGroup", "initQuiz")
	GameManager.newLevel()
	
