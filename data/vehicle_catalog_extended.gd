extends RefCounted

# Expanded original placeholder catalog. Real-world trademarks/models can be
# mapped later only when appropriate licensed assets/names are available.
# All entries are unlocked for the owner's offline profile.

const UZ_STYLE := [
    "UZ Sedan Classic", "UZ Sedan Comfort", "UZ Sedan Premium", "UZ Compact", "UZ Hatch Sport",
    "UZ Family Wagon", "UZ Crossover", "UZ SUV Classic", "UZ SUV Premium", "UZ Pickup",
    "UZ Van", "UZ Taxi", "UZ Sport Sedan", "UZ Executive", "UZ Electric", "UZ Electric SUV"
]

const GERMAN_STYLE := [
    "Bavaria Compact", "Bavaria Sedan", "Bavaria Touring", "Bavaria Coupe", "Bavaria M Sport",
    "Bavaria X SUV", "Bavaria Luxury", "Bavaria Grand Sedan", "Rhine Compact", "Rhine Sedan",
    "Rhine Estate", "Rhine Coupe", "Rhine AMG Style", "Rhine SUV", "Rhine G-Class Style",
    "Rhine Maybach Style", "Ingolstadt A Sedan", "Ingolstadt S Sedan", "Ingolstadt RS Coupe",
    "Ingolstadt Q SUV", "Ingolstadt R Sport"
]

const SUPERCAR_STYLE := [
    "Italian V10", "Italian V12", "Italian Track", "Italian GT", "Italian Hyper",
    "Red GT", "Red V8", "Red V12", "Red Track", "Red Hyper",
    "British GT", "British Super", "British Track", "British Hyper",
    "Stuttgart GT", "Stuttgart Turbo", "Stuttgart GT3", "Stuttgart SUV"
]

const FANTASY := [
    "Batmobile X", "Night Batmobile", "Galaxy Runner", "Nebula GT", "Meteor SUV",
    "Quantum Hyper", "Cyber Racer", "Star Cruiser", "Gravity Car", "Portal Runner"
]

static func _make_entries(names: Array, prefix: String, base_price: int, speed_base: int) -> Array:
    var result: Array = []
    for i in names.size():
        result.append({
            "id": "%s_%03d" % [prefix, i + 1],
            "name": names[i],
            "type": "car",
            "price": base_price + i * 5000,
            "speed": speed_base + (i % 10) * 8,
            "unlocked_for_owner": true
        })
    return result

static func all_cars() -> Array:
    return _make_entries(UZ_STYLE, "uz", 10000, 130) \
        + _make_entries(GERMAN_STYLE, "de", 35000, 165) \
        + _make_entries(SUPERCAR_STYLE, "super", 120000, 250) \
        + _make_entries(FANTASY, "fantasy", 500000, 320)

static func all_transport() -> Array:
    var base = load("res://data/vehicle_catalog.gd")
    return base.all_vehicles() + all_cars()
