extends CharacterBody3D

const SPEED := 7.0
var gravity := 20.0
var vehicle: CharacterBody3D = null
var health := 100.0
var weapon_id := "galaxy_blaster"
var attack_cooldown := 0.0

func _physics_process(delta: float) -> void:
    attack_cooldown = maxf(0.0, attack_cooldown - delta)
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
    if (Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) or Input.is_key_pressed(KEY_G)) and attack_cooldown <= 0.0:
        _fire_at_nearest_npc()

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

func _fire_at_nearest_npc() -> void:
    var nearest: Node3D = null
    var distance := 35.0
    for node in get_tree().get_nodes_in_group("npcs"):
        if not is_instance_valid(node):
            continue
        var d: float = global_position.distance_to(node.global_position)
        if d < distance:
            distance = d
            nearest = node
    if nearest and WeaponController.fire(self, nearest, weapon_id):
        attack_cooldown = 0.65
        var root := get_parent()
        if root.has_method("report_crime"):
            root.report_crime(1)

func take_damage(amount: float) -> void:
    health -= amount
    if health <= 0.0:
        health = 100.0
        global_position = Vector3(0, 1.2, 12)
