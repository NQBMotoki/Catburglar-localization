@tool
extends HBoxContainer

const ICON_WIDTH : int = 64
const FONT_EN : FontFile = preload("res://fonts/breamcatcher rg.otf")
const FONT_ZH : FontFile = preload("res://fonts/NotoSansCJKsc-VF.ttf")

@export var title : String = "Action Name" :
	set(value):
		if has_node("Label"):
			title = value
			$Label.text = tr(title)

@export var action_name : String

@onready var key : Label = $Key
@onready var button : TextureRect = $Button

var skip_cursor : bool = false

func refresh_text() -> void:
	$Label.text = tr(title)
	var is_zh : bool = TranslationServer.get_locale().begins_with("zh")
	$Label.add_theme_font_override("font", FONT_ZH if is_zh else FONT_EN)
	$Label.add_theme_font_size_override("font_size", 28 if is_zh else 36)

func refresh() -> void:
	var keycode : int = Settings.get_keybinding(action_name)
	var keyname : String = OS.get_keycode_string(keycode)
	$Key.text = "[" + keyname + "] / "
	var joycode : int = Settings.get_joybinding(action_name)
	var joy_offset : int = Settings.JOY_BUTTON_ICON[joycode]
	$Button.texture.region.position.x = joy_offset * ICON_WIDTH
	$Button.texture.region.position.y = Settings.controller_type * ICON_WIDTH
	$Button.show()

func activate() -> void:
	get_parent()._on_rebinding_started(action_name)
	key.text = "..."
	button.hide()
	#SoundController.play_sound("ui_confirm")

func increase() -> void:
	pass

func decrease() -> void:
	pass

func _ready() -> void:
	button.texture = button.texture.duplicate(true)
	refresh_text()
	refresh()
