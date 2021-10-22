extends Panel

var itemsDir = "res://images/sprites/upgrades/"

export(String) var itemName = ""
export(String) var desc = ""

var res: Resource = null

func _ready():
	pass


func initialize(itemRes :Resource):
	res = itemRes
	$Label.text = itemRes.itemName + "\n" + itemRes.desc + "\n" + "Price: " + str(itemRes.price)
	$AnimatedSprite.frames = itemRes.spriteFrames
	
	$AnimatedSprite.play("default")


func _on_ShopItem_gui_input(event):
	if event is InputEventScreenTouch && event.is_pressed():
		$Click.play()
		ShopManager.selected(res)
