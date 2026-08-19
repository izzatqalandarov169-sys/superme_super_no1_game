extends CharacterBody3D

@export var max_speed := 18.0
@export var acceleration := 12.0
@export var steering := 1.8
var speed := 0.0

func _ready() -> void:
    add_to_group("vehicles")

func _physics_process(delta: float) -> void:
    var driver = get_meta("driver", null)
    if driver == null:
        return
    var throttle := Input.get_axis("move_back", "move_forward")
    var steer := Input.get_axis("move_left", "move_right")
    speed = move_toward(speed, throttle * max_speed, acceleration * delta)
    rotate_y(-steer * steering * delta * clamp(abs(speed) / max_speed, 0.2, 1.0))
    velocity = -global_transform.basis.z * speed
    move_and_slide()
