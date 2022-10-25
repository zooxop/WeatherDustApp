//
//  DailyCollectionViewCell.swift
//  WeatherApp
//
//  Created by 문철현 on 2022/10/24.
//

import UIKit

class DailyCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var repIconImageView: UIImageView!
    @IBOutlet weak var minMaxTempLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
