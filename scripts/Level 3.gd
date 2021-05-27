extends Node2D

export(Resource) var levelQuestion

func _ready():
	GameManager.currentQuestion = levelQuestion
	get_tree().call_group("UIGroup", "initQuiz")
	GameManager.newLevel()
	
