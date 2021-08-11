//
//  TableViewCell.swift
//  iOS_json
//
//  Created by ac1ra on 10.08.2021.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var nameCell: UILabel!
    @IBOutlet weak var attributeCell: UILabel!
    @IBOutlet weak var attackCell: UILabel!
    
    @IBOutlet weak var imgViewCell: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
