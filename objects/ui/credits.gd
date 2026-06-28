extends Control

const FONT_EN : FontFile = preload("res://fonts/CaviarDreams.ttf")
const FONT_EN_BOLD : FontFile = preload("res://fonts/CaviarDreams_Bold.ttf")
const FONT_ZH : FontFile = preload("res://fonts/NotoSansSC-Regular.ttf")
const FONT_ZH_BOLD : FontFile = preload("res://fonts/NotoSansSC-Bold.ttf")

func _ready() -> void:
	_apply_locale_style()
	Settings.language_changed.connect(_on_language_changed)

func _on_language_changed() -> void:
	_apply_locale_style()

func _apply_locale_style() -> void:
	var is_zh : bool = Settings.is_chinese()
	var active_regular : FontFile = FONT_ZH if is_zh else FONT_EN
	var active_bold : FontFile = FONT_ZH_BOLD if is_zh else FONT_EN_BOLD
	for child in find_children("*", "Label", true, false):
		var current_font : Font = child.get_theme_font("font")
		var font_path : String = current_font.resource_path if current_font else ""
		var is_bold : bool = "Bold" in font_path
		child.add_theme_font_override("font", active_bold if is_bold else active_regular)
