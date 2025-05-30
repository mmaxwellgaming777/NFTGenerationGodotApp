extends Node

func changeColor(clonedTexture: TextureRect, layer: int) -> void:
	var newColor = getRandomColor()
	changePixelsInRange(newColor, clonedTexture, layer)
	
func getRandomColor() -> Color:
	var r = randf_range(0, 1.0)
	var g = randf_range(0, 1.0)
	var b = randf_range(0, 1.0)
	
	return Color(r, g, b, 1)
	
func changePixelsInRange(newColor: Color, clonedTexture: TextureRect, layer: int) -> void:
	var image_texture = clonedTexture.texture as ImageTexture
	var image = image_texture.get_image()
	for i in image.get_width():
		for j in image.get_height():
			if is_dark(image.get_pixel(i, j)):
				continue
			image.set_pixel(i, j, newColor)
	image_texture.update(image)
	
#func is_near_black(color: Color, threshold: float = 0.1) -> bool:
	#return color.r < threshold and color.g < threshold and color.b < threshold
	
func is_dark(color: Color, gray_threshold: float = 0.1) -> bool:
	return color_to_grayscale(color) < gray_threshold

func color_to_grayscale(color: Color) -> float:
	return 0.299 * color.r + 0.587 * color.g + 0.114 * color.b
