extends Node

var consoleScene = preload('res://MainConsole.tscn')
var miniGame = ''
var miniGameResult = false

func goToConsole():
	get_tree().change_scene_to(consoleScene)