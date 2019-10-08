extends Node

var consoleScene = preload('res://MainConsole.tscn')
var miniGame = ''
var miniGameResult = false
var lastBoopTime = 0

var spaceDone = false
var snakeDone = false

func goToConsole():
	get_tree().change_scene_to(consoleScene)
	
func _process(delta):
	lastBoopTime += delta
	
func playSfx(audioStream, volume = 0):
	var sfx = AudioStreamPlayer.new()
	sfx.stream = audioStream
	sfx.volume_db = volume
	get_tree().current_scene.add_child(sfx)
	sfx.play()
	yield(sfx, 'finished')
	sfx.queue_free()