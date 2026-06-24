@tool
extends HBoxContainer
const FONT_EN : FontFile = preload("res://fonts/breamcatcher rg.otf")
const FONT_ZH : FontFile = preload("res://fonts/NotoSansSC-Regular.ttf")

@export var id : String

@export var title : String = "Menu Title" :
	set(value):
		title = value
		if has_node("Label"):
			$Label.text = tr(title)

@export var values : Array[String] :
	set(value):
		values = value
		if has_node("Value") and len(values) > 0:
			$Value.text = tr(values[0])

var skip_cursor : bool = false

var selection : int = 0

func refresh_text() -> void:
	$Label.text = tr(title)
	$Value.text = tr(values[selection])
	var is_zh : bool = TranslationServer.get_locale().begins_with("zh")
	$Label.add_theme_font_override("font", FONT_ZH if is_zh else FONT_EN)
	$Value.add_theme_font_override("font", FONT_ZH if is_zh else FONT_EN)
	$Label.add_theme_font_size_override("font_size", 30 if is_zh else 44)
	$Value.add_theme_font_size_override("font_size", 30 if is_zh else 44)

func activate() -> void:
	pass

func increase() -> void:
	selection = wrapi(selection + 1, 0, len(values))
	$Value.text = tr(values[selection])
	Settings.set_selector_setting(id, selection)

func decrease() -> void:
	selection = wrapi(selection - 1, 0, len(values))
	$Value.text = tr(values[selection])
	Settings.set_selector_setting(id, selection)

func _ready() -> void:
	selection = Settings.get_selector_setting(id)
	refresh_text()
