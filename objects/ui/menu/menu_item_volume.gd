@tool
extends HBoxContainer
const FONT_EN : FontFile = preload("res://fonts/breamcatcher rg.otf")
const FONT_ZH : FontFile = preload("res://fonts/SourceHanSansSC-Regular.otf")

@export var id : String

@export var title : String = "Menu Title" :
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

var amount : int = 10

func activate() -> void:
	pass

func increase() -> void:
	amount = clampi(amount + 1, 0, 10)
	$Volume.texture.region.position.y = amount * 54
	Settings.set_volume_setting(id, amount)
	#SoundController.play_sound("ui_volume")

func decrease() -> void:
	amount = clampi(amount - 1, 0, 10)
	$Volume.texture.region.position.y = amount * 54
	Settings.set_volume_setting(id, amount)
	#SoundController.play_sound("ui_volume")

func _ready() -> void:
	amount = Settings.get_volume_setting(id)
	$Volume.texture = $Volume.texture.duplicate(true)
	$Volume.texture.region.position.y = amount * 54
	refresh_text()
