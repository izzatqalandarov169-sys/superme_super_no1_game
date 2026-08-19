extends RefCounted

# 300+ offline income activities for the open world.
const CATEGORIES := [
    "Taxi", "Delivery", "Courier", "Mechanic", "Construction", "Farming", "Fishing",
    "Mining", "Warehouse", "Security", "Shop", "Restaurant", "Hotel", "Tourism",
    "Racing", "Transport", "Emergency", "Cleaning", "Repair", "Freelance"
]

static func all_activities() -> Array:
    var result: Array = []
    var id := 1
    for category in CATEGORIES:
        for variant in range(1, 17):
            result.append({
                "id": id,
                "name": "%s #%02d" % [category, variant],
                "payout": 100 + ((id * 73) % 4900),
                "duration": 30 + ((id * 11) % 150)
            })
            id += 1
    return result
