extends RigidBody2D

enum TYPE{
	GOLDCOIN,
	GOLDSKULL,
	REDPOTION
}

export(TYPE) var type = TYPE.GOLDSKULL


func _ready():
	match(type):
		TYPE.GOLDSKULL: $AnimatedSprite.play("goldSkull")
		TYPE.GOLDCOIN: $AnimatedSprite.play("goldCoin")
		TYPE.REDPOTION: $AnimatedSprite.play("redPotion")
