extends Node3D

## SUPERME: UZBEK WORLD — streamed 1200 km x 1200 km world prototype.
## Only nearby sectors are active, so the theoretical world can be enormous.

@export var sector_size := 80.0
@export var active_radius := 2
@export var world_sectors := Vector2i(7500, 7500)

var loaded_sectors: Dictionary = {}
var player: Node3D

func setup(target: Node3D) -> void:
    player = target
    _refresh()

func _process(_delta: float) -> void:
    if is_instance_valid(player):
        _refresh()

func _refresh() -> void:
    var center := _sector_for(player.global_position)
    for x in range(center.x - active_radius, center.x + active_radius + 1):
        for z in range(center.y - active_radius, center.y + active_radius + 1):
            if x >= -world_sectors.x and x <= world_sectors.x and z >= -world_sectors.y and z <= world_sectors.y:
                _ensure_sector(Vector2i(x, z))

    for key in loaded_sectors.keys():
        var coord: Vector2i = key
        if abs(coord.x - center.x) > active_radius or abs(coord.y - center.y) > active_radius:
            loaded_sectors[key].queue_free()
            loaded_sectors.erase(key)

func _sector_for(pos: Vector3) -> Vector2i:
    return Vector2i(floori(pos.x / sector_size), floori(pos.z / sector_size))

func _ensure_sector(coord: Vector2i) -> void:
    if loaded_sectors.has(coord):
        return
    var sector := Node3D.new()
    sector.name = "Sector_%d_%d" % [coord.x, coord.y]
    sector.position = Vector3(coord.x * sector_size, 0, coord.y * sector_size)
    add_child(sector)
    loaded_sectors[coord] = sector

    for axis in range(2):
        var road := MeshInstance3D.new()
        var mesh := BoxMesh.new()
        mesh.size = Vector3(sector_size, 0.05, 5.0) if axis == 0 else Vector3(5.0, 0.05, sector_size)
        road.mesh = mesh
        var material := StandardMaterial3D.new()
        material.albedo_color = Color("#292d33")
        road.material_override = material
        road.position = Vector3(sector_size * 0.5, 0, sector_size * 0.5)
        sector.add_child(road)
