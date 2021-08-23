extends KinematicBody2D
class_name NPC

enum NPC_TYPE{
	NORMAL,
	SHOP
}


export(NPC_TYPE) var npc_type

func showPopup():
	$Popup.show()
	$Popup/AnimationPlayer.play("throb")


func hidePopup():
	$Popup.hide()
	$Popup/AnimationPlayer.stop()


# gets called from player detect
func showShopUI():
	$CanvasLayer/ShopUI.show()


func hideShopUI():
	$CanvasLayer/ShopUI.hide()


func _on_Close_pressed():
	$CanvasLayer/ShopUI.hide()
