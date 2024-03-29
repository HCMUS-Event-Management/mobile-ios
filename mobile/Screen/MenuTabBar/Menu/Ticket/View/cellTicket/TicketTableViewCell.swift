//
//  TableViewCell.swift
//  mobile
//
//  Created by NguyenSon_MP on 17/03/2023.
//

import UIKit

class TicketTableViewCell: UITableViewCell {
    @IBOutlet weak var isChecking: UIImageView!
    @IBOutlet weak var paidName: UILabel!
    @IBOutlet weak var ownerName: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var startTimeSession: UILabel!
    @IBOutlet weak var titleEvent: UILabel!
    @IBOutlet weak var ownerView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var paidView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        img.layer.cornerRadius = 15
        img.layer.borderWidth = 0.5
        img.layer.borderColor = UIColor(red: 94/255, green: 135/255, blue: 240/255, alpha: 1).cgColor
        mainView.layer.cornerRadius = 10
        mainView.layer.masksToBounds = true
        ownerView.layer.cornerRadius = 10
        ownerView.layer.masksToBounds = true
        ownerView.layer.borderColor =  UIColor(red: 94/255, green: 135/255, blue: 240/255, alpha: 1).cgColor
        ownerView.layer.borderWidth = 1
        
        paidView.layer.cornerRadius = 10
        paidView.layer.masksToBounds = true
        
        isChecking.transform = isChecking.transform.rotated(by: .pi / 3.5)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
