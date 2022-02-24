//
//  ViewController.swift
//  MyCars
//
//  Created by Ivan Akulov on 08/02/20.
//  Copyright © 2020 Ivan Akulov. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var context: NSManagedObjectContext!
    var selectedCar: Car!
    lazy var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .none
        return df
    }()
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!{ //когда инициализирован
        didSet{
            updateSegmentedControl()
            //чтобы текст был белым
            let whiteTitleTextAtribut = [NSAttributedString.Key.foregroundColor: UIColor.white]
            let blackTitleTextAtribut = [NSAttributedString.Key.foregroundColor: UIColor.black]
            
            UISegmentedControl.appearance().setTitleTextAttributes(whiteTitleTextAtribut, for: .normal)
            UISegmentedControl.appearance().setTitleTextAttributes(blackTitleTextAtribut, for: .selected)
            //
        }
    }
    @IBOutlet weak var markLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var carImageView: UIImageView!
    @IBOutlet weak var lastTimeStartedLabel: UILabel!
    @IBOutlet weak var numberOfTripsLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var myChoiceImageView: UIImageView!
    
    @IBAction func segmentedCtrlPressed(_ sender: UISegmentedControl) {
        updateSegmentedControl()
        sender.tintColor = .white
    }
    
    
    //увеличивает количество поездок на 1
    @IBAction func startEnginePressed(_ sender: UIButton) {
        selectedCar.timesDriven += 1
        selectedCar.lastStarted = Date()
        
        //сохраняем контекст
        do{
            try context.save()
            insertDataFrom(selectedCar: selectedCar)
        }catch let error as NSError{
            print(error.localizedDescription)
        }
        
    }
    //рейтинг, оценка
    @IBAction func rateItPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Rate it", message: "Rate this car, please", preferredStyle: .alert)
        let rateAction = UIAlertAction(title: "Rate", style: .default) { action in
            if let text = alertController.textFields?.first?.text{
                self.update(rating: (text as NSString).doubleValue)
            }
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addTextField { textField in
            textField.keyboardType = .numberPad
        }
        alertController.addAction(rateAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func updateSegmentedControl(){
        let fetchRequest: NSFetchRequest<Car> = Car.fetchRequest()
        let mark = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)
        fetchRequest.predicate = NSPredicate(format: "mark == %@", mark!)
        do{
            let results = try context.fetch(fetchRequest)
            selectedCar = results.first
            insertDataFrom(selectedCar: selectedCar!)
        }catch let error as NSError{
            print(error.localizedDescription)
        }
        
    }
    private func update(rating: Double){
        selectedCar.rating = rating
        
        do{
            try context.save()
            insertDataFrom(selectedCar: selectedCar)
        }catch let error as NSError{
            let alert = UIAlertController(title: "Wrong value", message: "Wrong input", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            print(error.localizedDescription)
        }
    }
    
    
    
    private func insertDataFrom(selectedCar car: Car){
        carImageView.image = UIImage(data: car.imageData!)
        markLabel.text = car.mark
        modelLabel.text = car.model
        myChoiceImageView.isHidden = !(car.myChoice)
        ratingLabel.text = "Rating: \(car.rating)/10"
        numberOfTripsLabel.text = "Number of trips: \(car.timesDriven)"
        
        lastTimeStartedLabel.text = "last time started: \(dateFormatter.string(from: car.lastStarted!))"
        segmentedControl.backgroundColor = car.tintColor as? UIColor
    }
    
    private func getDataFromFile(){
        let fetchRequest: NSFetchRequest<Car> = Car.fetchRequest()
        //что хотим получить, фильтруем данные
        fetchRequest.predicate = NSPredicate(format: "mark != nil")
        var records = 0
        do{
            records = try context.count(for: fetchRequest)
            print("Is data there alredy")
        }catch let error as NSError{
            print(error.localizedDescription)
        }
        guard records == 0 else {return}
        
        guard let pathToFile = Bundle.main.path(forResource: "data", ofType: "plist"), let dataArray = NSArray(contentsOfFile: pathToFile) else {return}
        for dictionary in dataArray{
            let entity = NSEntityDescription.entity(forEntityName: "Car", in: context)
            let car = NSManagedObject(entity: entity!, insertInto: context) as! Car
            let carDictionary = dictionary as! [String: AnyObject]
            car.mark = carDictionary["mark"] as? String
            car.model = carDictionary["model"] as? String
            car.rating = carDictionary["rating"] as! Double
            car.lastStarted = carDictionary["lastStarted"] as? Date
            car.timesDriven = carDictionary["timesDriven"] as! Int16
            car.myChoice = carDictionary["myChoice"] as! Bool
            let imageName = carDictionary["imageName"] as? String
            let image = UIImage(named: imageName!)
            let imageData = image!.pngData()
            car.imageData = imageData
            
            //работа с цветом для преобразования
            if let colorDictionary = carDictionary["tintColor"] as? [String: Float]{
                //цвет в виде массива
                car.tintColor = getColor(colorDictionary: colorDictionary)
            }
        }
        //        let userDefaults = UserDefaults.standard
        //        userDefaults.set(true, forKey: "dataWasLoaded")
    }
    //получение цвета из массива
    private func getColor(colorDictionary: [String : Float]) -> UIColor{
        guard let red = colorDictionary["red"], let green = colorDictionary["green"], let blue = colorDictionary["blue"] else {return UIColor()}
        return UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1.0) //прозрачность
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDataFromFile()
        
        //
        //        let fetchRequest: NSFetchRequest<Car> = Car.fetchRequest()
        //        let mark = segmentedControl.titleForSegment(at: 0)
        //        fetchRequest.predicate = NSPredicate(format: "mark == %@", mark!)
        //
        //        do{
        //            let results = try context.fetch(fetchRequest)
        //            selectedCar = results.first
        //            insertDataFrom(selectedCar: selectedCar!)
        //        }catch let error as NSError{
        //            print(error.localizedDescription)
        //        }
        
        //        let userDefaults = UserDefaults.standard
        //        let presentationWasViewed = userDefaults.bool(forKey: "dataWasLoaded")
        //        if presentationWasViewed == false{
        //        // Do any additional setup after loading the view, typically from a nib.
        //        getDataFromFile()
        //
        //        }
        
    }
}

