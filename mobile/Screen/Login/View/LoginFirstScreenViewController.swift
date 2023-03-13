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
    @IBOutlet weak var fotgetPassword: UIButton!

    @IBAction func setPassword(_ sender: UITextField) {
        VM.setPassword(password: sender.text ?? "")
        
    }
    @IBAction func setUsername(_ sender: UITextField) {
        VM.setUsername(username: sender.text ?? "")
    };
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    
    @IBAction func saveRemember(_ sender: Any) {
        if(flag == true) {
                    
            Contanst.userdefault.set("1", forKey: "rememberMe")
            Contanst.userdefault.set(txtUsername.text ?? "" , forKey: "userMail")
            Contanst.userdefault.set(txtPassword.text ?? "", forKey: "userPassword")
                    
                print("Mail & Password Saved Successfully")
                    
                }else{
                    
                    Contanst.userdefault.set("2", forKey: "rememberMe")

                }
    }
    @IBAction func checkBoxRemember(_ sender: UIButton) {
        if (flag == false) {
            sender.setBackgroundImage((UIImage(named: "checkbox")), for: .normal)
            flag = true
        }
        else {
            sender.setBackgroundImage((UIImage(named: "uncheckbox")), for: .normal)
            flag = false
        }
    }
    
    
    var flag = false
    
    
    func CheckAndAdd(){
        if Contanst.userdefault.string(forKey: "rememberMe") == "1" {
            
            if let image = UIImage(named: "checkbox") {
                btnCheckBoxRemember.setBackgroundImage(image, for: .normal)
            }
            
            flag = true
            
            // Set values
            self.txtUsername.text = Contanst.userdefault.string(forKey: "userMail") ?? ""
            VM.setUsername(username: self.txtUsername.text ?? "")

            self.txtPassword.text = Contanst.userdefault.string(forKey: "userPassword") ?? ""
            VM.setPassword(password: self.txtPassword.text ?? "")

            
        }else{
            
            if let image = UIImage(named: "uncheckbox") {
                btnCheckBoxRemember.setBackgroundImage(image, for: .normal)
            }
            
            flag = false
        }
    }
    
    @IBAction func forgetPassword(_ sender: UIButton) {
        changeScreen(modelType: ForgetPasswordViewController.self, id: "ForgetPasswordViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
        CheckAndAdd()
        print(Contanst.userdefault.string(forKey: "userToken"))
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        btnLogin.addTarget(self, action: #selector(Login), for: .touchUpInside)
        btnLogin.layer.cornerRadius = 15
        btnLogin.layer.masksToBounds = true
    }
    
    @objc func Login() {
        VM.handelLogin()
    }
    
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
        var loader:UIAlertController?

        VM.eventHandler = { [weak self] event in
            switch event {
            case .loading:
                loader = self?.loader()
            case .stopLoading:
                self?.stoppedLoader(loader: loader ?? UIAlertController())
            case .dataLoaded:
//                let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertController.Style.alert)
//                alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
//                self?.present(alert, animated: true, completion: nil)
                DispatchQueue.main.async {
                    self?.showToast(message: "Đăng nhập thành công!", font: .systemFont(ofSize: 12.0))
                    self?.changeScreen(modelType: UIViewController.self,id: "MenuTabBar")
                }
            case .error(let error):
                let err = error as! DataError
                if (err == DataError.invalidResponse400) {
                    DispatchQueue.main.async {
                        self?.showToast(message: "Email hoặc Mật khẩu không đúng", font: .systemFont(ofSize: 12.0))
                        self?.stoppedLoader(loader: loader ?? UIAlertController())
                    }
                }
            case .invalid:
                self?.showToast(message: "Email hoặc Mật khẩu không đúng", font: .systemFont(ofSize: 12.0))

            }
        }
    }

}

