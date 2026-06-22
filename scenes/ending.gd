extends Control

const FONT_ZH : FontFile = preload("res://fonts/NotoSansCJKsc-VF.ttf")

@onready var anim_player : AnimationPlayer = $AnimationPlayer

func _on_animation_player_animation_finished(anim_name : String) -> void:
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")

func _ready() -> void:
	_apply_locale_style()
	var vo_path := "res://audio/vo/ending.ogg"
	if Settings.is_chinese():
		vo_path = "res://audio/vo/zh/ending.ogg"
	await get_tree().create_timer(2.0).timeout
	anim_player.play("ending")
	$Audio_VO.stream = load(vo_path)
	$Audio_VO.play()

func _apply_locale_style() -> void:
	if Settings.is_chinese():
		$Label_Subtitle.add_theme_font_override("font", FONT_ZH)
		$Label_ThankYou.add_theme_font_override("font", FONT_ZH)
		$Label_ThankYou/Label_MadeForGWJ.add_theme_font_override("font", FONT_ZH)
