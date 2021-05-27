extends KinematicBody2D

onready var joystick = get_parent().get_node("CanvasLayer/UI//Sprite/Joystick")
var projectile = preload("res://actors/SwordProjectile.tscn")

var velocity = Vector2.ZERO
var moveSpeed = 100
var gravity = 600
var jumpForce = 300

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
	
	if velocity.y != 0:
		jumping = true
	else:
		jumping = false
	
	velocity.y += gravity * delta
	
	# movement for pc version
	# to be able to move the player with keyboard, i-comment out mo lang po
	# ung nasa ibaba na one-line code for mobile version tas ung
	# nasa pinaka ibaba na one line code rin paki erase nung comment
	if Input.is_action_just_pressed("ui_up") && !jumping:
		velocity.y = -jumpForce
	elif Input.is_action_pressed("ui_right"):
		velocity.x = moveSpeed
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -moveSpeed
	else:
		velocity.x = 0
	
	# movement for mobile version
	velocity = move_and_slide(Vector2(joystick.getValue().x * moveSpeed, velocity.y))
	
	if velocity.x > 0 && !attacking && !beingHit:
		$AttackPivot.rotation = 0
		$AnimatedSprite.flip_h = false
		$AnimatedSprite.play("run")
	elif velocity.x < 0 && !attacking && !beingHit:
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
