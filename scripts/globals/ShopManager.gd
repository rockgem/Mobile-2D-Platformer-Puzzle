extends Node
# SINGLETON ----------------- !!


var currentItemSelected: Resource = null


func selected(itemRes: Resource):
	currentItemSelected = itemRes
	get_tree().call_group("NPCGroup", "showBuy")


func deselected():
	currentItemSelected = null
	get_tree().call_group("NPCGroup", "hideBuy")


func buy() -> bool:
	if GameManager.playerGold >= currentItemSelected.price:
		GameManager.playerGold -= currentItemSelected.price
		processBoughtItem()
		
		return true
	else:
		print("not enough gold")
		
		return false


func processBoughtItem():
	 GameManager.score += currentItemSelected.scoreAdd
