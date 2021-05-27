extends KinematicBody2D

var velocity = Vector2.ZERO
var gravity = 100

var resCopy


# THIS SCENE IS ONLY INSTANCIATED AT AN ENEMY SCENE WHEN IT DIES ---- !!


func setItemDisplay(res):
	resCopy = res
	$TextureRect.texture = res.texture
	$Label.text = res.answerKey

func _physics_process(delta):
	
	velocity.y += gravity * delta
	
	velocity = move_and_slide(velocity)


func _on_Area2D_area_entered(area):
	GameManager.playerLoot(resCopy)
	queue_free()
