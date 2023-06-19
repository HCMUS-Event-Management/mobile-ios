//
//  OpenZoomTableViewCell.swift
//  mobile
//
//  Created by NguyenSon_MP on 17/06/2023.
//

import UIKit

protocol OpenZoomTableViewCellDelegate {
    func callApi()
}

class OpenZoomTableViewCell: UITableViewCell {
    var delegate: OpenZoomTableViewCellDelegate?

    @IBOutlet weak var viewImg: UIView!
    @IBOutlet weak var viewBtn: UIView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var btnOpenZoom: UIButton!
    var zoomURL: String?
    var info: VadilateTicketDto?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnOpenZoom.addTarget(self, action: #selector(openZoomLink), for: .touchUpInside)
        viewImg.layer.masksToBounds = true
        viewImg.layer.cornerRadius = 10
        viewImg.layer.borderWidth = 0.2
        viewImg.layer.borderColor = UIColor.gray.cgColor
        viewBtn.layer.masksToBounds = true
        viewBtn.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // Action method for opening the Zoom link
    @objc func openZoomLink() {
        
        
        delegate?.callApi()

//        // Replace "zoom_link_here" with your actual Zoom link

    }
    
}
