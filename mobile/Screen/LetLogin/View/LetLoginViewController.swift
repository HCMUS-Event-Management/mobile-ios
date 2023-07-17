//
//  LoginWithPasswordViewController.swift
//  mobile
//
//  Created by NguyenSon_MP on 11/02/2023.
//

import UIKit

class LetLoginViewController: UIViewController {
    @IBOutlet weak var btnLoginFB: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnLoginGG: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        btnLogin.addTarget(self, action: #selector(changeLoginController), for: .touchUpInside)
//        btnLoginGG.addTarget(self, action: #selector(redirectGoogle), for: .touchUpInside)

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
    
    @objc func redirectGoogle() {
        APIManager.shared.request(modelType: ReponseCommon.self, type:UserEndPoint.loginGG, params: nil, completion: {
            result in
            switch result {
                
            case .success(let value):
                print(value)
            case .failure(let error):
                print(error)
            }
        })
    }
    @objc func changeLoginController() {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginFirstScreenViewController") as? LoginFirstScreenViewController else {
            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
