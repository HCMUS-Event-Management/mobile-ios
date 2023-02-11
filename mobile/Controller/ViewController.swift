//
//  ViewController.swift
//  mobile
//
//  Created by NguyenSon_MP on 09/02/2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var btnGetStarted: UIButton!
//    @IBAction func btnGetStarted(_ sender: UIButton) {
//        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginWithPasswordViewController") as? LoginWithPasswordViewController else {
//
//            return
//        }
//        print("Aa")
//        self.navigationController?.pushViewController(vc, animated: true)
//
//
//    }
    
    @objc func changeLoginController() {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginWithPasswordViewController") as? LoginWithPasswordViewController else {
            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        btnGetStarted.addTarget(self, action: #selector(changeLoginController), for: .touchUpInside);
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        btnGetStarted.layer.cornerRadius = 20
        btnGetStarted.layer.masksToBounds = true
    }


}

