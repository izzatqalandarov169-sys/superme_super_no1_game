class_name WeaponController
extends Node

# 24 fictional/in-game weapon profiles. Names are game items; no real-world
# construction or modification instructions are represented here.
const WEAPONS := {
    "pistol": {"damage": 20.0, "range": 55.0, "cooldown": 0.35, "price": 1500},
    "heavy_pistol": {"damage": 28.0, "range": 50.0, "cooldown": 0.55, "price": 3500},
    "smg": {"damage": 18.0, "range": 60.0, "cooldown": 0.11, "price": 7000},
    "carbine": {"damage": 26.0, "range": 75.0, "cooldown": 0.18, "price": 11000},
    "rifle": {"damage": 34.0, "range": 85.0, "cooldown": 0.14, "price": 18000},
    "burst_rifle": {"damage": 30.0, "range": 90.0, "cooldown": 0.24, "price": 24000},
    "marksman": {"damage": 58.0, "range": 150.0, "cooldown": 0.8, "price": 42000},
    "sniper": {"damage": 90.0, "range": 240.0, "cooldown": 1.7, "price": 75000},
    "shotgun": {"damage": 75.0, "range": 35.0, "cooldown": 1.0, "price": 22000},
    "auto_shotgun": {"damage": 52.0, "range": 38.0, "cooldown": 0.45, "price": 46000},
    "lmg": {"damage": 32.0, "range": 100.0, "cooldown": 0.12, "price": 65000},
    "plasma": {"damage": 65.0, "range": 120.0, "cooldown": 0.55, "price": 90000},
    "laser": {"damage": 80.0, "range": 145.0, "cooldown": 0.7, "price": 120000},
    "ion_blaster": {"damage": 95.0, "range": 160.0, "cooldown": 0.85, "price": 160000},
    "galaxy_blaster": {"damage": 120.0, "range": 130.0, "cooldown": 0.65, "price": 200000},
    "galaxy_ray": {"damage": 180.0, "range": 180.0, "cooldown": 1.1, "price": 350000},
    "star_cannon": {"damage": 230.0, "range": 220.0, "cooldown": 1.6, "price": 600000},
    "void_pulse": {"damage": 260.0, "range": 200.0, "cooldown": 1.9, "price": 850000},
    "shockwave": {"damage": 110.0, "range": 25.0, "cooldown": 1.2, "price": 50000},
    "grenade": {"damage": 70.0, "range": 18.0, "cooldown": 1.4, "price": 9000},
    "rpg": {"damage": 90.0, "range": 70.0, "cooldown": 1.8, "price": 45000},
    "rocket_launcher": {"damage": 140.0, "range": 110.0, "cooldown": 2.2, "price": 100000},
    "emp_launcher": {"damage": 40.0, "range": 90.0, "cooldown": 2.0, "price": 130000},
    "meteor": {"damage": 300.0, "range": 250.0, "cooldown": 3.0, "price": 1500000}
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
