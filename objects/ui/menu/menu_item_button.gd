@tool
extends HBoxContainer
const FONT_EN : FontFile = preload("res://fonts/breamcatcher rg.otf")
const FONT_ZH : FontFile = preload("res://fonts/HiraginoSansGB.ttc")

@export var id : String

@export var title : String = "Button" :
	set(value):
		title = value
		if has_node("Label"):
			$Label.text = tr(title)

var skip_cursor : bool = false

func activate() -> void:
	get_parent()._on_button_pressed(id)
	#SoundController.play_sound("ui_menu_close" if id == "back" else "ui_confirm")

func increase() -> void:
	pass

func decrease() -> void:
	pass

func refresh_text() -> void:
	$Label.text = tr(title)
	var is_zh : bool = TranslationServer.get_locale().begins_with("zh")
	$Label.add_theme_font_override("font", FONT_ZH if is_zh else FONT_EN)
	$Label.add_theme_font_size_override("font_size", 34 if is_zh else 44)

func _ready() -> void:
	refresh_text()
