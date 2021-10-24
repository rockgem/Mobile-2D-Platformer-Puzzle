extends KinematicBody2D

onready var joystick = get_parent().get_node("CanvasLayer/UI//Sprite/Joystick")
var projectile = preload("res://actors/SwordProjectile.tscn")

var jumping = false
var walking = false
var attacking = false
var beingHit = false

var dirRight = true

var npcBodyRef = null

func _ready():
	pass

func _process(delta):
	pass
	

func _physics_process(delta):
	
	if walking && !$Footstep.playing && !jumping:
		$Footstep.play()
	
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
		walking = true
	elif GlobalPlayer.velocity.x < 0 && !attacking && !beingHit:
		$AttackPivot.rotation =  deg2rad(180)
		$AnimatedSprite.flip_h = true
		$AnimatedSprite.play("run")
		walking = true
	elif !attacking && !beingHit:
		$AnimatedSprite.play("idle")
		walking = false
	
	# player movement handler with keyboard
	#GlobalPlayer.velocity = move_and_slide(GlobalPlayer.velocity)


func _input(event):
	if GameManager.isShopNear && Input.is_action_just_pressed("ui_attack"):
#		get_tree().call_group("NPCGroup", "showShopUI")
		npcBodyRef.showShopUI()
		return
	
	if Input.is_action_just_pressed("ui_attack"):
		attack()


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
#	var distance_between = enemy.global_position.direction_to(global_position)
#	print(distance_between)
#
#	if distance_between.x < 0.5:
#		$Tween.interpolate_property(self, "global_position", global_position, Vector2(global_position.x - 80, global_position.y), 0.3, Tween.TRANS_LINEAR,Tween.EASE_OUT)
#		$Tween.start()
#	elif distance_between.x > 0.5:
#		$Tween.interpolate_property(self, "global_position", global_position, Vector2(global_position.x + 80, global_position.y), 0.3, Tween.TRANS_LINEAR,Tween.EASE_OUT)
#		$Tween.start()
	
	
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


func _on_PlayerDetection_body_entered(body):
	if body is NPC:
		# if npc is normal npc
		if body.npc_type == 0:
			pass
		# if npc is shop npc
		elif body.npc_type == 1:
			GameManager.isShopNear = true
			npcBodyRef = body
			body.showPopup()


func _on_PlayerDetection_body_exited(body):
	if body is NPC:
		# if npc is normal npc
		if body.npc_type == 0:
			pass
		# if npc is shop npc
		elif body.npc_type == 1:
			GameManager.isShopNear = false
			body.hidePopup()
			body.hideShopUI()
			npcBodyRef = null
#			get_tree().call_group("NPCGroup", "hideShopUI")
