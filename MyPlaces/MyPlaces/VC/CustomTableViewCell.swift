//
//  CustomTableViewCell.swift
//  MyPlaces
//
//  Created by Светлана Мухина on 29.11.2021.
//

import UIKit
import Cosmos

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var imageOfPlace: UIImageView!{
        didSet{
            imageOfPlace.layer.cornerRadius = imageOfPlace.frame.size.height/2
            imageOfPlace.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var namePlace: UILabel!
    @IBOutlet weak var locationPlace: UILabel!
    
    @IBOutlet weak var typePlace: UILabel!
    @IBOutlet weak var cosmosView: CosmosView!{
        didSet{
            cosmosView.settings.updateOnTouch = false
        }
    }
}
