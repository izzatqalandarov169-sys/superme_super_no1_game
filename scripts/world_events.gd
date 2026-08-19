extends Node

# Dynamic offline world events: incidents, jobs and ambient events.
signal event_started(event: Dictionary)
var events: Array = []
var timer := 0.0

func _process(delta: float) -> void:
    timer += delta
    if timer >= 30.0:
        timer = 0.0
        _create_event()

func _create_event() -> void:
    var kinds := ["traffic_incident", "delivery_job", "street_race", "lost_npc", "emergency_call"]
    var kind: String = kinds[randi() % kinds.size()]
    var event := {"id": events.size() + 1, "type": kind, "reward": 250 + randi() % 2500}
    events.append(event)
    event_started.emit(event)
