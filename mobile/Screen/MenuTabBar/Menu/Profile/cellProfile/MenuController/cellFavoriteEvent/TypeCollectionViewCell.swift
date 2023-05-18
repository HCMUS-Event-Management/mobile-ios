//
//  TypeCollectionViewCell.swift
//  mobile
//
//  Created by NguyenSon_MP on 23/02/2023.
//

import UIKit

class TypeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var viewLbl: UIView!
    override var isSelected: Bool {
        didSet {
            contentView.backgroundColor = isSelected ? .red : .white
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        preUI()
    }
    
    
    func preUI() {
        viewLbl.layer.cornerRadius = 12
        viewLbl.layer.masksToBounds = true
    }

}
