extends Node2D

@onready var file_dialog = $FileDialog
@onready var og_texture_rect = $OgTextureRect
@onready var cloned_texture_rect = $ClonedTextureRect

func _ready():
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	file_dialog.filters = ["*.png ; PNG Images", "*.jpg ; JPEG Images", "*.jpeg ; JPEG Images"]
	file_dialog.connect("file_selected", _on_file_selected)
	

func _on_file_selected(path):
	var image = Image.new()
	var error = image.load(path)
	if error == OK:
		var texture = ImageTexture.create_from_image(image)
		og_texture_rect.texture = texture
	else:
		print("Failed to load image:", error)


func _on_upload_button_pressed() -> void:
	file_dialog.popup_centered()

func _on_clone_button_pressed() -> void:
	cloned_texture_rect.texture = $OgTextureRect.texture
