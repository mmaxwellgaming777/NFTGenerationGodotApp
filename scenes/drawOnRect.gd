extends Node2D

var zoom: float = 1.0
var image
var selected_color = Color(1, 0, 0, 1)

func _ready():
	image = Image.create(250, 250, false, Image.FORMAT_RGBA8)
	image.fill(Color(1, 1, 1, 1))  # transparent
	var texture = ImageTexture.create_from_image(image)
	$Sprite2D.texture = texture
	

#func _input(event):
	#if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		#var local_pos = $Sprite2D.to_local(event.position)
#
		## Account for zoom and convert to image pixel coordinates
		#var pixel_x = int(local_pos.x / zoom)
		#var pixel_y = int(local_pos.y / zoom)
#
		## Bounds check to avoid crashing
		#if pixel_x >= 0 and pixel_x < image.get_width() and pixel_y >= 0 and pixel_y < image.get_height():
			#image.set_pixel(pixel_x, pixel_y, selected_color)
			#$Sprite2D.texture = ImageTexture.create_from_image(image)

var last_pixel_pos: Vector2 = Vector2(-1, -1)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var local_pos = $Sprite2D.to_local(event.position)
			var pixel_x = int(local_pos.x / zoom)
			var pixel_y = int(local_pos.y / zoom)
			last_pixel_pos = Vector2(pixel_x, pixel_y)

	elif event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var local_pos = $Sprite2D.to_local(event.position)
		var pixel_x = int(local_pos.x / zoom)
		var pixel_y = int(local_pos.y / zoom)

		var current_pos = Vector2(pixel_x, pixel_y)
		if last_pixel_pos != Vector2(-1, -1):
			draw_line_on_image(image, last_pixel_pos.x, last_pixel_pos.y, current_pos.x, current_pos.y, selected_color)
			$Sprite2D.texture = ImageTexture.create_from_image(image)

		last_pixel_pos = current_pos

func draw_line_on_image(img: Image, x0: int, y0: int, x1: int, y1: int, color: Color):
	var dx = abs(x1 - x0)
	var dy = abs(y1 - y0)
	var sx = 0
	var sy = 0
	var err = dx - dy
	
	if x0 < x1: 
		sx = 1 
	else: 
		sx = -1
		
	if y0 < y1: 
		sy = 1 
	else: 
		sy = -1

	while true:
		if x0 >= 0 and x0 < img.get_width() and y0 >= 0 and y0 < img.get_height():
			img.set_pixel(x0, y0, color)

		if x0 == x1 and y0 == y1:
			break

		var e2 = 2 * err
		if e2 > -dy:
			err -= dy
			x0 += sx
		if e2 < dx:
			err += dx
			y0 += sy
