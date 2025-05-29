extends Node

func changeColor(clonedTexture: TextureRect, layer: int) -> void:
	var newColor = getRandomColor()
	changePixelsInRange(newColor, clonedTexture, layer)
	print('it worked!', newColor)
	
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
			image.set_pixel(i, j, newColor)
	image_texture.update(image)
