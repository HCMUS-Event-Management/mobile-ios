//
//  PaymentHistoryTableViewCell.swift
//  mobile
//
//  Created by NguyenSon_MP on 18/05/2023.
//

import UIKit
class PaymentHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var owner: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var desciption: UILabel!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var mainView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mainView.borderColor = UIColor(red: 94/255, green: 135/255, blue: 240/255, alpha: 1)
        mainView.borderWidth = 0.5
        mainView.cornerRadius = 10
        mainView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
