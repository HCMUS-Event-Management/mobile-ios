//
//  LoadingTableViewCell.swift
//  mobile
//
//  Created by NguyenSon_MP on 06/04/2023.
//

import UIKit

class LoadingTableViewCell: UITableViewCell {

    @IBOutlet weak var indicator: UIActivityIndicatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
