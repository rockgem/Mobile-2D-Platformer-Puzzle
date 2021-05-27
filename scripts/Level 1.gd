extends Node2D

export(Resource) var levelQuestion

func _ready():
	GameManager.currentQuestion = levelQuestion
	get_tree().call_group("UIGroup", "initQuiz")
	for i in range(0, GameManager.playerItems.size()):
		GameManager.playerItems[i] = null
	
	get_tree().call_group("UIGroup", "showStoryDialog")
