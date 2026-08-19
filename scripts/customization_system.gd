extends RefCounted

# Shared vehicle customization state. Visual parts can be mapped to real assets later.
static func default_style() -> Dictionary:
    return {
        "paint": "factory",
        "wheels": "sport",
        "spoiler": "none",
        "bumper": "factory",
        "lights": "standard",
        "window_tint": 0.0,
        "ride_height": 0.0,
        "engine_level": 1,
        "horn": "standard"
    }

static func apply_upgrade(style: Dictionary, part: String, value) -> Dictionary:
    var result := style.duplicate(true)
    result[part] = value
    return result
