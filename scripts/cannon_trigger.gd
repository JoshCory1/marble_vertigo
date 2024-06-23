extends Area2D

signal cannon_active

@export var cannon_emit_selection: String = "text here"

func _on_body_entered(body):
	cannon_active.emit(cannon_emit_selection)
