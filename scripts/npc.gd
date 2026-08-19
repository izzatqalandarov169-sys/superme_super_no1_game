extends CharacterBody3D

var target: Node3D
var home: Vector3
var mood := "calm"
var speed := 2.2
var reaction_cooldown := 0.0
var attack_cooldown := 0.0
var health := 100.0
var weapon_id := "pistol"
var is_police := false

func _ready() -> void:
    home = global_position
    mood = ["calm", "brave", "cautious", "clever"][randi() % 4]
    weapon_id = ["pistol", "rifle", "galaxy_blaster"][randi() % 3]
    is_police = name.ends_with("01") or name.ends_with("02")
    if is_police:
        weapon_id = "rifle"
        speed = 3.2

func _physics_process(delta: float) -> void:
    reaction_cooldown = maxf(0.0, reaction_cooldown - delta)
    attack_cooldown = maxf(0.0, attack_cooldown - delta)
    if target == null or not is_instance_valid(target):
        return
    var distance := global_position.distance_to(target.global_position)
    if is_police and distance < 45.0:
        _police_pursuit(distance)
    elif distance < 10.0 and reaction_cooldown <= 0.0:
        _react_to_player()
    elif distance > 12.0:
        _wander(delta)

func _police_pursuit(distance: float) -> void:
    if distance > 8.0:
        var toward := (target.global_position - global_position).normalized()
        velocity = toward * speed
        move_and_slide()
    elif attack_cooldown <= 0.0:
        attack_cooldown = 1.0
        WeaponController.fire(self, target, weapon_id)

func _react_to_player() -> void:
    reaction_cooldown = 3.0
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
    var distance := global_position.distance_to(target.global_position)
    if distance > 5.0:
        var toward := (target.global_position - global_position).normalized()
        velocity = toward * speed
        move_and_slide()
    elif attack_cooldown <= 0.0:
        attack_cooldown = 1.4
        WeaponController.fire(self, target, weapon_id)

func _flee_and_report() -> void:
    _flee()
    if get_parent().has_method("report_crime"):
        get_parent().report_crime(1)

func _wander(_delta: float) -> void:
    var offset := Vector3(sin(Time.get_ticks_msec() * 0.0004 + get_instance_id()), 0, cos(Time.get_ticks_msec() * 0.0003 + get_instance_id()))
    velocity = offset * speed * 0.35
    move_and_slide()

func take_damage(amount: float) -> void:
    health -= amount
    if health <= 0.0:
        queue_free()
