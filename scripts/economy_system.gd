extends Node

# Offline economy foundation: money, jobs and activities. Data is intentionally
# simple so the system can scale to 300+ activities without network services.

var money: int = 1000000
var reputation: int = 0
var wanted_level: int = 0
var prison_seconds: int = 0

const ACTIVITIES := [
    "Taxi", "Delivery", "Courier", "Mechanic", "Driver", "Farmer", "Builder", "Guard",
    "Shopkeeper", "Rescuer", "Police", "Firefighter", "Medic", "Truck Driver", "Racer",
    "Street Cleaner", "Warehouse", "Fishing", "Mining", "Construction", "Pilot", "Tour Guide"
]

func earn(amount: int) -> void:
    money += maxi(amount, 0)

func spend(amount: int) -> bool:
    if amount <= money:
        money -= amount
        return true
    return false

func commit_crime(wanted_gain: int = 1) -> void:
    wanted_level = clampi(wanted_level + wanted_gain, 0, 5)

func clear_wanted() -> void:
    wanted_level = 0

func enter_prison(seconds: int = 300) -> void:
    prison_seconds = maxi(seconds, 0)

func tick_prison(delta: float) -> void:
    if prison_seconds > 0:
        prison_seconds = maxi(0, prison_seconds - int(delta))
