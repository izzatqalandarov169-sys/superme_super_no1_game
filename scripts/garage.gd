extends CanvasLayer

signal vehicle_selected(vehicle: Dictionary)

var panel: PanelContainer
var list: GridContainer
var catalog: Array = []
var current_filter := "ALL"
var search_box: LineEdit
var count_label: Label

const FILTERS := ["ALL", "UZBEK", "BMW", "MERCEDES", "AUDI", "PORSCHE", "SUPERCAR", "TESLA", "MOTO"]

func open(vehicle_catalog: Array) -> void:
    catalog = vehicle_catalog
    if panel:
        panel.queue_free()

    panel = PanelContainer.new()
    panel.position = Vector2(35, 30)
    panel.size = Vector2(1210, 680)
    add_child(panel)

    var root := VBoxContainer.new()
    root.add_theme_constant_override("separation", 8)
    panel.add_child(root)

    var title := Label.new()
    title.text = "🚗 GARAJ / TRANSPORT CATALOG"
    title.add_theme_font_size_override("font_size", 30)
    root.add_child(title)

    var top := HBoxContainer.new()
    root.add_child(top)

    search_box = LineEdit.new()
    search_box.placeholder_text = "🔎 Model qidirish..."
    search_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    search_box.text_changed.connect(_refresh)
    top.add_child(search_box)

    count_label = Label.new()
    count_label.custom_minimum_size = Vector2(180, 0)
    top.add_child(count_label)

    var filter_scroll := ScrollContainer.new()
    filter_scroll.custom_minimum_size = Vector2(0, 48)
    filter_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
    filter_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
    root.add_child(filter_scroll)

    var filters := HBoxContainer.new()
    filters.add_theme_constant_override("separation", 6)
    filter_scroll.add_child(filters)
    for filter_name in FILTERS:
        var button := Button.new()
        button.text = filter_name
        button.custom_minimum_size = Vector2(105, 38)
        button.pressed.connect(_set_filter.bind(filter_name))
        filters.add_child(button)

    var scroll := ScrollContainer.new()
    scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
    root.add_child(scroll)

    list = GridContainer.new()
    list.columns = 3
    list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    scroll.add_child(list)

    var close := Button.new()
    close.text = "✕ Yopish"
    close.pressed.connect(close_garage)
    root.add_child(close)

    _refresh()

func _set_filter(filter_name: String) -> void:
    current_filter = filter_name
    _refresh()

func _refresh(_text := "") -> void:
    if not list:
        return
    for child in list.get_children():
        child.queue_free()

    var query := ""
    if search_box:
        query = search_box.text.strip_edges().to_lower()
    var shown := 0

    for vehicle in catalog:
        if not _matches_filter(vehicle, current_filter):
            continue
        var name := str(vehicle.get("name", "Transport"))
        if query != "" and name.to_lower().find(query) == -1:
            continue
        list.add_child(_make_card(vehicle))
        shown += 1

    if count_label:
        count_label.text = "%d ta transport" % shown

func _matches_filter(vehicle: Dictionary, filter_name: String) -> bool:
    if filter_name == "ALL":
        return true
    var name := str(vehicle.get("name", "")).to_lower()
    var type := str(vehicle.get("type", "")).to_lower()
    if filter_name == "MOTO":
        return type == "motorcycle"
    if filter_name == "UZBEK":
        return name.find("chevrolet") >= 0 or name.find("daewoo") >= 0 or name.find("uzauto") >= 0
    if filter_name == "BMW":
        return name.find("bmw") >= 0
    if filter_name == "MERCEDES":
        return name.find("mercedes") >= 0
    if filter_name == "AUDI":
        return name.find("audi") >= 0
    if filter_name == "PORSCHE":
        return name.find("porsche") >= 0
    if filter_name == "TESLA":
        return name.find("tesla") >= 0
    if filter_name == "SUPERCAR":
        return name.find("ferrari") >= 0 or name.find("lamborghini") >= 0 or name.find("mclaren") >= 0 or name.find("bugatti") >= 0 or name.find("koenigsegg") >= 0 or name.find("pagani") >= 0 or name.find("rimac") >= 0
    return true

func _make_card(vehicle: Dictionary) -> Control:
    var card := PanelContainer.new()
    card.custom_minimum_size = Vector2(370, 150)

    var box := VBoxContainer.new()
    box.add_theme_constant_override("separation", 5)
    card.add_child(box)

    var name := Label.new()
    name.text = str(vehicle.get("name", "Transport"))
    name.add_theme_font_size_override("font_size", 20)
    box.add_child(name)

    var type := str(vehicle.get("type", "car"))
    var icon := "🏍️" if type == "motorcycle" else "🚗"
    var stats := Label.new()
    stats.text = "%s  %s\n💰 $%s    ⚡ %d km/h" % [icon, type.to_upper(), str(vehicle.get("price", 0)), int(vehicle.get("speed", 0))]
    box.add_child(stats)

    var select := Button.new()
    select.text = "🚘 TANLASH VA SPAWN"
    select.custom_minimum_size = Vector2(0, 42)
    select.pressed.connect(_select.bind(vehicle))
    box.add_child(select)
    return card

func _select(vehicle: Dictionary) -> void:
    vehicle_selected.emit(vehicle)
    close_garage()

func close_garage() -> void:
    if panel:
        panel.queue_free()
        panel = null
