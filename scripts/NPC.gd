extends KinematicBody2D
class_name NPC

enum NPC_TYPE{
	NORMAL,
	SHOP
}

export(NPC_TYPE) var npc_type
export(Resource) var shopData = null


func _ready():
	if shopData != null:
		for item in shopData.items:
			var holder = load("res://actors/ShopItem.tscn").instance()
			holder.initialize(item)
			
			$CanvasLayer/ShopUI/Panel/ScrollContainer/GridContainer.add_child(holder)


func showPopup():
	$Popup.show()
	$Popup/AnimationPlayer.play("throb")


func hidePopup():
	$Popup.hide()
	$Popup/AnimationPlayer.stop()


# gets called from player detect
func showShopUI():
	$CanvasLayer/ShopUI/Panel/AnimatedSprite.play()
	$CanvasLayer/ShopUI/Panel/AnimatedSprite/GoldLabel.text = str(GameManager.playerGold)
	$CanvasLayer/ShopUI.show()


func hideShopUI():
	$CanvasLayer/ShopUI/Panel/AnimatedSprite.stop()
	$CanvasLayer/ShopUI.hide()
	ShopManager.currentItemSelected = null


func showBuy():
	$CanvasLayer/ShopUI/Panel/Buy.show()


func hideBuy():
	$CanvasLayer/ShopUI/Panel/Buy.hide()


func _on_Close_pressed():
	$Click.play()
	hideShopUI()


func _on_Buy_pressed():
	var err = ShopManager.buy()
	
	if err == true:
		$Click.play()
		print("buy success")
		hideShopUI()
	else:
		$Error.play()
		print("buy failed")
