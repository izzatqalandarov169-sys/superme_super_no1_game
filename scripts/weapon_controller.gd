extends Node

# Offline fictional combat controller. Supports normal, grenade/RPG-style and
# fantasy/galaxy weapon profiles without real-world construction details.

const WEAPONS := {
    "pistol": {"damage": 20.0, "range": 55.0, "cooldown": 0.35},
    "rifle": {"damage": 34.0, "range": 85.0, "cooldown": 0.14},
    "rpg": {"damage": 90.0, "range": 70.0, "cooldown": 1.8},
    "grenade": {"damage": 70.0, "range": 18.0, "cooldown": 1.4},
    "galaxy_blaster": {"damage": 120.0, "range": 130.0, "cooldown": 0.65},
    "galaxy_ray": {"damage": 180.0, "range": 180.0, "cooldown": 1.1}
}

static func fire(shooter: Node3D, target: Node3D, weapon_id: String) -> bool:
    if shooter == null or target == null or not is_instance_valid(shooter) or not is_instance_valid(target):
        return false
    var profile: Dictionary = WEAPONS.get(weapon_id, WEAPONS["pistol"])
    if shooter.global_position.distance_to(target.global_position) > float(profile.range):
        return false
    if target.has_method("take_damage"):
        target.take_damage(float(profile.damage))
        return true
    return false

static func weapon_names() -> Array:
    return WEAPONS.keys()
