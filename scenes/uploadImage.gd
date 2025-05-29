extends Node2D

@onready var file_dialog = $FileDialog
@onready var og_texture_rect = $OgTextureRect
@onready var cloned_texture_rect = $ClonedTextureRect
@onready var color_change_module = $ColorChangeModule
@onready var nft_container = $NFTContainer

var NFTLayer = 0
var NFTCount = 1

func _ready():
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	file_dialog.filters = ["*.png ; PNG Images", "*.jpg ; JPEG Images", "*.jpeg ; JPEG Images"]
	file_dialog.connect("file_selected", _on_file_selected)
	

func _on_file_selected(path):
	var image = Image.new()
	var error = image.load(path)
	if error == OK:
		var save_path = "user://NFTLayer%d.png" % NFTLayer
		NFTLayer += 1
		image.save_png(save_path)
		print("Saved to", save_path)
		var texture = ImageTexture.create_from_image(image)
		og_texture_rect.texture = texture
	else:
		print("Failed to load image:", error)


func _on_upload_button_pressed() -> void:
	file_dialog.popup_centered()

func _on_clone_button_pressed() -> void:
	var image = Image.new()
	var error = image.load("user://NFTLayer%d.png" % NFTLayer)
	var textureRect = TextureRect.new()
	textureRect.name = "NFT%d" % NFTCount
	NFTCount += 1
	nft_container.add_child(textureRect)
	if error != OK:
		print("Failed to load image:", error)
		return
	
	var texture = ImageTexture.create_from_image(image)
	textureRect.texture = texture
	color_change_module.changeColor(textureRect, NFTLayer)
	textureRect.texture = shrink_texture(textureRect.texture, 0.5)
	
func shrink_texture(texture: Texture2D, scale: float) -> Texture2D:
	var img := texture.get_image()
	var new_size := img.get_size() * scale
	img.resize(new_size.x, new_size.y, Image.INTERPOLATE_LANCZOS)
	return ImageTexture.create_from_image(img)
