//
//  InfoTicketTableViewCell.swift
//  mobile
//
//  Created by NguyenSon_MP on 17/03/2023.
//

import UIKit

class InfoTicketTableViewCell: UITableViewCell {

    @IBOutlet weak var ownerName: UILabel!
    @IBOutlet weak var btnDonate: UIButton!
    @IBOutlet weak var eventTicket: UILabel!
    @IBOutlet weak var buyerId: UILabel!
    @IBOutlet weak var mainView: UIView!
    var callback : (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mainView.layer.cornerRadius = 10
        mainView.layer.masksToBounds = true
        btnDonate.addTarget(self, action: #selector(donateTicket), for: .touchUpInside)
        btnDonate.layer.cornerRadius = 5
        btnDonate.layer.masksToBounds = true

    }
    
    @objc func donateTicket() {
        callback?()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
