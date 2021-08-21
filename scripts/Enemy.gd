extends KinematicBody2D

var velocity = Vector2.ZERO
var moveSpeed = 50
var gravity = 1200

export(bool) var canHeal = false
export(Resource) var answerKey = null
export(int) var hp = 20
export(int) var damage = 1

var playerBody = null
var beingHit = false
var attacking = false

func _physics_process(delta):
	
	velocity.y = gravity * delta
	
	if playerBody != null:
		var velBetween = (playerBody.global_position - global_position).normalized()
		velocity = velocity.move_toward(velBetween, moveSpeed * delta)
	else:
		velocity.x = 0
	
	if velocity.x > 0 && !beingHit && !attacking:
		$AnimatedSprite.flip_h = true
		$AnimatedSprite.play("run")
	elif velocity.x < 0 && !beingHit && !attacking:
		$AnimatedSprite.flip_h = false
		$AnimatedSprite.play("run")
	elif !beingHit && !attacking:
		velocity.x = 0
		$AnimatedSprite.play("idle")
	
	velocity = velocity.normalized()
	velocity = move_and_slide(velocity * moveSpeed)

func attack():
	if !attacking:
		attacking = true
		$AnimatedSprite.play("attack")
		yield($AnimatedSprite,"animation_finished")
		$AnimatedSprite.play("idle")
		attacking = false
		$EnemyHitbox/CollisionShape2D.disabled = true
		$AttackCooldwn.start()
		

func hit():
	if !beingHit:
		$Hit.play()
		beingHit = true
		hp -= GameManager.playerDamage
		$AnimatedSprite.play("hit")
		yield($AnimatedSprite, "animation_finished")
		beingHit = false
		if hp <= 0:
			enemyDrop()
			queue_free()

# an item scene gets created after death
func enemyDrop():
	if canHeal:
		GameManager.playerHeal(3)
	
	if answerKey != null:
		var itemDrop = load("res://actors/ItemDrop.tscn").instance()
		itemDrop.setItemDisplay(answerKey)
		itemDrop.position = global_position
		owner.add_child(itemDrop)

func _on_EnemyDetection_body_entered(body):
	playerBody = body

# if player attacks
func _on_EnemyHurtbox_area_entered(area):
	hit()

# if player touches enemy
func _on_EnemyHitbox_area_entered(area):
	if GameManager.running:
		attack()

func _on_EnemyDetection_body_exited(body):
	playerBody = null

func _on_AttackCooldwn_timeout():
	$EnemyHitbox/CollisionShape2D.disabled = false
