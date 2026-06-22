extends Control
const FONT_TITLE_EN : FontFile = preload("res://fonts/breamcatcher rg.otf")
const FONT_BODY_EN : FontFile = preload("res://fonts/CaviarDreams.ttf")
const FONT_BODY_BOLD_EN : FontFile = preload("res://fonts/CaviarDreams_Bold.ttf")
const FONT_ZH : FontFile = preload("res://fonts/HiraginoSansGB.ttc")
const FONT_ZH_BOLD : FontFile = preload("res://fonts/HiraginoSansGB_Bold.ttf")

@onready var label_level_name : Label = $Label_LevelName
@onready var label_level_description : Label = $VBox/Label_Description
@onready var label_level_objectives : Label = $VBox/Label_Objectives
@onready var label_objectives_title : Label = $VBox/Label_Objectives_Title
@onready var audio_vo : AudioStreamPlayer = $Audio_VO
@onready var audio_bgm : AudioStreamPlayer = $Audio_BGM
@onready var anim_player : AnimationPlayer = $AnimationPlayer
@onready var prompt = $Prompt

enum State {IN, THERE, OUT}

var current_state : int = State.IN

func _on_animation_player_animation_finished(anim_name : String) -> void:
	match anim_name:
		"appear":
			current_state = State.THERE
		"disappear":
			get_tree().change_scene_to_file("res://scenes/game.tscn")

func _input(event : InputEvent) -> void:
	if event.is_action_pressed("interact") and current_state == State.THERE:
		anim_player.play("disappear")
		current_state = State.OUT

func _ready() -> void:
	label_level_name.text = Constants.get_level_name(GameProgress.current_level)
	label_level_description.text = Constants.get_level_briefing(GameProgress.current_level)
	label_level_objectives.text = Constants.get_level_objectives(GameProgress.current_level)
	label_objectives_title.text = tr("Objectives")
	prompt.title = "Continue"
	audio_vo.stream = load(Constants.get_level_vo_path(GameProgress.current_level))
	Settings.language_changed.connect(_on_language_changed)
	_apply_locale_style()
	await get_tree().create_timer(0.1).timeout
	audio_bgm.play()
	anim_player.play("appear")

func _on_language_changed() -> void:
	label_level_name.text = Constants.get_level_name(GameProgress.current_level)
	label_level_description.text = Constants.get_level_briefing(GameProgress.current_level)
	label_level_objectives.text = Constants.get_level_objectives(GameProgress.current_level)
	label_objectives_title.text = tr("Objectives")
	prompt.title = "Continue"
	_apply_locale_style()

func _apply_locale_style() -> void:
	var is_zh : bool = Settings.is_chinese()
	label_level_name.add_theme_font_override("font", FONT_ZH if is_zh else FONT_TITLE_EN)
	label_level_description.add_theme_font_override("font", FONT_ZH if is_zh else FONT_BODY_EN)
	label_level_objectives.add_theme_font_override("font", FONT_ZH if is_zh else FONT_BODY_EN)
	label_objectives_title.add_theme_font_override("font", FONT_ZH_BOLD if is_zh else FONT_BODY_BOLD_EN)
	label_level_name.add_theme_font_size_override("font_size", 84 if is_zh else 120)
	label_level_description.add_theme_font_size_override("font_size", 15 if is_zh and GameProgress.current_level == 3 else (18 if is_zh else 20))
	label_level_objectives.add_theme_font_size_override("font_size", 18 if is_zh else 20)
	label_objectives_title.add_theme_font_size_override("font_size", 20 if is_zh else 20)
