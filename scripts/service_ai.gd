extends Node3D

# Offline emergency-service dispatcher. Services use the exact caller position
# and can be expanded into vehicles/agents later.
var player: Node3D
var active_calls: Array = []

func setup(target: Node3D) -> void:
    player = target

func dispatch(service: String) -> Dictionary:
    var location := player.global_position if player and is_instance_valid(player) else Vector3.ZERO
    var call := {"service": service, "location": location, "status": "dispatched"}
    active_calls.append(call)
    return call
