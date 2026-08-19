extends Node3D

# Original realistic-world presentation layer for SUPERME: UZBEK WORLD.
# Designed to support high-quality lighting, atmosphere and a large streamed map
# without copying GTA assets.

var environment: Environment
var world_time := 8.0
var weather := "clear"

func _ready() -> void:
    environment = Environment.new()
    environment.background_mode = Environment.BG_SKY
    environment.ambient_light_source = Environment.AMBIENT_SOURCE_SKY
    environment.ambient_light_energy = 0.7
    environment.tonemap_mode = Environment.TONE_MAPPER_FILMIC
    environment.glow_enabled = true
    environment.fog_enabled = true
    environment.fog_light_color = Color("#9bb6c9")
    environment.fog_density = 0.003
    environment.volumetric_fog_enabled = true
    environment.volumetric_fog_density = 0.015
    environment.adjustment_enabled = true
    environment.adjustment_brightness = 1.05
    environment.adjustment_contrast = 1.08
    environment.adjustment_saturation = 1.08

    var world_environment := WorldEnvironment.new()
    world_environment.environment = environment
    add_child(world_environment)

func _process(delta: float) -> void:
    world_time = fmod(world_time + delta * 0.04, 24.0)
    _update_atmosphere()

func set_weather(new_weather: String) -> void:
    weather = new_weather

func _update_atmosphere() -> void:
    if environment == null:
        return
    var night := world_time >= 20.0 or world_time < 6.0
    environment.ambient_light_energy = 0.32 if night else 0.75
    if weather == "rain":
        environment.fog_density = 0.008
    elif weather == "fog":
        environment.fog_density = 0.018
    else:
        environment.fog_density = 0.003
