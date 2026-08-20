extends CanvasLayer

signal tuning_applied(vehicle: Dictionary, tuning: Dictionary)

var panel: PanelContainer
var selected_vehicle: Dictionary = {}
var tuning := {
    "engine": 0,
    "brakes": 0,
    "suspension": 0,
    "tires": 0,
    "turbo": 0,
    "exhaust": 0,
    "paint": "factory"
}

func open(vehicle: Dictionary) -> void:
    selected_vehicle = vehicle.duplicate(true)
    _build()

func _build() -> void:
    if panel:
        panel.queue_free()
    panel = PanelContainer.new()
    panel.position = Vector2(80, 45)
    panel.size = Vector2(1120, 650)
    add_child(panel)

    var root := VBoxContainer.new()
    root.add_theme_constant_override("separation", 10)
    panel.add_child(root)

    var title := Label.new()
    title.text = "🔧 TUNING — %s" % selected_vehicle.get("name", "Transport")
    title.add_theme_font_size_override("font_size", 30)
    root.add_child(title)

    var categories := [
        ["Dvigatel", "engine"],
        ["Tormoz", "brakes"],
        ["Podveska", "suspension"],
        ["Shina", "tires"],
        ["Turbo", "turbo"],
        ["Glushitel", "exhaust"]
    ]

    for item in categories:
        var row := HBoxContainer.new()
        var label := Label.new()
        label.text = item[0]
        label.custom_minimum_size.x = 240
        row.add_child(label)

        var level := Label.new()
        level.name = item[1]
        level.text = "Daraja: %d / 5" % int(tuning[item[1]])
        level.size_flags_horizontal = Control.SIZE_EXPAND_FILL
        row.add_child(level)

        var button := Button.new()
        button.text = "+ Tuning"
        button.pressed.connect(_upgrade.bind(item[1], level))
        row.add_child(button)
        root.add_child(row)

    var paint_title := Label.new()
    paint_title.text = "🎨 Rang"
    root.add_child(paint_title)

    var paints := HBoxContainer.new()
    for paint in ["factory", "black", "white", "red", "blue", "green", "gold"]:
        var b := Button.new()
        b.text = paint.capitalize()
        b.pressed.connect(_paint.bind(paint))
        paints.add_child(b)
    root.add_child(paints)

    var actions := HBoxContainer.new()
    var apply := Button.new()
    apply.text = "✅ SAQLASH / QO‘LLASH"
    apply.pressed.connect(_apply)
    actions.add_child(apply)

    var close := Button.new()
    close.text = "✕ Yopish"
    close.pressed.connect(close_tuning)
    actions.add_child(close)
    root.add_child(actions)

func _upgrade(part: String, label: Label) -> void:
    var current := int(tuning.get(part, 0))
    if current < 5:
        current += 1
        tuning[part] = current
        label.text = "Daraja: %d / 5" % current

func _paint(value: String) -> void:
    tuning["paint"] = value

func _apply() -> void:
    tuning_applied.emit(selected_vehicle, tuning.duplicate(true))
    close_tuning()

func close_tuning() -> void:
    if panel:
        panel.queue_free()
        panel = null
