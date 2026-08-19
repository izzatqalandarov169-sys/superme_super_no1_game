extends CharacterBody3D

var target: Node3D
var speed := 4.2
var health := 100.0
var cooldown := 0.0

func _physics_process(delta: float) -> void:
    cooldown = maxf(0.0, cooldown - delta)
    if target == null or not is_instance_valid(target):
        return
    var distance := global_position.distance_to(target.global_position)
    if distance > 4.0:
        velocity = (target.global_position - global_position).normalized() * speed
        move_and_slide()
    elif cooldown <= 0.0:
        cooldown = 1.2
        WeaponController.fire(self, target, "pistol")

func take_damage(amount: float) -> void:
    health -= amount
    if health <= 0.0:
        queue_free()
