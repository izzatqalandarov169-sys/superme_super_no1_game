extends CanvasLayer

signal vehicle_selected(vehicle: Dictionary)

var panel: PanelContainer
var list: VBoxContainer
var catalog: Array = []

func open(vehicle_catalog: Array) -> void:
    catalog = vehicle_catalog
    if panel:
        panel.queue_free()
    panel = PanelContainer.new()
    panel.position = Vector2(60, 50)
    panel.size = Vector2(1160, 620)
    add_child(panel)

    var root := VBoxContainer.new()
    root.add_theme_constant_override("separation", 12)
    panel.add_child(root)

    var title := Label.new()
    title.text = "🚗 GARAJ / TRANSPORT — HAMMASI OCHIQ"
    title.add_theme_font_size_override("font_size", 28)
    root.add_child(title)

    var info := Label.new()
    info.text = "Mashina va moto tanlang • narx va tezlikni ko‘ring • tanlangan transport o‘yinda paydo bo‘ladi"
    root.add_child(info)

    var scroll := ScrollContainer.new()
    scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
    root.add_child(scroll)
    list = VBoxContainer.new()
    list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    scroll.add_child(list)

    for vehicle in catalog:
        var row := HBoxContainer.new()
        row.custom_minimum_size = Vector2(0, 48)
        var label := Label.new()
        label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
        label.text = "%s   •   $%s   •   %d km/h" % [vehicle.get("name", "Transport"), str(vehicle.get("price", 0)), int(vehicle.get("speed", 0))]
        row.add_child(label)
        var button := Button.new()
        button.text = "TANLASH"
        button.pressed.connect(_select.bind(vehicle))
        row.add_child(button)
        list.add_child(row)

    var close := Button.new()
    close.text = "✕ Yopish"
    close.pressed.connect(close_garage)
    root.add_child(close)

func _select(vehicle: Dictionary) -> void:
    vehicle_selected.emit(vehicle)
    close_garage()

func close_garage() -> void:
    if panel:
        panel.queue_free()
        panel = null
