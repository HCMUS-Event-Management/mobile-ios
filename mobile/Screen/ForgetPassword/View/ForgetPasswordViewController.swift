//
//  ForgetPasswordViewController.swift
//  mobile
//
//  Created by NguyenSon_MP on 12/03/2023.
//

import UIKit

class ForgetPasswordViewController: UIViewController {

    @IBOutlet weak var btnGetNewPass: UIButton!
    @IBOutlet weak var btnBack: UIButton!

    @IBOutlet weak var txtEmail: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        btnGetNewPass.addTarget(self, action: #selector(postAPI), for: .touchUpInside)
        btnBack.addTarget(self, action: #selector(back), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        btnGetNewPass.layer.cornerRadius = 20
        btnGetNewPass.layer.masksToBounds = true
        btnBack.layer.cornerRadius = 20
        btnBack.layer.masksToBounds = true
        btnBack.layer.borderWidth = 0.5
        btnBack.layer.borderColor = UIColor(red: 94/255, green: 135/255, blue: 240/255, alpha: 1).cgColor
    }
    
    @objc func back () {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func postAPI () {
        if txtEmail.text == ""{
            print("email emtyp")
        } else if (!(txtEmail.text?.isValidEmail() ?? false)) {
            print("email not ")
        } else {
            let params = ["email":txtEmail.text] as? [String:String]
            
            let parameter = try? APIManager.shared.encodeBody(value: params)
            
            APIManager.shared.request(modelType: ReponseCommon.self, type: UserEndPoint.forgetPassword, params: parameter, completion: {
                result in
                switch result {
                case .success(let data):
                        print(data)
                    
                case .failure(let error):
                        print(error)
                    
                }
            })
            
        }
       
        
        
    }
    

}
