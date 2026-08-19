extends RefCounted

# SUPERME: UZBEK WORLD — offline vehicle catalog.
# Original placeholder names are used until licensed vehicle assets are available.

const CARS := [
    {"id":"sedan_01","name":"UZ Sedan 01","type":"car","price":18000,"speed":165},
    {"id":"sedan_02","name":"UZ Sedan 02","type":"car","price":22000,"speed":175},
    {"id":"suv_01","name":"UZ SUV 01","type":"car","price":42000,"speed":185},
    {"id":"sport_01","name":"Super Sport 01","type":"car","price":95000,"speed":280},
    {"id":"sport_02","name":"Super Sport 02","type":"car","price":125000,"speed":305},
    {"id":"lux_01","name":"Luxury 01","type":"car","price":150000,"speed":260}
]

const MOTORCYCLES := [
    {"id":"moto_%02d" % i,"name":"Street Moto %02d" % i,"type":"motorcycle","price":1200 + i * 350,"speed":95 + i * 2,"class":"street"}
    for i in range(1, 21)
] + [
    {"id":"sport_moto_%02d" % i,"name":"Sport Moto %02d" % i,"type":"motorcycle","price":12000 + i * 1100,"speed":180 + i * 4,"class":"sport"}
    for i in range(1, 31)
]

static func all_vehicles() -> Array:
    return CARS + MOTORCYCLES

static func all_unlocked_for_owner() -> Array:
    return all_vehicles().duplicate(true)
