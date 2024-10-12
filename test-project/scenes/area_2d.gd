extends Area2D

# Cache reference to AnimatedSprite2D node
@onready var animated_sprite = $AnimatedSprite2D

# Block mouse passthrough and handle mouse click events
func _input(event):
	# Check if left mouse button was pressed
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# Check if mouse is over the Area2D
		if get_global_mouse_position().distance_to(position) <= 50:  # Adjust radius as needed
			if animated_sprite != null:
				print("Mascot clicked!")
				animated_sprite.play("charge")  # Play charge animation when clicked
			else:
				print("Error: AnimatedSprite2D not found!")
		event.consume()  # Block the event from passing through to the window

# Optional: Signal handler for mouse hover
func _on_Area2D_mouse_entered():
	print("Mouse entered mascot area")
	if animated_sprite != null and !animated_sprite.is_playing():
		animated_sprite.play("hover")  # Play hover animation on mouse enter

func _on_Area2D_mouse_exited():
	print("Mouse exited mascot area")
	if animated_sprite != null and !animated_sprite.is_playing():
		animated_sprite.play("idle")  # Return to idle animation when mouse exits


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	pass # Replace with function body.
