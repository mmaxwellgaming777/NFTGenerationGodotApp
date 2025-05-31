extends Node2D

@onready var upload_file_dialog = $FileDialog
@onready var og_texture_rect = $OgTextureRect
@onready var cloned_texture_rect = $ClonedTextureRect
@onready var color_change_module = $ColorChangeModule
@onready var nft_container = $NFTContainer
@onready var nft_collection_name = $NFTCollectionName
@onready var save_dialog = $SaveDialog

var NFTLayer = 0
var NFTCount = 1

func _ready():
	upload_file_dialog.file_mode = FileDialog.ACCESS_FILESYSTEM
	upload_file_dialog.access = FileDialog.FILE_MODE_OPEN_FILE
	upload_file_dialog.use_native_dialog = true
	upload_file_dialog.current_dir = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS)
	#upload_file_dialog.filters = ["*.png ; PNG Images", "*.jpg ; JPEG Images", "*.jpeg ; JPEG Images"]
	upload_file_dialog.filters = ["*.png ; PNG Images"]
	upload_file_dialog.connect("file_selected", _on_file_selected)
	
	save_dialog.access = FileDialog.FILE_MODE_OPEN_DIR
	save_dialog.file_mode = FileDialog.ACCESS_FILESYSTEM
	save_dialog.use_native_dialog = true
	save_dialog.current_dir = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS)
	save_dialog.title = "Choose a folder to save files into"
	#save_dialog.filters = ["*.* ; Any File"]
	#save_dialog.current_dir = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS)
	save_dialog.connect("file_selected", _on_save_path_chosen)
	

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
	upload_file_dialog.popup_centered()
	
func _on_save_path_chosen(path: String) -> void:
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
	
	if textureRect.texture is Texture2D:
		var imageToSave: Image = textureRect.texture.get_image()
		if image:
			var error1 = imageToSave.save_png(path + nft_collection_name.text + ".png")
			if error == OK:
				print("Image saved to: ", path)
			else:
				push_error("Failed to save image. Error code: %d" % error)
		else:
			push_error("Couldn't get image from texture.")
	else:
		push_error("Texture is not a Texture2D.")
	
func shrink_texture(texture: Texture2D, scale: float) -> Texture2D:
	var img := texture.get_image()
	var new_size := img.get_size() * scale
	img.resize(new_size.x, new_size.y, Image.INTERPOLATE_LANCZOS)
	return ImageTexture.create_from_image(img)


func _on_clone_button_pressed() -> void:
	save_dialog.popup_centered()
