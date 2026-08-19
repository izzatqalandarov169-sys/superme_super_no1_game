extends CanvasLayer

signal emergency_called(service: String, location: Vector3)

var phone_panel: PanelContainer
var owner_node: Node3D

func open(owner: Node3D) -> void:
    owner_node = owner
    if phone_panel:
        phone_panel.queue_free()
    phone_panel = PanelContainer.new()
    phone_panel.position = Vector2(820, 40)
    phone_panel.size = Vector2(400, 620)
    add_child(phone_panel)
    var root := VBoxContainer.new()
    phone_panel.add_child(root)
    var title := Label.new()
    title.text = "📱 SUPERME PHONE"
    title.add_theme_font_size_override("font_size", 28)
    root.add_child(title)
    for item in ["💬 ChatGPT", "🗺 GPS / Lokatsiya", "🚓 102 POLITSIYA", "🚑 103 TEZ YORDAM", "🚒 101 YONG‘IN", "💰 BANK", "📞 ALOQALAR"]:
        var b := Button.new()
        b.text = item
        b.custom_minimum_size = Vector2(0, 48)
        if item.contains("102"):
            b.pressed.connect(_call_service.bind("102"))
        elif item.contains("103"):
            b.pressed.connect(_call_service.bind("103"))
        elif item.contains("101"):
            b.pressed.connect(_call_service.bind("101"))
        else:
            b.pressed.connect(_show_info.bind(item))
        root.add_child(b)
    var close := Button.new()
    close.text = "✕ Yopish"
    close.pressed.connect(close_phone)
    root.add_child(close)

func _call_service(service: String) -> void:
    var location := owner_node.global_position if is_instance_valid(owner_node) else Vector3.ZERO
    emergency_called.emit(service, location)
    _show_info(service + " chaqirildi • lokatsiya yuborildi")

func _show_info(text: String) -> void:
    var dialog := AcceptDialog.new()
    dialog.dialog_text = text
    add_child(dialog)
    dialog.popup_centered()

func close_phone() -> void:
    if phone_panel:
        phone_panel.queue_free()
        phone_panel = null
