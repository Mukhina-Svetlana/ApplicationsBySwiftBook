//
//  RatingControl.swift
//  MyPlaces
//
//  Created by Светлана Мухина on 15.01.2022.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {
    
    //MARK: Properties
    var rating = 0
    {
        didSet{
            updateButtonSelectionState()
        }
    }
    private var ratingButtons = [UIButton]()
    @IBInspectable var starSize: CGSize = CGSize(width: 34.0, height: 34.0){
        didSet{
            setupButtons()
        }
    }
    @IBInspectable var starCount: Int = 5{
        didSet{
            setupButtons()
        }
    }
    

  //MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
        
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    //MARK: Button action
    @objc func ratingButtonTapped(button: UIButton){
        //print("Button presed 👍🏻")
        guard let index = ratingButtons.firstIndex(of: button) else {return}
        //Calculating of rating
        let selectedRating = index+1
        if selectedRating == rating{
            rating = 0
        }else{
            rating = selectedRating
        }
    }
    
    //MARK: Private methods
    private func setupButtons(){
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        
        //Load button image
        let bundle = Bundle(for: type(of: self))
        let filedStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let highLitedStar = UIImage(named: "highlightedStar", in: bundle, compatibleWith: self.traitCollection)
        
        
        
        for _ in 1...starCount{
            let button = UIButton()
            //button.backgroundColor = .red
            button.setImage(emptyStar, for: .normal)
            button.setImage(filedStar, for: .selected)
            button.setImage(highLitedStar, for: .highlighted)
            button.setImage(highLitedStar, for: [.highlighted,.selected])
        
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
        
        //Setup the button action
            button.addTarget(self, action: #selector(ratingButtonTapped(button:)), for: .touchUpInside)
        
            addArrangedSubview(button)
            //Add the new button on the rating button array
            ratingButtons.append(button)
        }
        updateButtonSelectionState()
    }
    
    private func updateButtonSelectionState(){
        for (index,button) in ratingButtons.enumerated(){
            button.isSelected = index < rating
        }
    }
}
