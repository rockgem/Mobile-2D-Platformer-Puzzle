extends Node
# SINGLETON ------------------- !!

signal word_added

var dict = {
	"storage": []
}


func add(word, meaning):
	var arr = [word, meaning]
	dict["storage"].append(arr)
	emit_signal("word_added")
	print(dict)

