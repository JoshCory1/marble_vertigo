extends Control

signal close_settings

func _ready():
	$Box/Label/ColorRect/HSliderMusicFX.value = AudioPlayer.m_player_vol
	$Box/Label/ColorRect/HSlider2SoundFX.value = AudioPlayer.volume_sfx

func _on_close_button_pressed() -> void:
	GameController.save_game()
	close_settings.emit()


func _on_h_slider_music_fx_value_changed(value: float) -> void:
	if value < -23:
		AudioPlayer.m_player_vol = -80
	else:
		AudioPlayer.m_player_vol = value


func _on_h_slider_2_sound_fx_value_changed(value: float) -> void:
	if value < -23:
		AudioPlayer.volume_sfx = -80
	else:
		AudioPlayer.volume_sfx = value
