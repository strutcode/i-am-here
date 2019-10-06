extends TextEdit

func _ready() -> void:
	grab_focus()
	
func _input(event):
	if event is InputEventKey:
		if event.is_pressed():
			if event.scancode == KEY_UP or event.scancode == KEY_DOWN:
				get_tree().set_input_as_handled()
			elif event.scancode == KEY_BACKSPACE or event.scancode == KEY_LEFT:
				if cursor_get_column() <= 2:
					get_tree().set_input_as_handled()
			elif event.scancode == KEY_ENTER:
				var input = get_line(cursor_get_line()).right(2)
				text += '\n'
				handleInput(input)
				text += '\n'
				createPrompt()
				get_tree().set_input_as_handled()
				
func output(string):
	text += string
	yield(get_tree().create_timer(0.01), 'timeout')
	cursor_set_line(get_line_count(), true, false)
	
func createPrompt():
	output('> ')
	cursor_set_column(2)
	
func handleInput(string: String):
	var methodName = 'command_' + string.to_lower().strip_edges()
	
	if self.has_method(methodName):
		self.call(methodName)
	elif self.has_method('command_default'):
		self.call('command_default')
