//
//  TableViewCell.swift
//  mobile
//
//  Created by NguyenSon_MP on 15/06/2023.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var descrip: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
