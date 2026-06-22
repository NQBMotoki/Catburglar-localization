@tool
extends HBoxContainer

const ICON_WIDTH : int = 64
const FONT_EN : FontFile = preload("res://fonts/CaviarDreams_Bold.ttf")
const FONT_ZH : FontFile = preload("res://fonts/NotoSansCJKsc-VF.ttf")

@export var title : String = "Action Name" :
	set(value):
		if has_node("Label_Action"):
			title = value
			$Label_Action.text = tr(title)

@export var action_name : String

@onready var key : Label = $Label_Key
@onready var button : TextureRect = $Texture_Button

func refresh() -> void:
	var keycode : int = Settings.get_keybinding(action_name)
	var keyname : String = OS.get_keycode_string(keycode)
	$Label_Key.text = "[" + keyname + "]"
	var joycode : int = Settings.get_joybinding(action_name)
	var joy_offset : int = Settings.JOY_BUTTON_ICON[joycode]
	$Texture_Button.texture.region.position.x = joy_offset * ICON_WIDTH
	$Texture_Button.texture.region.position.y = Settings.controller_type * ICON_WIDTH
	if Settings.last_input_was_controller:
		$Texture_Button.show()
		$Label_Key.hide()
	else:
		$Texture_Button.hide()
		$Label_Key.show()

func _ready() -> void:
	button.texture = button.texture.duplicate(true)
	$Label_Action.text = tr(title)
	var is_zh : bool = TranslationServer.get_locale().begins_with("zh")
	$Label_Action.add_theme_font_override("font", FONT_ZH if is_zh else FONT_EN)
	$Label_Action.add_theme_font_size_override("font_size", 18 if is_zh else 20)
	Settings.language_changed.connect(_on_language_changed)
	refresh()

func _on_language_changed() -> void:
	$Label_Action.text = tr(title)
	var is_zh : bool = TranslationServer.get_locale().begins_with("zh")
	$Label_Action.add_theme_font_override("font", FONT_ZH if is_zh else FONT_EN)
	$Label_Action.add_theme_font_size_override("font_size", 18 if is_zh else 20)
