extends Control

const FONT_ZH : FontFile = preload("res://fonts/NotoSansSC-Regular.ttf")

@onready var anim_player : AnimationPlayer = $AnimationPlayer

# Subtitle timing: [text_key, start_time, end_time]
const SUBTITLES_EN := [
	["See, here's the thing about making powerful people angry...", 0.1, 4.7],
	["You've gotta do it from a distance.", 4.7, 8.1],
	["That, or make sure you're already running in the opposite direction by the time they find out.", 8.1, 12.7],
	["It's a miracle I made it out of there with my tail still on.", 12.7, 15.5],
	["My contact's gone dark.", 17.0, 19.2],
	["For all I know, they were in on the plan all along.", 19.2, 22.2],
	["Hope they're enjoying the fallout.", 22.2, 25.2],
	["As for me: I'll lie low for a while.", 25.2, 28.6],
	["It's far from home... but there are worse places to be when you're in hiding.", 28.6, 33.3],
]

const SUBTITLES_ZH := [
	["See, here's the thing about making powerful people angry...", 0.1, 4.2],
	["You've gotta do it from a distance.", 4.2, 8.0],
	["That, or make sure you're already running in the opposite direction by the time they find out.", 8.0, 12.1],
	["It's a miracle I made it out of there with my tail still on.", 12.1, 17.0],
	["My contact's gone dark.", 17.0, 19.1],
	["For all I know, they were in on the plan all along.", 19.1, 23.0],
	["Hope they're enjoying the fallout.", 23.0, 26.1],
	["As for me: I'll lie low for a while.", 26.1, 29.2],
	["It's far from home... but there are worse places to be when you're in hiding.", 29.2, 34.0],
]

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
	_play_subtitles()

func _apply_locale_style() -> void:
	if Settings.is_chinese():
		$Label_Subtitle.add_theme_font_override("font", FONT_ZH)
		$Label_ThankYou.add_theme_font_override("font", FONT_ZH)
		$Label_ThankYou/Label_MadeForGWJ.add_theme_font_override("font", FONT_ZH)

func _play_subtitles() -> void:
	var subtitles := SUBTITLES_EN if not Settings.is_chinese() else SUBTITLES_ZH
	for i in range(subtitles.size()):
		var entry = subtitles[i]
		var start: float = entry[1]
		var end: float = entry[2]
		var text: String = tr(entry[0])
		var prev_end: float = subtitles[i - 1][2] if i > 0 else 0.0

		var wait := start - prev_end
		if wait > 0:
			await get_tree().create_timer(wait).timeout

		$Label_Subtitle.text = text
		$Label_Subtitle.visible = true

		var duration := end - start
		if duration > 0:
			await get_tree().create_timer(duration).timeout

		$Label_Subtitle.visible = false
