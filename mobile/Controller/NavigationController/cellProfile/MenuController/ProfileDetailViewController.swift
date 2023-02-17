//
//  ProfileDetailViewController.swift
//  mobile
//
//  Created by NguyenSon_MP on 17/02/2023.
//

import UIKit

class ProfileDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        navigationItem.title = "Profile"
//        na
        
        let title = UILabel()
        title.text = "Profile"

        let spacer = UIView()
        let constraint = spacer.widthAnchor.constraint(greaterThanOrEqualToConstant: CGFloat.greatestFiniteMagnitude)
        constraint.isActive = true
        constraint.priority = .defaultLow

        let stack = UIStackView(arrangedSubviews: [title, spacer])
        stack.axis = .horizontal

        navigationItem.titleView = stack

    }


}
