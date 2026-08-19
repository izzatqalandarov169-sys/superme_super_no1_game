extends Node3D

var player: CharacterBody3D
var cars: Array[CharacterBody3D] = []
var npcs: Array[CharacterBody3D] = []
var sun: DirectionalLight3D
var time_of_day := 8.0

func _ready() -> void:
    _build_world()
    _spawn_player()
    _spawn_cars()
    _spawn_npcs()
    _build_hud()

func _process(delta: float) -> void:
    time_of_day = fmod(time_of_day + delta * 0.08, 24.0)
    if sun:
        sun.rotation_degrees.x = -25.0 + (time_of_day / 24.0) * 360.0

func _build_world() -> void:
    sun = DirectionalLight3D.new()
    sun.rotation_degrees = Vector3(-35, -25, 0)
    sun.light_energy = 1.2
    add_child(sun)

    var env := WorldEnvironment.new()
    var environment := Environment.new()
    environment.background_mode = Environment.BG_COLOR
    environment.background_color = Color("#7da6c7")
    environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
    environment.ambient_light_color = Color("#d8e8ff")
    environment.ambient_light_energy = 0.8
    env.environment = environment
    add_child(env)

    _make_box("Ground", Vector3(120, 0.4, 120), Vector3(0, -0.2, 0), Color("#4d5a4a"))
    for x in range(-50, 51, 10):
        _make_box("RoadX", Vector3(8, 0.05, 120), Vector3(x, 0, 0), Color("#30343a"))
    for z in range(-50, 51, 10):
        _make_box("RoadZ", Vector3(120, 0.05, 8), Vector3(0, 0.02, z), Color("#30343a"))

    for x in range(-45, 46, 15):
        for z in range(-45, 46, 15):
            if abs(x) < 10 or abs(z) < 10:
                continue
            var h := 4.0 + float(abs((x * 7 + z * 3) % 12))
            _make_box("Building", Vector3(8, h, 8), Vector3(x, h * 0.5, z), Color("#8b9198"))

func _make_box(n: String, size: Vector3, pos: Vector3, color: Color) -> StaticBody3D:
    var body := StaticBody3D.new()
    body.name = n
    var mesh := MeshInstance3D.new()
    var box := BoxMesh.new()
    box.size = size
    mesh.mesh = box
    var mat := StandardMaterial3D.new()
    mat.albedo_color = color
    mesh.material_override = mat
    body.add_child(mesh)
    var collision := CollisionShape3D.new()
    var shape := BoxShape3D.new()
    shape.size = size
    collision.shape = shape
    body.add_child(collision)
    body.position = pos
    add_child(body)
    return body

func _spawn_player() -> void:
    player = CharacterBody3D.new()
    player.name = "Player"
    player.position = Vector3(0, 1.2, 12)
    player.set_script(load("res://scripts/player.gd"))
    add_child(player)
    _make_character_mesh(player, Color("#3b82f6"), 0.7)

func _spawn_cars() -> void:
    var spots := [Vector3(3, 0.8, 8), Vector3(-4, 0.8, -8), Vector3(18, 0.8, 3), Vector3(-18, 0.8, -3)]
    for i in spots.size():
        var car := CharacterBody3D.new()
        car.name = "Car_%02d" % (i + 1)
        car.position = spots[i]
        car.set_script(load("res://scripts/vehicle.gd"))
        add_child(car)
        _make_car_mesh(car, i)
        cars.append(car)

func _spawn_npcs() -> void:
    var spots := [Vector3(5, 1, 5), Vector3(-5, 1, 5), Vector3(12, 1, -12), Vector3(-12, 1, 12), Vector3(25, 1, 0), Vector3(-25, 1, 0)]
    for i in spots.size():
        var npc := CharacterBody3D.new()
        npc.name = "NPC_%02d" % (i + 1)
        npc.position = spots[i]
        npc.set_script(load("res://scripts/npc.gd"))
        npc.target = player
        add_child(npc)
        _make_character_mesh(npc, Color.from_hsv(float(i) / spots.size(), 0.65, 0.9), 0.55)
        npcs.append(npc)

func _make_character_mesh(body: Node3D, color: Color, radius: float) -> void:
    var mesh := MeshInstance3D.new()
    var sphere := CapsuleMesh.new()
    sphere.radius = radius
    sphere.height = radius * 3.0
    mesh.mesh = sphere
    var mat := StandardMaterial3D.new()
    mat.albedo_color = color
    mesh.material_override = mat
    body.add_child(mesh)
    var collision := CollisionShape3D.new()
    var shape := CapsuleShape3D.new()
    shape.radius = radius
    shape.height = radius * 3.0
    collision.shape = shape
    body.add_child(collision)

func _make_car_mesh(body: Node3D, variant: int) -> void:
    var mesh := MeshInstance3D.new()
    var box := BoxMesh.new()
    box.size = Vector3(2.2, 0.8, 4.2)
    mesh.mesh = box
    var mat := StandardMaterial3D.new()
    mat.albedo_color = Color.from_hsv(float(variant) / 4.0, 0.75, 0.9)
    mesh.material_override = mat
    body.add_child(mesh)
    var collision := CollisionShape3D.new()
    var shape := BoxShape3D.new()
    shape.size = box.size
    collision.shape = shape
    body.add_child(collision)

func _build_hud() -> void:
    var layer := CanvasLayer.new()
    add_child(layer)
    var label := Label.new()
    label.position = Vector2(24, 20)
    label.text = "SUPERME OPEN WORLD\nWASD: yurish | E: mashinaga chiqish | F: tushish\nOFFLINE PROTOTYPE • Barcha boshlang‘ich transport ochiq"
    label.add_theme_font_size_override("font_size", 20)
    layer.add_child(label)
