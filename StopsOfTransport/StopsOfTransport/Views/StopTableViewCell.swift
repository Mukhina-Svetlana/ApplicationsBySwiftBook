//
//  StopTableViewCell.swift
//  StopsOfTransport
//
//  Created by Светлана Мухина on 28.02.2022.
//

import UIKit

class StopTableViewCell: UITableViewCell {
    
    @IBOutlet weak var stopNameLabel: UILabel!
    
    weak var cellViewModel: TableViewCellViewModelType? {
        willSet(cellViewModel) {
            guard let cellViewModel = cellViewModel else { return }
            stopNameLabel.text = cellViewModel.stopName
        }
    }

}
