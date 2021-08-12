extends TouchScreenButton

var radius = Vector2(8, 8)
var boundary = 36

var drag = -1

var thres = 10
var accel = 20

func _process(delta):
	if drag == -1:
		var posDifference = (Vector2(0, 0) - radius) - position
		position += posDifference * accel * delta

func _input(event):
	if event is InputEventScreenDrag or (event is InputEventScreenTouch and event.is_pressed()):
		
		var eventFromCenter = (event.position - get_parent().global_position).length()
		
		if eventFromCenter <= boundary * global_scale.x or event.get_index() == drag:
			set_global_position(event.position - radius * global_scale)
			
			if getbuttonPos().length() > boundary:
				set_position(getbuttonPos().normalized() * boundary - radius)
			
			drag = event.get_index()
	
	if event is InputEventScreenTouch and !event.is_pressed() and event.get_index() == drag:
		drag = -1

func getbuttonPos():
	return position + radius

func getValue():
	if getbuttonPos().length() > thres:
		return getbuttonPos().normalized()
	
	return Vector2(0 ,0)
