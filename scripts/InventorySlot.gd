extends Panel

var slotRes

func displayItem(res):
	if res != null:
		slotRes = res
		$TextureRect.texture = res.texture
	else:
		slotRes = null
