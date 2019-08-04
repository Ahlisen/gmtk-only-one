extends CanvasLayer

signal playerCountChanged
signal start

func show_message(text):
	$ColorRect/MessageLabel.text = text
	$ColorRect/MessageLabel.show()

func _on_PlayerSlider_value_changed(value):
	emit_signal("playerCountChanged")

func _on_StartButton_pressed():
	emit_signal("start")
