//
//  TableViewCell.swift
//  mobile
//
//  Created by NguyenSon_MP on 17/03/2023.
//

import UIKit

class TicketTableViewCell: UITableViewCell {

    @IBOutlet weak var ownerView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var img: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        img.layer.cornerRadius = 10
        mainView.layer.cornerRadius = 10
        mainView.layer.masksToBounds = true
        ownerView.layer.cornerRadius = 10
        ownerView.layer.masksToBounds = true
        ownerView.layer.borderColor =   UIColor.blue.cgColor
        ownerView.layer.borderWidth = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
