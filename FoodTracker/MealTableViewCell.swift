//
//  MealTableViewCell.swift
//  FoodTracker
//
//  Created by Kevin Cleathero on 2017-07-02.
//  Copyright © 2017 Kevin Cleathero. All rights reserved.
//

import UIKit

class MealTableViewCell: UITableViewCell {

//MARK: Properties
    
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var photoImageView: UIImageView!
    
    @IBOutlet var ratingControl: RatingControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
