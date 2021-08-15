extends Node
# SINGLETON ------------------- !!

signal word_added

var dict = {
	"storage": []
}


func add(word, meaning):
	if !isWordExists(word):
		var arr = [word, meaning]
		dict["storage"].append(arr)
		emit_signal("word_added")
	else:
		print("word exists!")


func isWordExists(word):
	for thisWord in dict["storage"]:
		if word == thisWord[0]:
			return true
	
	return false
