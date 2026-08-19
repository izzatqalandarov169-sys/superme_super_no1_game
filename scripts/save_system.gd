extends Node

const SAVE_PATH := "user://superme_save.json"

func save_game(player: Node3D, economy: Node) -> bool:
    if player == null or economy == null:
        return false
    var data := {
        "player_position": [player.global_position.x, player.global_position.y, player.global_position.z],
        "money": economy.money,
        "reputation": economy.reputation,
        "wanted_level": economy.wanted_level
    }
    var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
    if file == null:
        return false
    file.store_string(JSON.stringify(data))
    return true

func load_game(player: Node3D, economy: Node) -> bool:
    if not FileAccess.file_exists(SAVE_PATH) or player == null or economy == null:
        return false
    var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
    if file == null:
        return false
    var parsed = JSON.parse_string(file.get_as_text())
    if typeof(parsed) != TYPE_DICTIONARY:
        return false
    var p: Array = parsed.get("player_position", [0.0, 1.2, 12.0])
    if p.size() >= 3:
        player.global_position = Vector3(float(p[0]), float(p[1]), float(p[2]))
    economy.money = int(parsed.get("money", economy.money))
    economy.reputation = int(parsed.get("reputation", economy.reputation))
    economy.wanted_level = int(parsed.get("wanted_level", 0))
    return true
