extends CanvasLayer
signal buff_1()
signal buff_2()
signal buff_3()

func _on_buff_1_button_pressed():
	buff_1.emit()
	hide()


func _on_buff_2_button_pressed():
	buff_2.emit()
	hide()

func _on_buff_3_button_pressed():
	buff_3.emit()
	hide()
