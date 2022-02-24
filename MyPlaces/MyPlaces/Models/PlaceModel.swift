//
//  PlaceModel.swift
//  MyPlaces
//
//  Created by Светлана Мухина on 01.12.2021.
//

import RealmSwift

class Place: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var location: String?
    @objc dynamic var type: String?
//    @objc dynamic var image: UIImage?  //добавление новых мест и фото
    @objc dynamic var image: Data?
    //var resturantImage: String? //для считывания уже готовых фото по названию
    @objc dynamic var date = Date()
    @objc dynamic var rating = 0.0
    
    convenience init(name: String, location: String?, type: String?, image: Data?, rating: Double){
        self.init()
        self.name = name
        self.location = location
        self.type = type
        self.image = image
        self.rating = rating
    }

    
    
//    let resturanNames = ["Burger Heroes", "Kitchen", "Bonsai", "Индокитай", "X.O" ,"Sherlock Holmes", "Speak Easy", "Love&Life", "Morris Pub","Вкусные истории","Классик","Шок","Балкан Гриль", "Бочка", "Дастархан"]
//
//
//    static func getPlaces() -> [Place] {
//        var place = [Place]()
//        for i in resturanNames{
//            place.append(Place(name: i, location: "НН", type: "Ресторан",image: nil, resturantImage: i))
//        }
//        return place
//    }
//
//
//    func savePlaces() {
//        for i in resturanNames{
//            let image = UIImage(named: i)
//            guard let imageData = image?.pngData() else {return}
//            let newPlace = Place()
//            newPlace.name = i
//            newPlace.location = "NN"
//            newPlace.type = "Resturant"
//            newPlace.image = imageData
//
//
//            StorageManager.saveObject(newPlace) //передача в базу данных
//        }
//    }
}
