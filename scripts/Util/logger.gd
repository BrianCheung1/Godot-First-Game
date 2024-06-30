class_name Logger

var prefix

func _init(prefix):
	self.prefix = prefix
	
func print(text):
	if text is Array:
		print(prefix + " " + str(" ".join(text)))
		return
	print(prefix + " " + str(text))
