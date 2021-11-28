extends Panel

var almanac_holder = preload("res://actors/AlmanacHolder.tscn")

func _ready():
	Almanac.connect("word_added", self, "refresh")
	GameManager.connect("playername_added", self, "nameUpdate")
	$AlamanacLabel.text = GameManager.playerName + "'s " + "Almanac"
	rect_pivot_offset.x = rect_size.x / 2
	rect_pivot_offset.y = rect_size.y / 2


func nameUpdate():
	$AlamanacLabel.text = GameManager.playerName + "'s " + "Almanac"


func almanac_init():
	pass


func refresh():
	for child in $ScrollContainer/GridContainer.get_children():
		child.queue_free()
	
	for i in Almanac.dict["storage"].size():
		var holder = almanac_holder.instance()
		var string = Almanac.dict["storage"][i]
		var string1 = string[0]
		var string2 = string[1]
		
		holder.text = string1 + " - " + string2
		$ScrollContainer/GridContainer.add_child(holder)


func _on_Close_pressed():
	hide()
