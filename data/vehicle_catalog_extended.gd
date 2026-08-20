extends RefCounted

const UZ_STYLE := [
"Chevrolet Matiz","Chevrolet Spark","Chevrolet Nexia","Chevrolet Nexia 2","Chevrolet Nexia 3","Chevrolet Cobalt","Chevrolet Gentra","Chevrolet Lacetti","Chevrolet Damas","Chevrolet Labo","Chevrolet Orlando","Chevrolet Captiva","Chevrolet Malibu","Chevrolet Malibu 2","Chevrolet Equinox","Chevrolet Tracker","Chevrolet Trailblazer","Chevrolet Traverse","Chevrolet Tahoe","Chevrolet Suburban","Chevrolet Onix","Chevrolet Monza","Chevrolet Blazer","Chevrolet Camaro","Chevrolet Corvette","Chevrolet Impala","Chevrolet Cruze","Chevrolet Aveo","Daewoo Tico","Daewoo Espero","Daewoo Nexia","Daewoo Matiz","Daewoo Damas","UzAuto Sedan Classic","UzAuto Sedan Comfort","UzAuto Sedan Premium","UzAuto Crossover","UzAuto SUV","UzAuto Electric","UzAuto Pickup"]

const GERMAN_STYLE := [
"BMW 1 Series","BMW 2 Series","BMW 3 Series","BMW 4 Series","BMW 5 Series","BMW 6 Series","BMW 7 Series","BMW 8 Series","BMW X1","BMW X2","BMW X3","BMW X4","BMW X5","BMW X6","BMW X7","BMW XM","BMW M2","BMW M3","BMW M4","BMW M5","BMW M8","Mercedes A-Class","Mercedes B-Class","Mercedes C-Class","Mercedes E-Class","Mercedes S-Class","Mercedes CLA","Mercedes CLS","Mercedes GLA","Mercedes GLB","Mercedes GLC","Mercedes GLE","Mercedes GLS","Mercedes G-Class","Mercedes-Maybach S-Class","Mercedes-Maybach GLS","Audi A3","Audi A4","Audi A5","Audi A6","Audi A7","Audi A8","Audi Q3","Audi Q5","Audi Q7","Audi Q8","Audi R8","Audi RS3","Audi RS5","Audi RS6","Audi RS7","Audi RSQ8"]

const SUPERCAR_STYLE := [
"Ferrari 488","Ferrari F8","Ferrari Roma","Ferrari SF90","Ferrari 296 GTB","Ferrari 812","Ferrari Purosangue","Lamborghini Huracan","Lamborghini Aventador","Lamborghini Revuelto","Lamborghini Urus","Lamborghini Gallardo","McLaren 570S","McLaren 720S","McLaren 750S","McLaren Artura","McLaren GT","Bugatti Chiron","Bugatti Veyron","Bugatti Divo","Bugatti Mistral","Porsche 911","Porsche Taycan","Porsche Cayenne","Porsche Panamera","Porsche 718","Aston Martin DB11","Aston Martin DB12","Aston Martin Vantage","Aston Martin DBS","Maserati MC20","Maserati GranTurismo","Koenigsegg Jesko","Koenigsegg Regera","Pagani Huayra","Pagani Utopia","Rimac Nevera","Tesla Model S","Tesla Model 3","Tesla Model X","Tesla Model Y","Tesla Cybertruck","Lotus Emira","Lotus Evija"]

const JAPANESE_STYLE := [
"Toyota Camry","Toyota Corolla","Toyota Prius","Toyota RAV4","Toyota Land Cruiser","Toyota Hilux","Toyota Supra","Toyota GR86","Toyota GR Yaris","Lexus IS","Lexus ES","Lexus LS","Lexus NX","Lexus RX","Lexus GX","Lexus LX","Lexus LC","Nissan Sunny","Nissan Altima","Nissan X-Trail","Nissan Patrol","Nissan Pathfinder","Nissan Z","Nissan GT-R","Honda Civic","Honda Accord","Honda CR-V","Honda HR-V","Honda Pilot","Honda Civic Type R","Subaru WRX","Subaru BRZ","Subaru Forester","Mazda3","Mazda6","Mazda CX-5","Mazda CX-60","Mazda MX-5"]

const OTHER_STYLE := [
"Ford Mustang","Ford Bronco","Ford Explorer","Ford Expedition","Ford F-150","Ford Ranger","Land Rover Defender","Range Rover","Range Rover Sport","Range Rover Evoque","Bentley Continental GT","Bentley Bentayga","Rolls-Royce Ghost","Rolls-Royce Phantom","Rolls-Royce Cullinan","Jeep Wrangler","Jeep Grand Cherokee","Dodge Charger","Dodge Challenger","Dodge Durango","Volkswagen Golf","Volkswagen Passat","Volkswagen Tiguan","Volkswagen Touareg","Volvo XC60","Volvo XC90","Kia K5","Kia Sportage","Hyundai Sonata","Hyundai Tucson","Hyundai Santa Fe"]

const MOTORCYCLES := [
"Yamaha MT-07","Yamaha MT-09","Yamaha MT-10","Yamaha R1","Yamaha R7","Yamaha R6","Honda CBR600RR","Honda CBR1000RR","Honda CB650R","Honda Africa Twin","Kawasaki Ninja 400","Kawasaki Ninja 650","Kawasaki ZX-6R","Kawasaki ZX-10R","Kawasaki Ninja H2","Suzuki GSX-R600","Suzuki GSX-R750","Suzuki GSX-R1000","Suzuki Hayabusa","Ducati Panigale V2","Ducati Panigale V4","Ducati Monster","Ducati Streetfighter V4","BMW S1000RR","BMW S1000R","BMW R1300GS","BMW M1000RR","KTM Duke 390","KTM Duke 790","KTM Duke 1290","KTM RC 390","Harley-Davidson Sportster","Harley-Davidson Road King","Triumph Street Triple","Triumph Speed Triple","Aprilia RSV4","Aprilia Tuono V4","MV Agusta F3","MV Agusta Brutale","Royal Enfield Classic 350","Royal Enfield Himalayan","Indian Scout","Indian Challenger","Suzuki V-Strom","Honda Gold Wing","Yamaha Tenere 700","Kawasaki Z900","Honda CBR500R","Ducati Multistrada","BMW R1250GS"]

static func _make_cars(names: Array, prefix: String, base_price: int, speed_base: int) -> Array:
    var result: Array = []
    for i in names.size():
        var model: String = names[i]
        result.append({"id":"%s_%03d" % [prefix,i+1],"name":model,"type":"car","price":base_price+i*5000,"speed":speed_base+(i%12)*7,"acceleration":3.0+float(i%10)*0.25,"unlocked_for_owner":true})
    return result

static func _make_motos(names: Array) -> Array:
    var result: Array = []
    for i in names.size():
        result.append({"id":"moto_%03d" % (i+1),"name":names[i],"type":"motorcycle","price":8000+i*650,"speed":170+(i%18)*6,"acceleration":2.0+float(i%8)*0.15,"unlocked_for_owner":true})
    return result

static func all_cars() -> Array:
    return _make_cars(UZ_STYLE,"uz",10000,130)+_make_cars(GERMAN_STYLE,"de",35000,165)+_make_cars(SUPERCAR_STYLE,"super",120000,250)+_make_cars(JAPANESE_STYLE,"jp",25000,155)+_make_cars(OTHER_STYLE,"other",22000,150)

static func all_transport() -> Array:
    var base = load("res://data/vehicle_catalog.gd")
    var result: Array = base.all_vehicles()+all_cars()+_make_motos(MOTORCYCLES)
    var custom_index := 1
    while result.size() < 320:
        result.append({"id":"superme_custom_%03d" % custom_index,"name":"SUPERME Custom %03d" % custom_index,"type":"car","price":30000+custom_index*1000,"speed":180+(custom_index%40)*4,"acceleration":4.0,"class":"custom","unlocked_for_owner":true})
        custom_index += 1
    return result

static func all_unlocked_for_owner() -> Array:
    return all_transport().duplicate(true)
