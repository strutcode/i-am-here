extends Area2D

onready var gameState = $"/root/GameState"
var explosion = preload('res://Explosion.tscn')
var killSound = preload('res://kill.wav')

func _ready():
	connect('body_entered', self, 'touchedBody')
	
func touchedBody(body):
	if body.is_in_group('player') and not body.dead:
		body.kill()
		
		var boom = explosion.instance()
		boom.position = body.position
		get_tree().current_scene.add_child(boom)
		boom.emitting = true

		gameState.playSfx(killSound, -10)