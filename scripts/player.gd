extends CharacterBody3D

const SPEED := 7.0
var gravity := 20.0
var vehicle: CharacterBody3D = null

func _physics_process(delta: float) -> void:
    if vehicle:
        global_position = vehicle.global_position + Vector3(0, 1.6, 0)
        if Input.is_action_just_pressed("exit_vehicle"):
            _exit_vehicle()
        return

    var input_vec := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
    var dir := Vector3(input_vec.x, 0, input_vec.y)
    velocity.x = dir.x * SPEED
    velocity.z = dir.z * SPEED
    if not is_on_floor():
        velocity.y -= gravity * delta
    else:
        velocity.y = 0
    move_and_slide()

    if Input.is_action_just_pressed("interact"):
        _try_enter_vehicle()

func _try_enter_vehicle() -> void:
    var nearest: CharacterBody3D = null
    var distance := 3.5
    for node in get_tree().get_nodes_in_group("vehicles"):
        var d: float = global_position.distance_to(node.global_position)
        if d < distance:
            distance = d
            nearest = node
    if nearest:
        vehicle = nearest
        vehicle.set_meta("driver", self)

func _exit_vehicle() -> void:
    var old_vehicle := vehicle
    vehicle = null
    global_position = old_vehicle.global_position + Vector3(2.5, 0.5, 0)
    old_vehicle.remove_meta("driver")
