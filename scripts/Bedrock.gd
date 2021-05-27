extends Area2D



func _on_Bedrock_body_entered(body):
	GameManager.restartLevel()
