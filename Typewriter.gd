extends Label

signal typewriter_done

export var runOnStart = true
export var initialDelay: float = 0
export var speed = 1
var boop = preload('res://type.wav')

var run = false
var time = 0
var position = 0
onready var originalText = ''
onready var timer = Timer.new()
onready var gameState = $'/root/GameState'

func _ready() -> void:
	if runOnStart:
		type()
		
func type():
	originalText = text
	text = ''
	add_child(timer)
	timer.connect('timeout', self, 'start')
	
	if initialDelay:
		yield(get_tree().create_timer(initialDelay), 'timeout')
	
	start()
		
func start():
	run = true
	
func _process(delta):
	if not run: return
	
	time += delta
	var delay = 0.1 / speed
	
	while position * delay < time and run:
		addChar()
	
func addChar():
	var next = originalText.substr(position, 1)
	if next != '`':
		text += next
		if gameState.lastBoopTime > 0.03:
			gameState.playSfx(boop, -25)
			gameState.lastBoopTime = 0
	position += 1
	
	if position == originalText.length():
		emit_signal('typewriter_done')
		run = false