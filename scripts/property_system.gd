extends Node

# Offline property ownership and garage slots.
var properties: Array = []
var garage_slots := 12

func _ready() -> void:
    for i in range(1, 13):
        properties.append({
            "id": i,
            "name": "Uy #%02d" % i,
            "price": 25000 + i * 15000,
            "owned": true,
            "garage_slots": 1 + (i % 4)
        })

func owned_properties() -> Array:
    return properties.filter(func(p): return p.owned)
