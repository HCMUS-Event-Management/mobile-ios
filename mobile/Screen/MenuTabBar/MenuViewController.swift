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
        print(TokenService.tokenInstance.getToken(key: "userToken"))
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        //khoá xoay màn hình
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
    }
}
