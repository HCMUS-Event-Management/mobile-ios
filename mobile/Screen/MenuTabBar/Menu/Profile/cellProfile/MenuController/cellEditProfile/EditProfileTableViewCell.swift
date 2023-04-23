//
//  EditProfileTableViewCell.swift
//  mobile
//
//  Created by NguyenSon_MP on 28/02/2023.
//

import UIKit

class EditProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var avatar: UIImageView!
    var callback : (() -> Void)?

    private var VM = ProfileViewModel()
    @IBOutlet weak var btnEditImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        btnEditImage.isUserInteractionEnabled = true
        btnEditImage.addGestureRecognizer(tapGestureRecognizer)
        btnEditImage.layer.cornerRadius = 5
        btnEditImage.layer.masksToBounds = true
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView

        // Your action 

        callback?()

        print(11)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
