//
//  SecondScreen.swift
//  MyPlaces
//
//  Created by Светлана Мухина on 02.12.2021.
//

import UIKit
import Cosmos

class SecondScreen: UITableViewController {
    var currentPlace: Place?
    //var newPlace: Place?
    //var newPlace = Place()
    var imageIsChanged: Bool = false
    var currentRating = 0.0
    @IBOutlet weak var placeImage: UIImageView!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var placeName: UITextField!
    @IBOutlet weak var placeLocation: UITextField!
    @IBOutlet weak var placeType: UITextField!
    
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var ratingControl: RatingControl!
    override func viewDidLoad() {
        //загрузка временных данных в базу
//        DispatchQueue.main.async {
//            self.newPlace.savePlaces()
//        }
        super.viewDidLoad()
       // tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        saveButton.isEnabled = false
        placeName.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        setupEditScreen()
        cosmosView.didTouchCosmos = { rating in
            self.currentRating = rating
            
        }
    }

//    @IBAction func nameAction(_ sender: UITextField) {
//        if sender.text?.isEmpty == false{
//            saveButton.isEnabled = true
//        }else{
//            saveButton.isEnabled = false
//        }
//    }
    //MARK: Table View delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //по нажатию на ячейку
        if indexPath.row == 0{
            let cameraIcon = #imageLiteral(resourceName: "camera")
            let photoIcon = UIImage(named: "photo")
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let camera = UIAlertAction(title: "Camera", style: .default) { _ in
                self.chooseImagePiacker(source: .camera)
            }
            camera.setValue(cameraIcon, forKey: "image")
            camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let photo = UIAlertAction(title: "Photo", style: .default) { _ in
                self.chooseImagePiacker(source: .photoLibrary)
            }
            photo.setValue(photoIcon, forKey: "image")
            photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            actionSheet.addAction(camera)
            actionSheet.addAction(photo)
            actionSheet.addAction(cancel)
            present(actionSheet, animated: true, completion: nil)
            
        }else{
            view.endEditing(true)
        }
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier,let mapVC = segue.destination as? MapViewController else {return}
        //if segue.identifier != "showMap"{return}
        //let mapVC = segue.destination as! MapViewController
        mapVC.segueIndentifier = identifier
        mapVC.mapViewControllerDelegate = self
        if identifier == "showMap"{
        mapVC.place.name = placeName.text!
        mapVC.place.location = placeLocation.text
        mapVC.place.type = placeType.text
        mapVC.place.image = placeImage.image?.pngData()
        }
    }
    func savePlace() {
        let image = imageIsChanged ? placeImage.image : UIImage(named: "imagePlaceholder")
        //let newPlace = Place()
        
//        var image: UIImage?
//        if imageIsChanged{
//            image = placeImage.image
//        }else{
//            image = UIImage(named: "imagePlaceholder")
//        }
        
//        newPlace.name = placeName.text!
//        newPlace.location = placeLocation.text
//        newPlace.type = placeType.text
//        newPlace.image = image?.pngData()
        
        //или так - создали вручную инициализатор
        let newPlace = Place(name: placeName.text!, location: placeLocation.text, type: placeType.text, image: image?.pngData(), rating: cosmosView.rating) //Double(ratingControl.rating))
        
        
        if currentPlace != nil{
            try! realm.write{
                currentPlace?.name = newPlace.name
                currentPlace?.location = newPlace.location
                currentPlace?.type = newPlace.type
                currentPlace?.image = newPlace.image
                currentPlace?.rating = newPlace.rating
            }
        } else {
        StorageManager.saveObject(newPlace)
        }
        
        //newPlace = Place(name: placeName.text!, location: placeLocation.text, type: placeType.text, image: image, resturantImage: nil)
    }
    
    
    
    private func setupEditScreen(){
        if currentPlace != nil{
            setupNavigationBar()
            imageIsChanged = true
            if let data = currentPlace?.image, let imagee = UIImage(data: data){
                placeImage.image = imagee
                placeImage.contentMode = .scaleAspectFill
                placeName.text = currentPlace?.name
                placeType.text = currentPlace?.type
                placeLocation.text = currentPlace?.location
                cosmosView.rating = currentPlace!.rating
                //ratingControl.rating = Int(currentPlace!.rating)
                
            }
        }
        
    }
    
    private func setupNavigationBar(){
    
        if let topItem = navigationController?.navigationBar.topItem{
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)}
//        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.leftBarButtonItem = nil
        //navigationItem.largeTitleDisplayMode = .always
        title = currentPlace?.name
        saveButton.isEnabled = true
        
    }
    
    @IBAction func cancelTaped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
}

//MARK: Text Field delegate
extension SecondScreen: UITextFieldDelegate{
    //Cкрываем клавиатуру по нажатию на Done
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    @objc private func textFieldChanged(){
        if placeName.text?.isEmpty == false {
            saveButton.isEnabled = true
        } else{
            saveButton.isEnabled = false
        }
    }
}

//MARK: Work with image
extension SecondScreen: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func chooseImagePiacker(source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        placeImage.image = info[.editedImage] as? UIImage
        placeImage.contentMode = .scaleAspectFill
        placeImage.clipsToBounds = true
        imageIsChanged = true
        dismiss(animated: true, completion: nil)
    }
}

extension SecondScreen: MapViewControllerDelegate{
    func getAddress(_ address: String?) {
        placeLocation.text = address
    }
}
