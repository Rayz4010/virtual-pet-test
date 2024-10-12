extends AnimatedSprite2D

# Movement variables
var speed = 100
var is_chasing_mouse = false  # Whether the mascot is in "walking" or "chasing" mode
var stop_distance = 5  # The mascot will stop this close to the mouse pointer
var is_jumping = false  # Flag to indicate if the character is jumping

# Timers to handle random idle and walk times
var random_idle_duration = 1.5  # Default random idle time
var random_walk_duration = 1.5  # Default random walk time
var current_timer = 0.0  # Tracks how long the mascot has been in the current state

func _ready():
	play("charge_witch")
	get_window().mouse_passthrough =true

	# Set random idle and walk durations
	_set_random_idle_and_walk_durations()

# Function called when mouse enters the area
func _on_area_2d_mouse_entered():
		print("mouse eneterd")
		play("hover_witch") 

# The input mouse function
func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int):
	if event is InputEventMouseButton and event.pressed:
		print("charged")
		if not is_jumping:  # Check if already jumping
			is_jumping = true  # Set jumping flag
			play("poof_witch")  # Start the jump animation

# Function called when the jump animation finishes
func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "poof_witch":
		is_jumping = false  # Reset jumping flag after jump ends
		# Play idle or continue chasing depending on the state
		if is_chasing_mouse:
			play("walk_witch")
		else:
			play("idle_witch")

func _set_random_idle_and_walk_durations():
	random_idle_duration = randf_range(1.0, 7.0)  # Random idle time between 1 and 7 seconds
	random_walk_duration = randf_range(1.0, 3.0)  # Random walk time between 1 and 3 seconds

# Update is called every frame
func _process(delta):
	var mouse_pos = get_global_mouse_position()

	# Update the timer with delta time
	current_timer += delta

	# Handle walking state
	if is_chasing_mouse:
		move_towards_mouse(mouse_pos, delta)
		play("walk_witch")  # Play walking animation

		# If the mascot has walked long enough, switch back to idle
		if current_timer >= random_walk_duration:
			is_chasing_mouse = false  # Stop walking
			current_timer = 0.0  # Reset the timer
			_set_random_idle_and_walk_durations()  # Set new random durations
			play("idle_witch")  

	# Handle idle state
	else:
		play("idle_witch")  # Keep playing idle animation if not chasing
		# If the mascot has idled long enough, start walking again
		if current_timer >= random_idle_duration:
			is_chasing_mouse = true  # Start walking again
			current_timer = 0.0  # Reset the timer
			_set_random_idle_and_walk_durations()  # Set new random durations

# Move towards the mouse
func move_towards_mouse(mouse_pos, delta):
	var direction = mouse_pos - position  # Calculate direction vector to the mouse
	var distance_to_mouse = direction.length()  # Calculate distance to the mouse

	# If the mascot is far from the mouse pointer, move towards it
	if distance_to_mouse > stop_distance:
		direction = direction.normalized()  # Normalize the direction
		position += direction * speed * delta  # Move in the direction of the mouse
		# Flip the sprite based on the movement direction
		flip_h = direction.x < 0
