extends Area2D

signal cannon_active

## cannon_emit_selection must match cannon it controles
@export var cannon_emit_selection: String = "text here"
## bool that contoles if trigger turns cannon on or off if true on if false off
@export var activate_switch: bool = true

func _on_body_entered(_body):
	cannon_active.emit(cannon_emit_selection, activate_switch)
