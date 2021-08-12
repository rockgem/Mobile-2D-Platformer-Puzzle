extends Panel

func _ready():
	Almanac.connect("word_added", self, "refresh")


func almanac_init():
	pass


func refresh():
	for child in $ScrollContainer/GridContainer.get_children():
		child.queue_free()
	
	for i in Almanac.dict["storage"].size():
		var lbl = Label.new()
		var string = Almanac.dict["storage"][i]
		var string1 = string[0]
		var string2 = string[1]
		
		lbl.text = string1 + " - " + string2
		$ScrollContainer/GridContainer.add_child(lbl)


func _on_Close_pressed():
	hide()
