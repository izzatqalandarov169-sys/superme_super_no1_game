extends RefCounted

const UZ_STYLE := [
    "Chevrolet Matiz", "Chevrolet Spark", "Chevrolet Nexia", "Chevrolet Nexia 2", "Chevrolet Nexia 3", "Chevrolet Cobalt", "Chevrolet Gentra", "Chevrolet Lacetti", "Chevrolet Damas", "Chevrolet Labo", "Chevrolet Orlando", "Chevrolet Captiva", "Chevrolet Malibu", "Chevrolet Malibu 2", "Chevrolet Equinox", "Chevrolet Tracker", "Chevrolet Trailblazer", "Chevrolet Traverse", "Chevrolet Tahoe", "Chevrolet Suburban", "Chevrolet Onix", "Chevrolet Monza", "Chevrolet Blazer", "Chevrolet Camaro", "Chevrolet Corvette", "Chevrolet Impala", "Chevrolet Cruze", "Chevrolet Aveo", "Daewoo Tico", "Daewoo Espero", "Daewoo Nexia", "Daewoo Matiz", "Daewoo Damas", "UzAuto Sedan Classic", "UzAuto Sedan Comfort", "UzAuto Sedan Premium", "UzAuto Crossover", "UzAuto SUV", "UzAuto Electric", "UzAuto Pickup"
]

const GERMAN_STYLE := [
    "BMW 1 Series", "BMW 2 Series", "BMW 3 Series", "BMW 4 Series", "BMW 5 Series", "BMW 6 Series", "BMW 7 Series", "BMW 8 Series", "BMW X1", "BMW X2", "BMW X3", "BMW X4", "BMW X5", "BMW X6", "BMW X7", "BMW XM", "BMW M2", "BMW M3", "BMW M4", "BMW M5", "BMW M8", "Mercedes A-Class", "Mercedes B-Class", "Mercedes C-Class", "Mercedes E-Class", "Mercedes S-Class", "Mercedes CLA", "Mercedes CLS", "Mercedes GLA", "Mercedes GLB", "Mercedes GLC", "Mercedes GLE", "Mercedes GLS", "Mercedes G-Class", "Mercedes-Maybach S-Class", "Mercedes-Maybach GLS", "Audi A3", "Audi A4", "Audi A5", "Audi A6", "Audi A7", "Audi A8", "Audi Q3", "Audi Q5", "Audi Q7", "Audi Q8", "Audi R8", "Audi RS3", "Audi RS5", "Audi RS6", "Audi RS7", "Audi RSQ8"
]

const SUPERCAR_STYLE := [
    "Ferrari 488", "Ferrari F8", "Ferrari Roma", "Ferrari SF90", "Ferrari 296 GTB", "Ferrari 812", "Ferrari Purosangue", "Lamborghini Huracan", "Lamborghini Aventador", "Lamborghini Revuelto", "Lamborghini Urus", "Lamborghini Gallardo", "McLaren 570S", "McLaren 720S", "McLaren 750S", "McLaren Artura", "McLaren GT", "Bugatti Chiron", "Bugatti Veyron", "Bugatti Divo", "Bugatti Mistral", "Porsche 911", "Porsche Taycan", "Porsche Cayenne", "Porsche Panamera", "Porsche 718", "Aston Martin DB11", "Aston Martin DB12", "Aston Martin Vantage", "Aston Martin DBS", "Maserati MC20", "Maserati GranTurismo", "Koenigsegg Jesko", "Koenigsegg Regera", "Pagani Huayra", "Pagani Utopia", "Rimac Nevera", "Tesla Model S", "Tesla Model 3", "Tesla Model X", "Tesla Model Y", "Tesla Cybertruck", "Lotus Emira", "Lotus Evija"
]

const FANTASY := ["Batmobile X", "Night Batmobile", "Galaxy Runner", "Nebula GT", "Meteor SUV", "Quantum Hyper", "Cyber Racer", "Star Cruiser", "Gravity Car", "Portal Runner"]

static func _make_entries(names: Array, prefix: String, base_price: int, speed_base: int) -> Array:
    var result: Array = []
    for i in names.size():
        result.append({"id": "%s_%03d" % [prefix, i + 1], "name": names[i], "type": "car", "price": base_price + i * 5000, "speed": speed_base + (i % 10) * 8, "unlocked_for_owner": true})
    return result

static func all_cars() -> Array:
    return _make_entries(UZ_STYLE, "uz", 10000, 130) + _make_entries(GERMAN_STYLE, "de", 35000, 165) + _make_entries(SUPERCAR_STYLE, "super", 120000, 250) + _make_entries(FANTASY, "fantasy", 500000, 320)

static func all_transport() -> Array:
    var base = load("res://data/vehicle_catalog.gd")
    return base.all_vehicles() + all_cars()
