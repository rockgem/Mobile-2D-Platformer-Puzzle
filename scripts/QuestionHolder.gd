extends Panel

var answerRes = null

func newQuestion(index):
	var res = GameManager.currentQuestion.answers[index]
	answerRes = res
	$TextureRect.texture = res.texture
	$Label.text = res.answerKey

func _on_QuestionHolder_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			var isCorrect = GameManager.playerAnswered(answerRes)
			if isCorrect:
				$AnimationPlayer.play("correctAnswerAnimate")
				yield($AnimationPlayer,"animation_finished")
#				get_tree().change_scene("res://scenes/Level %s.tscn" % str(GameManager.currentLevel))
				
			else:
				$AnimationPlayer.play("wrongAnswerAnimate")
				yield($AnimationPlayer,"animation_finished")
#				get_tree().change_scene("res://scenes/Level %s.tscn" % str(GameManager.currentLevel))
			
			if GameManager.currentQuestionIndex < GameManager.currentQuestionIndexMax:
				get_tree().call_group("UIGroup", "nextQuestion")
			else:
				GameManager.advanceToLevel()
