//
//  LoginFirstScreenViewController.swift
//  mobile
//
//  Created by NguyenSon_MP on 11/02/2023.
//

import UIKit
import WebKit
import Reachability
class LoginFirstScreenViewController: UIViewController {
    var webView: WKWebView!
//    var isPasswordVisible = false

    @IBOutlet weak var txtPassword: PasswordTextField!
//    @IBOutlet weak var showPasswordButton: UIButton!
    var VM = LoginFirstScreenViewModel()
    @IBOutlet weak var btnCheckBoxRemember: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var fotgetPassword: UIButton!
    @IBAction func setPassword(_ sender: UITextField) {
        VM.setPassword(password: sender.text ?? "")
        
    }
    @IBAction func setUsername(_ sender: UITextField) {
        VM.setUsername(username: sender.text ?? "")
    };
    @IBOutlet weak var txtUsername: UITextField!
    
    @IBAction func saveRemember(_ sender: Any) {
        if(flag == true) {
                    
            Contanst.userdefault.set("1", forKey: "rememberMe")
            Contanst.userdefault.set(txtUsername.text ?? "" , forKey: "userMail")
            Contanst.userdefault.set(txtPassword.text ?? "", forKey: "userPassword")
                    
            showToast(message: "Mail & Password đã được lưu thành công", font: .systemFont(ofSize: 12))
                    
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
        self.changeScreen(modelType: ForgetPasswordViewController.self, id: "ForgetPasswordViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
        CheckAndAdd()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        btnLogin.addTarget(self, action: #selector(Login), for: .touchUpInside)
        btnLogin.layer.cornerRadius = 15
        btnLogin.layer.masksToBounds = true
    }
    
    @objc func Login() {
        
        switch try! Reachability().connection {
          case .wifi:
            VM.handelLogin()
          case .cellular:
            VM.handelLogin()
          case .none:
            showToast(message: "Mất kết nối mạng", font: .systemFont(ofSize: 12))
          case .unavailable:
            showToast(message: "Mất kết nối mạng", font: .systemFont(ofSize: 12))
        }
        
    }
    
//    @objc func togglePasswordVisibility() {
//            isPasswordVisible = !isPasswordVisible
//
//            // Thay đổi kiểu hiển thị của trường nhập mật khẩu
//            txtPassword.isSecureTextEntry = !isPasswordVisible
//
//            // Thay đổi hình ảnh của biểu tượng con mắt
//            let imageName = isPasswordVisible ? "eye.fill" : "eye.slash.fill"
//            let image = UIImage(systemName: imageName)
//            showPasswordButton.setImage(image, for: .normal)
//        }
    
    @objc func redirectGoogle() {
        
        
        switch try! Reachability().connection {
          case .wifi:
            webViewLoad()
          case .cellular:
            webViewLoad()
          case .none:
            showToast(message: "Mất kết nối mạng", font: .systemFont(ofSize: 12))
          case .unavailable:
            showToast(message: "Mất kết nối mạng", font: .systemFont(ofSize: 12))
        }
        
        
        
    }
    
    func webViewLoad() {
        // Create an instance of WKWebView
        webView = WKWebView(frame: view.bounds)
        webView.navigationDelegate = self
        view.addSubview(webView)
        webView.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1"

        // Create a URL from the initial link
        guard let initialURL = URL(string: "https://api.hcmus.online/api/v1/user-auth/user/google-sign-in") else {
            return
        }

        // Start loading the page
        var request = URLRequest(url: initialURL)
        request.httpMethod = "GET"
        webView.load(request)
    }

}

extension LoginFirstScreenViewController: WKNavigationDelegate {
    // Handle the response from the web page
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Check the current URL
        
        if let currentURL = webView.url?.absoluteString {
            // Check the URL to determine the success or failure response
            if currentURL.contains("https://api.hcmus.online/api/v1/user-auth/user/google-redirect?code=") {
                // Successful response, you can handle further actions

                // Get information from the response
                let htmlContent = webView.evaluateJavaScript("document.documentElement.outerHTML") { (result, error) in
                    if let htmlString = result as? String {
                        
                        let jsonData = htmlString.removeHTMLTag()
                        do {
                            let decoder = JSONDecoder()
                            let info = try decoder.decode(ReponseLogin.self, from: jsonData.data(using: .utf8)!)
                            
                            if info.statusCode == 200 {
                                TokenService.tokenInstance.saveToken(token: info.data?.accessToken ?? "", refreshToken: info.data?.refreshToken ?? "")
                                if let encodedUser = try? JSONEncoder().encode(info.data?.getUserInfor) {
                                    Contanst.userdefault.set(encodedUser, forKey: "userInfo")
                                }

                                DispatchQueue.main.async {
                                    //Lay du lieu tu server
                                    self.VM.fetchUserDetail()
                                }
                            } else {
                                self.showToast(message: info.message ?? "   ", font: .systemFont(ofSize: 12.0))
                            }
                            
                            
                            
                        } catch {
                            print("Failed to decode JSON:", error)
                        }
                }
                    

                // Stop loading the page and hide the WebView if necessary
                webView.stopLoading()
                webView.isHidden = true

                // Continue processing the data and perform further steps
                // ...
                }
            } else {
                // Failed response, handle any unexpected situations here
            }
        }
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
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self?.stoppedLoader(loader: loader ?? UIAlertController())
                }
            case .dataLoaded:
                DispatchQueue.main.async {
                    self?.showToast(message: "Đăng nhập thành công!", font: .systemFont(ofSize: 12.0))

                    let appDelegate = UIApplication.shared.delegate as? AppDelegate
                    let vc = self?.storyboard?.instantiateViewController(withIdentifier: "MenuTabBar") as? MenuViewController
                    let navVC = UINavigationController(rootViewController: vc!)
                    appDelegate?.window?.rootViewController = navVC
                }
            case .error(let error):

                if (error == DataError.invalidResponse500.localizedDescription) {
                    DispatchQueue.main.async {
                        self?.showToast(message: "Chưa kết nối Mạng", font: .systemFont(ofSize: 12.0))
                        self?.stoppedLoader(loader: loader ?? UIAlertController())
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.showToast(message: error!, font: .systemFont(ofSize: 12.0))
                        self?.stoppedLoader(loader: loader ?? UIAlertController())
                    }
                }
                
            case .invalid:
                self?.showToast(message: "Tên đăng nhập hoặc mật khẩu không đúng", font: .systemFont(ofSize: 12.0))

            }
        }
    }

}

