extends Control

@onready var anim_player : AnimationPlayer = $AnimationPlayer

func _on_animation_player_animation_finished(anim_name : String) -> void:
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")

func _ready() -> void:
	var vo_path := "res://audio/vo/ending.ogg"
	if Settings.is_chinese():
		vo_path = "res://audio/vo/zh/ending.ogg"
	$Audio_VO.stream = load(vo_path)
	await get_tree().create_timer(2.0).timeout
	anim_player.play("ending")
