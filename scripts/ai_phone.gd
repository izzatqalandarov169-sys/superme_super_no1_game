extends RefCounted

# Fictional offline phone AI. It answers game-related prompts without claiming
# to be the real ChatGPT service.
static func answer(text: String) -> String:
    var q := text.to_lower()
    if q.contains("mashina") or q.contains("moto"):
        return "Garajdan transport tanlang. Barcha egasi ochilgan transportlar katalogda ko‘rsatiladi."
    if q.contains("politsiya") or q.contains("102"):
        return "102: lokatsiyangiz bo‘yicha politsiya chaqirish mumkin."
    if q.contains("103"):
        return "103: tez yordam chaqiruvi yuborildi."
    if q.contains("101"):
        return "101: yong‘in xizmati chaqiruvi yuborildi."
    if q.contains("ish") or q.contains("pul"):
        return "Telefonning Ishlar bo‘limidan faoliyat tanlab pul toping."
    if q.contains("xarita") or q.contains("gps"):
        return "GPS sizning joriy o‘yin lokatsiyangizdan foydalanadi."
    return "Men SUPERME: UZBEK WORLD ichidagi yordamchiman. Xarita, transport, ishlar va o‘yin tizimlari haqida yordam bera olaman."
