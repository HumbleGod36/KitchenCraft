//
//  RecomendedTableViewCell.swift
//  KitchenCraft
//
//  Created by Tony Michael on 15/02/24.
//

import UIKit

class RecomendedTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var viewReceipeButton: UIButton!
    @IBOutlet weak var DishArea: UILabel!
    @IBOutlet weak var dishDisc: UILabel!
    @IBOutlet weak var dishName: UILabel!
    @IBOutlet weak var dishImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
