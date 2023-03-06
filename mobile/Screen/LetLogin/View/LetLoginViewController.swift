//
//  LoginWithPasswordViewController.swift
//  mobile
//
//  Created by NguyenSon_MP on 11/02/2023.
//

import UIKit

class LetLoginViewController: UIViewController {
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var btnLoginFB: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnLoginGG: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        btnLogin.addTarget(self, action: #selector(changeLoginController), for: .touchUpInside)
        btnSignUp.addTarget(self, action: #selector(changeSignUpController), for: .touchUpInside)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        btnLoginFB.layer.cornerRadius = 15
        btnLoginFB.layer.masksToBounds = true
        btnLoginFB.layer.shadowOpacity = 0.5
        btnLoginFB.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)

        btnLogin.layer.cornerRadius = 15
        btnLogin.layer.masksToBounds = true
        
        btnLoginGG.layer.cornerRadius = 15
        btnLoginGG.layer.masksToBounds = true
        
        
        btnLoginFB.layer.borderWidth = 0.5
        btnLoginFB.layer.borderColor = UIColor.gray.cgColor
        
        btnLoginGG.layer.borderWidth = 0.5
        btnLoginGG.layer.borderColor = UIColor.gray.cgColor
    }
    
    
    @objc func changeLoginController() {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginFirstScreenViewController") as? LoginFirstScreenViewController else {
            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func changeSignUpController() {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController else {
            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
