//
//  EventCollectionViewCell.swift
//  mobile
//
//  Created by NguyenSon_MP on 23/02/2023.
//

import UIKit

class EventCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var paidView: UIView!
    @IBOutlet weak var archiveView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var btnSeeDetail: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        preUI()
        
    }
    func preUI() {
        btnSeeDetail.layer.cornerRadius = 10
        btnSeeDetail.layer.masksToBounds = true
        
        paidView.layer.cornerRadius = 10
        paidView.layer.masksToBounds = true
        
        
        archiveView.layer.cornerRadius = 5
        archiveView.layer.masksToBounds = true
        
        mainView.layer.cornerRadius = 10
        mainView.layer.masksToBounds = true
        
        mainView.layer.borderColor = UIColor.gray.cgColor
        mainView.layer.borderWidth = 0.5
    }
    

    
    

}
