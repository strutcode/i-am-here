extends Area2D

onready var gameState = $"/root/GameState"
var explosion = preload('res://Explosion.tscn')
var killSound = preload('res://kill.wav')

func _ready():
	connect('body_entered', self, 'touchedBody')
	
func touchedBody(body):
	if body.is_in_group('player'):
		body.get_node('AnimatedSprite').visible = false
		body.set_process(false)
		
		var boom = explosion.instance()
		boom.position = body.position
		get_tree().current_scene.add_child(boom)
		boom.emitting = true
		
		gameState.playSfx(killSound, -10)
		
		yield(get_tree().create_timer(1.0), 'timeout')
		get_tree().reload_current_scene()