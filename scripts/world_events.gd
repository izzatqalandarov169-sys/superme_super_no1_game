extends Node

signal event_started(event: Dictionary)
signal event_finished(event: Dictionary)
var events: Array = []
var timer := 0.0
var active_event: Dictionary = {}
var rng := RandomNumberGenerator.new()

func _ready() -> void:
    rng.randomize()

func _process(delta: float) -> void:
    timer += delta
    if not active_event.is_empty():
        active_event["remaining"] = float(active_event.get("remaining", 0.0)) - delta
        if float(active_event["remaining"]) <= 0.0:
            _finish_event()
    elif timer >= 20.0:
        timer = 0.0
        _create_event()

func _create_event() -> void:
    var kinds := ["traffic_incident", "delivery_job", "street_race", "lost_npc", "emergency_call", "police_chase", "npc_argument"]
    var kind: String = kinds[rng.randi_range(0, kinds.size() - 1)]
    active_event = {"id": events.size() + 1, "type": kind, "reward": 250 + rng.randi_range(0, 2500), "remaining": 35.0}
    events.append(active_event.duplicate(true))
    event_started.emit(active_event)

func _finish_event() -> void:
    var finished := active_event.duplicate(true)
    active_event.clear()
    event_finished.emit(finished)
