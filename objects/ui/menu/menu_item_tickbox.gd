@tool
extends HBoxContainer
const FONT_EN : FontFile = preload("res://fonts/breamcatcher rg.otf")
const FONT_ZH : FontFile = preload("res://fonts/HiraginoSansGB.ttc")

const _On : Texture2D = preload("res://sprites/ui/menu/tickbox_on.png")
const _Off : Texture2D = preload("res://sprites/ui/menu/tickbox_off.png")

@export var id : String

@export var title : String = "Tickbox" :
	set(value):
		title = value
		if has_node("Label"):
			$Label.text = tr(title)

var skip_cursor : bool = false

func refresh_text() -> void:
	$Label.text = tr(title)
	var is_zh : bool = TranslationServer.get_locale().begins_with("zh")
	$Label.add_theme_font_override("font", FONT_ZH if is_zh else FONT_EN)
	$Label.add_theme_font_size_override("font_size", 30 if is_zh else 44)

var on : bool = true

func activate() -> void:
	on = !on
	$Box.texture = _On if on else _Off
	Settings.set_tickbox_setting(id, on)
	#SoundController.play_sound("ui_confirm")

func increase() -> void:
	pass

func decrease() -> void:
	pass

func _ready() -> void:
	on = Settings.get_tickbox_setting(id)
	$Box.texture = _On if on else _Off
	refresh_text()
