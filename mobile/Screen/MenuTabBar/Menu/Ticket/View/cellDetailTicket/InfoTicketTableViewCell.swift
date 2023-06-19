//
//  InfoTicketTableViewCell.swift
//  mobile
//
//  Created by NguyenSon_MP on 17/03/2023.
//

import UIKit

class InfoTicketTableViewCell: UITableViewCell {

    @IBOutlet weak var eventTicket: UILabel!
    @IBOutlet weak var buyerId: UILabel!
    @IBOutlet weak var mainView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mainView.layer.cornerRadius = 10
        mainView.layer.masksToBounds = true

    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
