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
        btnGetNewPass.layer.cornerRadius = 15
        btnGetNewPass.layer.masksToBounds = true
        btnBack.layer.cornerRadius = 15
        btnBack.layer.masksToBounds = true
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
