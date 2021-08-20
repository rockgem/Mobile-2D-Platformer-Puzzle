extends KinematicBody2D

onready var joystick = get_parent().get_node("CanvasLayer/UI//Sprite/Joystick")
var projectile = preload("res://actors/SwordProjectile.tscn")

var jumping = false
var attacking = false
var beingHit = false

var dirRight = true

func _ready():
	pass

func _process(delta):
	
	if Input.is_action_just_pressed("ui_attack"):
		attack()

func _physics_process(delta):
	
	if GlobalPlayer.velocity.y != 0:
		jumping = true
	else:
		jumping = false
	
	GlobalPlayer.velocity.y += GlobalPlayer.gravity * delta
	
	# movement for pc version
	# to be able to move the player with keyboard, i-comment out mo lang po
	# ung nasa ibaba na one-line code for mobile version tas ung
	# nasa pinaka ibaba na one line code rin paki erase nung comment
	if Input.is_action_just_pressed("ui_up") && !jumping:
		GlobalPlayer.velocity.y = -GlobalPlayer.jumpForce
		if GlobalPlayer.superJumpActive:
			$Particles2D.emitting = true
	elif Input.is_action_pressed("ui_right"):
		GlobalPlayer.velocity.x = GlobalPlayer.moveSpeed
	elif Input.is_action_pressed("ui_left"):
		GlobalPlayer.velocity.x = -GlobalPlayer.moveSpeed
	else:
		GlobalPlayer.velocity.x = 0
	
	# movement for mobile version
	GlobalPlayer.velocity = move_and_slide(Vector2(joystick.getValue().x * GlobalPlayer.moveSpeed, GlobalPlayer.velocity.y))
	
	if GlobalPlayer.velocity.x > 0 && !attacking && !beingHit:
		$AttackPivot.rotation = 0
		$AnimatedSprite.flip_h = false
		$AnimatedSprite.play("run")
	elif GlobalPlayer.velocity.x < 0 && !attacking && !beingHit:
		$AttackPivot.rotation =  deg2rad(180)
		$AnimatedSprite.flip_h = true
		$AnimatedSprite.play("run")
	elif !attacking && !beingHit:
		$AnimatedSprite.play("idle")
	
	# player movement handler with keyboard
#	velocity = move_and_slide(velocity)

func attack():
	if !attacking:
		$Slash.play()
		attacking = true
		$AttackPivot/PlayerHitbox/CollisionShape2D.disabled = false
		$AnimatedSprite.play("attack")
		yield($AnimatedSprite, "animation_finished")
		$AnimatedSprite.play("idle")
		$AttackPivot/PlayerHitbox/CollisionShape2D.disabled = true
		attacking = false

func hit(enemy):
	if !beingHit:
		$Hit.play()
		beingHit = true
		$AnimatedSprite.play("hit")
		# damage taken from player is from enemy's damage pero for now,
		# ung damage ng enemy is 1 lang
		GameManager.playerHP -= enemy.damage
		get_tree().call_group("UIGroup", "hpUpdated")
		if GameManager.playerHP <= 0:
			GameManager.gameOver()
		yield($AnimatedSprite, "animation_finished")
		beingHit = false

func _on_PlayerDetection_area_entered(area):
	pass


func _on_PlayerHurtbox_area_entered(area):
	var enemy = area.owner
	hit(enemy)


func _on_BedrockDetect_area_entered(area):
	GameManager.restartLevel()


func _on_PlayerHurtbox_body_entered(body):
	if body is RigidBody2D:
		$Powerup.play()
		PowerupManager.powerupLoot(body.type)
		body.get_node("AnimatedSprite").hide()
		
		match(body.type):
			0: body.get_node("Effects").play("goldCoinEffect")
			1: body.get_node("Effects").play("skullEffect")
			3: body.get_node("Effects").play("potionEffect")
		
		yield(body.get_node("Effects"), "animation_finished")
		body.queue_free()
