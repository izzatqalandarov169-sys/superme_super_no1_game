extends CanvasLayer

var player: Node

func setup(target: Node) -> void:
    player = target
    _build()

func _build() -> void:
    var root := Control.new()
    root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    root.mouse_filter = Control.MOUSE_FILTER_IGNORE
    add_child(root)

    _button(root, "◀", Vector2(30, 590), Vector2(82, 82), "move_left")
    _button(root, "▶", Vector2(210, 590), Vector2(82, 82), "move_right")
    _button(root, "▲", Vector2(120, 500), Vector2(82, 82), "move_forward")
    _button(root, "▼", Vector2(120, 680), Vector2(82, 82), "move_back")

    var interact := _action_button(root, "🚗", Vector2(1010, 515), Vector2(92, 92), "interact")
    interact.tooltip_text = "Transportga kirish"
    var exit := _action_button(root, "🚪", Vector2(1110, 515), Vector2(92, 92), "exit_vehicle")
    exit.tooltip_text = "Transportdan tushish"

    var fire := Button.new()
    fire.text = "🔥"
    fire.position = Vector2(1110, 615)
    fire.size = Vector2(92, 92)
    fire.modulate.a = 0.82
    fire.button_down.connect(_fire_start)
    fire.button_up.connect(_fire_stop)
    root.add_child(fire)

    var phone := Button.new()
    phone.text = "📱"
    phone.position = Vector2(1010, 615)
    phone.size = Vector2(92, 92)
    phone.modulate.a = 0.82
    phone.pressed.connect(_open_phone)
    root.add_child(phone)

func _button(parent: Control, text: String, pos: Vector2, size: Vector2, action: String) -> void:
    _action_button(parent, text, pos, size, action)

func _action_button(parent: Control, text: String, pos: Vector2, size: Vector2, action: String) -> Button:
    var b := Button.new()
    b.text = text
    b.position = pos
    b.size = size
    b.modulate.a = 0.72
    b.button_down.connect(_press_action.bind(action))
    b.button_up.connect(_release_action.bind(action))
    parent.add_child(b)
    return b

func _press_action(action: String) -> void:
    Input.action_press(action)

func _release_action(action: String) -> void:
    Input.action_release(action)

func _fire_start() -> void:
    Input.action_press("fire")

func _fire_stop() -> void:
    Input.action_release("fire")

func _open_phone() -> void:
    if player and player.get_parent().has_method("_open_phone"):
        player.get_parent()._open_phone()
