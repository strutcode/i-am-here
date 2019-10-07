extends TextEdit

signal output_done

var outputDelta = 0
var outputDelay: float = 0.1 / 3
var outputBuffer = ''
var allowInput = false

func _ready() -> void:
	grab_focus()
	
func _input(event):
	if not allowInput:
		get_tree().set_input_as_handled()
		return
		
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
				createPrompt()
				get_tree().set_input_as_handled()
				
func output(string, newline = true):
	allowInput = false
		
	outputBuffer += string
	if newline:
		outputBuffer += '\n'
	
func _process(delta):
	if outputBuffer.length() == 0:
		outputDelta = 0
		allowInput = true
		return
		
	outputDelta += delta
	
	while outputDelta > outputDelay:
		var next = outputBuffer.substr(0, 1)
		
		if next != '`':
			text += next
			
		outputBuffer = outputBuffer.substr(1, outputBuffer.length())
		
		cursor_set_line(get_line_count(), true, false)
		cursor_set_column(get_line(get_line_count() - 1).length())
		
		outputDelta -= outputDelay
		
		if outputBuffer.length() == 0:
			emit_signal('output_done')
			break
	
func createPrompt():
	output('\n> ', false)
	
func handleInput(string: String):
	var parts = string.to_lower().strip_edges().split(' ')
	var methodName = 'command_' + parts[0]
	
	if self.has_method(methodName):
		self.call(methodName, parts[1] if parts.size() > 1 else null)
	elif self.has_method('command_default'):
		self.call('command_default')
