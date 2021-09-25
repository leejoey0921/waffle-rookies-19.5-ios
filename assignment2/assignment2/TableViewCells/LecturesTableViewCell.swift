//
//  LecturesTableViewCell.swift
//  assignment2
//
//  Created by Joey Lee on 2021/09/24.
//

import UIKit

class LecturesTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var credit: UILabel!
    @IBOutlet weak var arrow: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
