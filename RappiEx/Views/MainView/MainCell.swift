//
//  MainCell.swift
//  RappiEx
//
//  Created by Pablo Ramirez on 6/13/19.
//  Copyright © 2019 Pablo Ramirez. All rights reserved.
//

import Foundation
import UIKit

class MainCell: UICollectionViewCell{
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var movieImage: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var starImage: UIImageView!
    
    @IBOutlet weak var rankingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.cornerRadius = 5
        //containerView.layer.borderColor = UIColor(red: 45.0/255.0, green: 123.0/255.0, blue: 247.0/255.0, alpha: 1.0).cgColor
        //containerView.layer.borderWidth = 1
        
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.5
        containerView.layer.shadowOffset = CGSize(width: 0, height: 1)
        containerView.layer.shadowRadius = 1
    }
    
}
