extends Control

var questionHolder = preload("res://actors/QuestionHolder.tscn")
var introDialogRes = preload("res://resources/dialogs/IntroDialog.tres")
var tutorialDialogRes = preload("res://resources/dialogs/TutorialDialog.tres")

var level1Dialog = preload("res://resources/dialogs/Level1Dialog.tres")
var level2Dialog = preload("res://resources/dialogs/Level2Dialog.tres")
var level3Dialog = preload("res://resources/dialogs/Level3Dialog.tres")
var level4Dialog = preload("res://resources/dialogs/Level4Dialog.tres")

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


func updateScoreDisplay():
	$Score.text = "Score: " + str(GameManager.score)
	$AnimatedSprite/GoldLabel.text = str(GameManager.playerGold)


func nextQuestion():
	$QuizPanel/QuizQuestion.text = GameManager.currentQuestion.question[GameManager.currentQuestionIndex]
	$Score.text = "Score: " + str(GameManager.score)


func resetQuiz():
	if $QuizPanel/AnswersGrid.get_child_count() > 0:
		for i in range(0, GameManager.currentQuestion.answers.size()):
			var prevHolder = $QuizPanel/AnswersGrid.get_child(i)
			prevHolder.queue_free()
#			$QuizPanel/AnswersGrid.remove_child(prevHolder)

func _on_Close_pressed():
	$Click.play()
	
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

func showStoryDialog(is_intro: bool = false):
	var current_story
	var key : String
	# may story offset since every level dialog only appears at the end of the level
	# di ko na ma fix structure neto eh spaghetti na yung code sa dami ng revisions HAHAHAHAHAHAH
	match(GameManager.currentLevel):
		1: 
			current_story = level1Dialog
			key = "Level1"
		2: 
			current_story = level1Dialog
			key = "Level1"
		3: 
			current_story = level2Dialog
			key = "Level2"
		4: 
			current_story = level3Dialog
			key = "Level3"
		5: 
			current_story = level4Dialog
			key = "Level4"
	
	if is_intro:
		GameManager.isIntroShown = true
		current_story = introDialogRes
		key = "Intro"
	
	if GameManager.isIntroShown:
		current_story = introDialogRes
		key = "Intro"
	
	if dialogIndex < current_story.text.size():
		$StoryPanel.show()
		$StoryPanel/NextButton.show()
		var text = current_story.text[dialogIndex]
		$StoryPanel/RichTextLabel.percent_visible = 0
		$StoryPanel/RichTextLabel.bbcode_text = "[center]" + text + "[/center]"
		VoiceOverScene.change_voice(key, dialogIndex)
		dialogIndex += 1
		$DialogCharTimer.start()
	else:
		$StoryPanel/NextButton.hide()
#		$StoryPanel/CloseButton.show()
		$StoryPanel.hide()
		VoiceOverScene.force_stop_voice()
		showNamePrompt()
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
		dialogIndex = 0 # clear dialog index first before calling showStory again or it will not show up
#		showStoryDialog(false)

func showNamePrompt():
	if !GameManager.isTutorialShown:
		$NamePromptPanel.show()

func _on_Menu_pressed():
	$Click.play()
	yield($Click, "finished")
	SilentWolf.Scores.persist_score(GameManager.playerName, GameManager.score)
	get_tree().change_scene("res://addons/silent_wolf/Scores/Leaderboard.tscn")


func _on_DialogCharTimer_timeout():
	$StoryPanel/RichTextLabel.visible_characters += 1


func _on_CloseButton_pressed():
	$StoryPanel.hide()
	dialogIndex = 0
	showNamePrompt()


func _on_TutorialCharTimer_timeout():
	$TutorialPanel/TutorialText.visible_characters += 1


func _on_TutorialPanel_gui_input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			$Click.play()
			showTutorial()


func _on_NextButton_pressed():
	showStoryDialog()


func _on_ConfirmationDialog_confirmed():
	GameManager.saveGame()
	get_tree().change_scene("res://scenes/MainMenu.tscn")


func _on_MainMenuButton_pressed():
	$Click.play()
	$ConfirmationDialog.popup()


func _on_OkButton_pressed():
	if $NamePromptPanel/NameEdit.text != "":
		$Click.play()
		GameManager.playerName = $NamePromptPanel/NameEdit.text
		GameManager.emit_signal("playername_added")
		$NamePromptPanel.hide()
		showTutorial()
	else:
		$Error.play()


func _on_Almanac_pressed():
	if !$AlmanacPanel.visible:
		$AlmanacPanel.show()
		$Click.play()
		$AnimationPlayer.play("almanacPop")
	else:
		$AlmanacPanel.hide()
