extends Control

onready var httpRequest = $HTTPRequest


func _ready():
	pass


func displayScores():
	print(SilentWolf.Scores.scores.size())
	for i in SilentWolf.Scores.scores.size():
#		$Leaderboard/ItemList.add_item(SilentWolf.Scores.scores[i])
		print(SilentWolf.Scores.scores[i])
