extends Node3D

# Offline wanted-response system. Police pursue the player when wanted level > 0.
var target: Node3D
var wanted_level := 0
var officers: Array[Node3D] = []
var response_cooldown := 0.0

func setup(player: Node3D) -> void:
    target = player

func report_crime(level: int = 1) -> void:
    wanted_level = clampi(wanted_level + level, 0, 5)
    _spawn_response_if_needed()

func clear_wanted() -> void:
    wanted_level = 0
    for officer in officers:
        if is_instance_valid(officer):
            officer.queue_free()
    officers.clear()

func _process(delta: float) -> void:
    response_cooldown = maxf(0.0, response_cooldown - delta)
    if target == null:
        return
    if wanted_level > 0 and response_cooldown <= 0.0:
        _spawn_response_if_needed()

func _spawn_response_if_needed() -> void:
    if target == null or officers.size() >= mini(1 + wanted_level, 5):
        return
    response_cooldown = 8.0
    var officer := CharacterBody3D.new()
    officer.name = "PoliceOfficer_%02d" % (officers.size() + 1)
    officer.position = target.global_position + Vector3(12.0 + officers.size() * 4.0, 0, 8.0)
    officer.set_script(load("res://scripts/police_officer.gd"))
    add_child(officer)
    officer.target = target
    officers.append(officer)
