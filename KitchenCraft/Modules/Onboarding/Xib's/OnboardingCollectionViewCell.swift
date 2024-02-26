//
//  CollectionViewCell.swift
//  KitchenCraft
//
//  Created by Tony Michael on 12/02/24.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var nextButtonBackgroundView: UIView!
    
    @IBOutlet weak var imageBackGroundView: UIView!
    @IBOutlet weak var nextButtonClicked: UIButton!
    @IBOutlet weak var skipButtonClicked: UIButton!
    @IBOutlet weak var discription: UILabel!
    @IBOutlet weak var Header: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
