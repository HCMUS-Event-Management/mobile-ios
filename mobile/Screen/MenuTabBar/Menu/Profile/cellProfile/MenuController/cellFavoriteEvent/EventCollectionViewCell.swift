//
//  EventCollectionViewCell.swift
//  mobile
//
//  Created by NguyenSon_MP on 23/02/2023.
//

import UIKit

class EventCollectionViewCell: UICollectionViewCell {
    var callback : (() -> Void)?

    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var paidName: UILabel!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var owner: UILabel!
    @IBOutlet weak var timeStart: UILabel!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var paidView: UIView!
    @IBOutlet weak var archiveView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var btnSeeDetail: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        preUI()
        btnSeeDetail.addTarget(self, action: #selector(changeDetail), for: .touchUpInside)
        
        
    }
    
    @objc func changeDetail() {
        callback?()
    }
    func preUI() {
        btnSeeDetail.layer.cornerRadius = 10
        btnSeeDetail.layer.masksToBounds = true
        
        paidView.layer.cornerRadius = 10
        paidView.layer.masksToBounds = true
        
        imgAvatar.layer.cornerRadius = 20
        imgAvatar.layer.masksToBounds = true
        
        
        archiveView.layer.cornerRadius = 5
        archiveView.layer.masksToBounds = true
        
        mainView.layer.cornerRadius = 10
        mainView.layer.masksToBounds = true
        
        mainView.layer.borderColor = UIColor.gray.cgColor
        mainView.layer.borderWidth = 0.5
    }
    

    
    

}
