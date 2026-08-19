extends Node3D

var player: CharacterBody3D
var cars: Array[CharacterBody3D] = []
var npcs: Array[CharacterBody3D] = []
var sun: DirectionalLight3D
var time_of_day := 8.0
var menu_layer: CanvasLayer
var garage_layer: CanvasLayer
var phone_layer: CanvasLayer
var world_streamer: Node3D
var police_system: Node3D
var economy_system: Node
var vehicle_catalog: Array = []
var selected_vehicle: Dictionary = {}

func _ready() -> void:
    vehicle_catalog = _load_vehicle_catalog()
    _build_world()
    _spawn_player()
    _spawn_cars()
    _spawn_npcs()
    _build_world_streamer()
    _build_services()
    _build_hud()
    _build_main_menu()

func _process(delta: float) -> void:
    time_of_day = fmod(time_of_day + delta * 0.08, 24.0)
    if sun:
        sun.rotation_degrees.x = -25.0 + (time_of_day / 24.0) * 360.0
    if economy_system and economy_system.has_method("tick_prison"):
        economy_system.tick_prison(delta)

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

func _build_world_streamer() -> void:
    world_streamer = Node3D.new()
    world_streamer.name = "WorldStreamer"
    world_streamer.set_script(load("res://scripts/world_streamer.gd"))
    add_child(world_streamer)
    world_streamer.setup(player)

func _build_services() -> void:
    economy_system = load("res://scripts/economy_system.gd").new()
    economy_system.name = "EconomySystem"
    add_child(economy_system)

    police_system = Node3D.new()
    police_system.name = "PoliceSystem"
    police_system.set_script(load("res://scripts/police_system.gd"))
    add_child(police_system)
    police_system.setup(player)

    phone_layer = load("res://scripts/phone_system.gd").new()
    add_child(phone_layer)
    phone_layer.emergency_called.connect(_on_emergency_called)

func report_crime(level: int = 1) -> void:
    if police_system and police_system.has_method("report_crime"):
        police_system.report_crime(level)
    if economy_system and economy_system.has_method("commit_crime"):
        economy_system.commit_crime(level)

func _on_emergency_called(service: String, location: Vector3) -> void:
    if service == "102" and police_system:
        police_system.report_crime(1)
    # 101/103 keep their exact location through the phone signal for later AI/service agents.
    print("Emergency ", service, " requested at ", location)

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
        npc.add_to_group("npcs")
        add_child(npc)
        _make_character_mesh(npc, Color.from_hsv(float(i) / spots.size(), 0.65, 0.9), 0.55)
        npcs.append(npc)

func _make_character_mesh(body: Node3D, color: Color, radius: float) -> void:
    var mesh := MeshInstance3D.new()
    var capsule := CapsuleMesh.new()
    capsule.radius = radius
    capsule.height = radius * 3.0
    mesh.mesh = capsule
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
    mat.albedo_color = Color.from_hsv(float(variant) / 8.0, 0.75, 0.9)
    mesh.material_override = mat
    body.add_child(mesh)
    var collision := CollisionShape3D.new()
    var shape := BoxShape3D.new()
    shape.size = box.size
    collision.shape = shape
    body.add_child(collision)

func _load_vehicle_catalog() -> Array:
    var catalog_script = load("res://data/vehicle_catalog_extended.gd")
    var base_script = load("res://data/vehicle_catalog.gd")
    if catalog_script and base_script:
        return catalog_script.all_transport()
    if base_script:
        return base_script.all_vehicles()
    return []

func _open_garage() -> void:
    if garage_layer:
        garage_layer.queue_free()
    garage_layer = load("res://scripts/garage.gd").new()
    add_child(garage_layer)
    garage_layer.vehicle_selected.connect(_on_vehicle_selected)
    garage_layer.open(vehicle_catalog)

func _on_vehicle_selected(vehicle: Dictionary) -> void:
    selected_vehicle = vehicle.duplicate(true)
    _spawn_selected_vehicle()

func _spawn_selected_vehicle() -> void:
    for old_car in cars:
        if is_instance_valid(old_car):
            old_car.queue_free()
    cars.clear()
    var vehicle := CharacterBody3D.new()
    vehicle.name = "SelectedVehicle"
    vehicle.position = player.global_position + Vector3(3, 0.8, 0)
    vehicle.set_script(load("res://scripts/vehicle.gd"))
    add_child(vehicle)
    var variant := int(selected_vehicle.get("speed", 0)) % 8
    _make_car_mesh(vehicle, variant)
    cars.append(vehicle)

func _open_phone() -> void:
    if phone_layer:
        phone_layer.open(player)

func _build_hud() -> void:
    var layer := CanvasLayer.new()
    add_child(layer)
    var label := Label.new()
    label.position = Vector2(24, 20)
    label.text = "SUPERME: UZBEK WORLD\nWASD: yurish | E: transport | F: tushish | G: qurol | Telefon: menyudan\nOFFLINE • Transport va qurol kataloglari ochiq"
    label.add_theme_font_size_override("font_size", 20)
    layer.add_child(label)

func _build_main_menu() -> void:
    menu_layer = CanvasLayer.new()
    menu_layer.layer = 20
    add_child(menu_layer)

    var background := ColorRect.new()
    background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    background.color = Color(0.02, 0.05, 0.09, 0.94)
    menu_layer.add_child(background)

    var title := Label.new()
    title.text = "SUPERME: UZBEK WORLD"
    title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    title.position = Vector2(0, 90)
    title.size = Vector2(1280, 80)
    title.add_theme_font_size_override("font_size", 48)
    title.add_theme_color_override("font_color", Color("#46c7ff"))
    menu_layer.add_child(title)

    var subtitle := Label.new()
    subtitle.text = "OFFLINE OPEN WORLD • 🇺🇿"
    subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    subtitle.position = Vector2(0, 165)
    subtitle.size = Vector2(1280, 40)
    subtitle.add_theme_font_size_override("font_size", 20)
    menu_layer.add_child(subtitle)

    var start := Button.new()
    start.text = "▶  O‘YINNI BOSHLASH"
    start.position = Vector2(440, 260)
    start.size = Vector2(400, 65)
    start.add_theme_font_size_override("font_size", 24)
    start.pressed.connect(_start_game)
    menu_layer.add_child(start)

    var garage := Button.new()
    garage.text = "🚗  GARAJ / TRANSPORT"
    garage.position = Vector2(440, 340)
    garage.size = Vector2(400, 55)
    garage.pressed.connect(_open_garage)
    menu_layer.add_child(garage)

    var phone := Button.new()
    phone.text = "📱  TELEFON / CHATGPT"
    phone.position = Vector2(440, 410)
    phone.size = Vector2(400, 55)
    phone.pressed.connect(_open_phone)
    menu_layer.add_child(phone)

    var settings := Button.new()
    settings.text = "⚙  SOZLAMALAR"
    settings.position = Vector2(440, 480)
    settings.size = Vector2(400, 55)
    settings.pressed.connect(func(): _show_message("Sozlamalar: grafika, ovoz, til va boshqaruv"))
    menu_layer.add_child(settings)

func _start_game() -> void:
    menu_layer.visible = false

func _show_message(text: String) -> void:
    var dialog := AcceptDialog.new()
    dialog.dialog_text = text
    menu_layer.add_child(dialog)
    dialog.popup_centered()
