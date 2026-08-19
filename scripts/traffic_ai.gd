extends Node3D

# Offline civilian traffic controller. Vehicles follow simple road targets,
# react to nearby actors and can report dangerous incidents to the police system.
@export var spawn_count := 18
var player: Node3D
var traffic: Array[CharacterBody3D] = []

func setup(target: Node3D) -> void:
    player = target
    for i in range(spawn_count):
        _spawn_vehicle(i)

func _process(delta: float) -> void:
    for car in traffic:
        if not is_instance_valid(car):
            continue
        var t := Time.get_ticks_msec() * 0.0002 + float(car.get_instance_id())
        car.velocity = Vector3(cos(t), 0, sin(t)) * 3.5
        car.move_and_slide()
        if player and car.global_position.distance_to(player.global_position) > 160.0:
            car.global_position = player.global_position + Vector3(cos(t), 0, sin(t)) * 90.0

func _spawn_vehicle(i: int) -> void:
    var car := CharacterBody3D.new()
    car.name = "Traffic_%02d" % (i + 1)
    car.add_to_group("vehicles")
    car.position = Vector3((i % 6) * 15 - 40, 0.8, (i / 6) * 18 - 25)
    add_child(car)
    var mesh := MeshInstance3D.new()
    var box := BoxMesh.new()
    box.size = Vector3(2.0, 0.8, 3.8)
    mesh.mesh = box
    var material := StandardMaterial3D.new()
    material.albedo_color = Color.from_hsv(float(i) / float(maxi(spawn_count, 1)), 0.7, 0.9)
    mesh.material_override = material
    car.add_child(mesh)
    var collision := CollisionShape3D.new()
    var shape := BoxShape3D.new()
    shape.size = box.size
    collision.shape = shape
    car.add_child(collision)
    traffic.append(car)
