extends Node
# SINGLETON ---------------------- !!

var currently_playing = null

func change_voice(key: String, index: int):
	if currently_playing != null:
		currently_playing.stop()
	
	var string = key + "_" + str(index)
	
	get_node(string).play()
	currently_playing = get_node(string)


# forces the currently playing voice over to stop
func force_stop_voice():
	currently_playing.stop()
