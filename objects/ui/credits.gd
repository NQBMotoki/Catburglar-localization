extends Control

const FONT_ZH : FontFile = preload("res://fonts/NotoSansSC-Regular.ttf")

func _ready() -> void:
	if Settings.is_chinese():
		for child in find_children("*", "Label", true, false):
			child.add_theme_font_override("font", FONT_ZH)
