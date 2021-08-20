extends Control

var questionHolder = preload("res://actors/QuestionHolder.tscn")
var introDialogRes = load("res://resources/dialogs/IntroDialog.tres")
var tutorialDialogRes = load("res://resources/dialogs/TutorialDialog.tres")

var dialogIndex = 0

func _ready():
	PowerupManager.connect("gold_added", self, "goldUpdate")
	$HPPanel/HPBar.max_value = GameManager.playerHPMax
	$Score.text = "Score: " + str(GameManager.score)
	$AnimatedSprite/GoldLabel.text = str(GameManager.playerGold)


func goldUpdate():
	$AnimatedSprite/GoldLabel.text = str(GameManager.playerGold)


func showQuiz():
	$QuizPanel.show()
	$ItemsPanel.hide()
	$Sprite.hide()
	$Jump.hide()
	$Attack.hide()
	$HPPanel.hide()

func showQuizAnswerHolder():
	for i in range(0, GameManager.playerItems.size()):
		var invSlot = $ItemsPanel/ItemsGrid.get_child(i)
		for j in range(0, $QuizPanel/AnswersGrid.get_child_count()):
			var ansSlot = $QuizPanel/AnswersGrid.get_child(j)
			if invSlot.slotRes == ansSlot.answerRes:
				ansSlot.show()

func initQuiz():
	hpUpdated()
	resetQuiz()
	$QuizPanel/QuizQuestion.text = GameManager.currentQuestion.question[GameManager.currentQuestionIndex]
	for i in range(0, GameManager.currentQuestion.answers.size()):
		var newHolder = questionHolder.instance()
		#var tempAnsRes = GameManager.currentQuestion.answers[i]
		newHolder.newQuestion(i)
		newHolder.hide()
		$QuizPanel/AnswersGrid.add_child(newHolder)


func nextQuestion():
	$QuizPanel/QuizQuestion.text = GameManager.currentQuestion.question[GameManager.currentQuestionIndex]
	$Score.text = "Score: " + str(GameManager.score)

func resetQuiz():
	if $QuizPanel/AnswersGrid.get_child_count() > 0:
		for i in range(0, GameManager.currentQuestion.answers.size()):
			var prevHolder = $QuizPanel/AnswersGrid.get_child(i)
			prevHolder.queue_free()
			$QuizPanel/AnswersGrid.remove_child(prevHolder)

func _on_Close_pressed():
	$QuizPanel.hide()
	$ItemsPanel.show()
	$Sprite.show()
	$Jump.show()
	$Attack.show()
	$HPPanel.show()

func updateItemDisplay():
	for i in range(0, GameManager.playerItems.size()):
		var slot = $ItemsPanel/ItemsGrid.get_child(i)
		slot.displayItem(GameManager.playerItems[i])
	
	showQuizAnswerHolder()
	print("ui updated")

func hpUpdated():
	if !$HPPanel.visible:
		$HPPanel.show()
	
	$HPPanel/HPBar.max_value = GameManager.playerHPMax
	$HPPanel/HPBar.value = GameManager.playerHP
	

func showGameOver():
	$Sprite.hide()
	$Jump.hide()
	$Attack.hide()
	$ItemsPanel.hide()
	$AnimationPlayer.play("gameOverFade")

func showStoryDialog():
	if dialogIndex < introDialogRes.text.size() && !GameManager.isIntroShown:
		$StoryPanel.show()
		$StoryPanel/NextButton.show()
		var text = introDialogRes.text[dialogIndex]
		$StoryPanel/RichTextLabel.percent_visible = 0
		$StoryPanel/RichTextLabel.bbcode_text = text
		dialogIndex += 1
		$DialogCharTimer.start()
	else:
		$StoryPanel/NextButton.hide()
		$StoryPanel/CloseButton.show()
		GameManager.isIntroShown = true
		dialogIndex = 0

func showTutorial():
	if dialogIndex < tutorialDialogRes.text.size() && !GameManager.isTutorialShown:
		$TutorialPanel/NameLabel.text = GameManager.playerName
		var text = tutorialDialogRes.text[dialogIndex]
		$ItemsPanel.hide()
		$Sprite.hide()
		$Jump.hide()
		$Attack.hide()
		$TutorialPanel.show()
		$TutorialPanel/TutorialText.percent_visible = 0
		$TutorialPanel/TutorialText.bbcode_text = text
		dialogIndex += 1
		$TutorialPanel/TutorialCharTimer.start()
	else:
		$ItemsPanel.show()
		$Sprite.show()
		$Jump.show()
		$Attack.show()
		$TutorialPanel.hide()
		GameManager.isTutorialShown = true
		dialogIndex = 0

func showNamePrompt():
	if !GameManager.isTutorialShown:
		$NamePromptPanel.show()

func _on_Menu_pressed():
	SilentWolf.Scores.persist_score(GameManager.playerName, GameManager.score)
	get_tree().change_scene("res://addons/silent_wolf/Scores/Leaderboard.tscn")


func _on_DialogCharTimer_timeout():
	$StoryPanel/RichTextLabel.visible_characters += 1


func _on_CloseButton_pressed():
	$StoryPanel.hide()
	showNamePrompt()


func _on_TutorialCharTimer_timeout():
	$TutorialPanel/TutorialText.visible_characters += 1


func _on_TutorialPanel_gui_input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			showTutorial()


func _on_NextButton_pressed():
	showStoryDialog()


func _on_ConfirmationDialog_confirmed():
	GameManager.saveGame()
	get_tree().change_scene("res://scenes/MainMenu.tscn")


func _on_MainMenuButton_pressed():
	$ConfirmationDialog.popup()


func _on_OkButton_pressed():
	if $NamePromptPanel/NameEdit.text != "":
		GameManager.playerName = $NamePromptPanel/NameEdit.text
		GameManager.emit_signal("playername_added")
		$NamePromptPanel.hide()
		showTutorial()


func _on_Almanac_pressed():
	if !$AlmanacPanel.visible:
		$AlmanacPanel.show()
		$AnimationPlayer.play("almanacPop")
	else:
		$AlmanacPanel.hide()
