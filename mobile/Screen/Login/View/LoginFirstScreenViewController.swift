//
//  LoginFirstScreenViewController.swift
//  mobile
//
//  Created by NguyenSon_MP on 11/02/2023.
//

import UIKit

class LoginFirstScreenViewController: UIViewController {

    var VM = LoginFirstScreenViewModel()
    @IBOutlet weak var btnCheckBoxRemember: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    
    @IBAction func setPassword(_ sender: UITextField) {
        VM.setPassword(password: sender.text ?? "")
        
    }
    @IBAction func setUsername(_ sender: UITextField) {
        VM.setUsername(username: sender.text ?? "")
    };
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    @IBAction func checkBoxRemember(_ sender: UIButton) {
        if (flag == false) {
            sender.setBackgroundImage((UIImage(named: "checkbox")), for: UIControl.State.normal)
            flag = true
        }
        else {
            sender.setBackgroundImage((UIImage(named: "uncheckbox")), for: UIControl.State.normal)
            flag = false
        }
    }
    
    var flag = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        btnSignUp.addTarget(self, action: #selector(changeSignUpController), for: .touchUpInside)
        btnLogin.addTarget(self, action: #selector(Login), for: .touchUpInside)
        btnLogin.layer.cornerRadius = 15
        btnLogin.layer.masksToBounds = true
    }
    
    @objc func Login() {
        VM.handelLogin()
    }
    
//    @objc func changeSignUpController() {
//        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController else {
//            return
//        }
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
    
    func changeScreen<T: UIViewController>(
        modelType: T.Type,
        id: String
    ) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: id) as? T else {
            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}


extension LoginFirstScreenViewController {

    func configuration() {
        initViewModel()
        observeEvent()
    }

    func initViewModel() {
        
    }

    // Data binding event observe - communication
    func observeEvent() {
        VM.eventHandler = { [weak self] event in
            switch event {
            case .loading:
                print("Login loading....")
            case .stopLoading:
                print("Login Stop loading...")
            case .dataLoaded:
                print("Data User loaded...")
                DispatchQueue.main.async {
                    self?.changeScreen(modelType: UIViewController.self,id: "MenuTabBar")
                }
            case .error(let error):
                print(error)
            }
        }
    }

}

