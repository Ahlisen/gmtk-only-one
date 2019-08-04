extends CanvasLayer

func show_message(text):
	$ColorRect/MessageLabel.text = text
	$ColorRect/MessageLabel.show()