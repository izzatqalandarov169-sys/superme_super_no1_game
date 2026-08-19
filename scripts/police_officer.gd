extends CharacterBody3D

var target: Node3D
var speed := 4.2
var health := 100.0
var cooldown := 0.0

func _ready() -> void:
    var mesh := MeshInstance3D.new()
    var capsule := CapsuleMesh.new()
    capsule.radius = 0.55
    capsule.height = 1.7
    mesh.mesh = capsule
    var material := StandardMaterial3D.new()
    material.albedo_color = Color("#234b8f")
    mesh.material_override = material
    add_child(mesh)
    var collision := CollisionShape3D.new()
    var shape := CapsuleShape3D.new()
    shape.radius = 0.55
    shape.height = 1.7
    collision.shape = shape
    add_child(collision)

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
