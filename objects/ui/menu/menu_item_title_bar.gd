@tool
extends HBoxContainer
const FONT_EN : FontFile = preload("res://fonts/breamcatcher rg.otf")
const FONT_ZH : FontFile = preload("res://fonts/NotoSansSC-Regular.ttf")

@export var title : String = "Menu Title" :
	set(value):
		title = value
		if has_node("Label"):
			$Label.text = tr(title)

var skip_cursor : bool = true

func refresh_text() -> void:
	$Label.text = tr(title)
	var is_zh : bool = TranslationServer.get_locale().begins_with("zh")
	$Label.add_theme_font_override("font", FONT_ZH if is_zh else FONT_EN)
	$Label.add_theme_font_size_override("font_size", 32 if is_zh else 44)

func _ready() -> void:
	refresh_text()
