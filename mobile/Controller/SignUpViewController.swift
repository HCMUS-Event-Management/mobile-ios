//
//  SignUpViewController.swift
//  mobile
//
//  Created by NguyenSon_MP on 11/02/2023.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        btnLogin.addTarget(self, action: #selector(changeLoginController), for: .touchUpInside)

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func viewWillAppear(_ animated: Bool) {
        btnSignUp.layer.cornerRadius = 15
        btnSignUp.layer.masksToBounds = true
    }
    
    @objc func changeLoginController() {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginFirstScreenViewController") as? LoginFirstScreenViewController else {
            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
