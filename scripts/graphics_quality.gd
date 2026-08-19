extends Node

# Graphics quality presets for Android and desktop. Uses only original Godot settings.
const PRESETS := {
    "low": {"scale": 0.70, "shadow": 1024, "fog": false, "glow": false},
    "medium": {"scale": 0.85, "shadow": 2048, "fog": true, "glow": true},
    "high": {"scale": 1.00, "shadow": 4096, "fog": true, "glow": true},
    "ultra": {"scale": 1.15, "shadow": 8192, "fog": true, "glow": true}
}

var current := "high"

func set_quality(level: String) -> void:
    if PRESETS.has(level):
        current = level

func get_settings() -> Dictionary:
    return PRESETS[current].duplicate(true)
