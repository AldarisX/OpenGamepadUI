extends Node

@export var state_machine: StateMachine = preload(
	"res://assets/state/state_machines/global_state_machine.tres"
)
@export var process_input_during: Array[State] = []
@export var minimum_states := 1


func _ready() -> void:
	set_process_input(false)
	state_machine.state_changed.connect(_on_state_changed)


# Only process input when the given states are active
func _on_state_changed(_from: State, to: State) -> void:
	if to in process_input_during:
		set_process_input(true)
		return
	set_process_input(false)


# _gui_input events don't propagate to parents :(
# https://github.com/godotengine/godot/issues/19402
# https://docs.godotengine.org/en/latest/tutorials/inputs/inputevent.html#how-does-it-work
func _input(event: InputEvent) -> void:
	# Only handle back button pressed and when the guide button is not held
	if not event.is_action_pressed("ogui_east") or Input.is_action_pressed("ogui_guide"):
		return

	# Stop the event from propagating
	get_viewport().set_input_as_handled()

	# Pop the state machine stack to go back
	if state_machine.stack_length() > minimum_states:
		state_machine.pop_state()
		return
