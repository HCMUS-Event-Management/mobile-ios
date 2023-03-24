//
//  MenuViewController.swift
//  mobile
//
//  Created by NguyenSon_MP on 04/03/2023.
//

import UIKit

class MenuViewController: UITabBarController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoginFirstScreenViewModel().fetchUserDetail()
        print(TokenService.tokenInstance.getToken(key: "userToken"))
//        TokenService.tokenInstance.removeTokenAndInfo()

    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.showToast(message: "Bạn đã đăng nhập", font: .systemFont(ofSize: 12))
    }

}
