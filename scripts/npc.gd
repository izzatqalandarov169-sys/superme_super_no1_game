extends CharacterBody3D

var target: Node3D
var home: Vector3
var mood := "calm"
var speed := 2.2
var reaction_cooldown := 0.0

func _ready() -> void:
    home = global_position
    mood = ["calm", "brave", "cautious", "clever"][randi() % 4]

func _physics_process(delta: float) -> void:
    reaction_cooldown = maxf(0.0, reaction_cooldown - delta)
    if target == null:
        return
    var distance := global_position.distance_to(target.global_position)
    if distance < 7.0 and reaction_cooldown <= 0.0:
        _react_to_player()
    elif distance > 12.0:
        _wander(delta)

func _react_to_player() -> void:
    reaction_cooldown = 4.0
    match mood:
        "cautious":
            _flee()
        "brave":
            _confront()
        "clever":
            _flee_and_report()
        _:
            _flee()

func _flee() -> void:
    var away := (global_position - target.global_position).normalized()
    velocity = away * speed * 2.2
    move_and_slide()

func _confront() -> void:
    var toward := (target.global_position - global_position).normalized()
    velocity = toward * speed
    move_and_slide()

func _flee_and_report() -> void:
    # Offline prototype hook: later connects to wanted/police service.
    _flee()

func _wander(delta: float) -> void:
    var offset := Vector3(sin(Time.get_ticks_msec() * 0.0004 + get_instance_id()), 0, cos(Time.get_ticks_msec() * 0.0003 + get_instance_id()))
    velocity = offset * speed * 0.35
    move_and_slide()
