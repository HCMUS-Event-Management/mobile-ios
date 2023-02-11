//
//  LoginWithPasswordViewController.swift
//  mobile
//
//  Created by NguyenSon_MP on 09/02/2023.
//

import UIKit

class LoginWithPasswordViewController: UIViewController {

    @IBOutlet weak var btnLogin: IconTextButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        let btn = IconTextButton(frame: btnLogin.frame)

        
        btnLogin
        btnLogin.config(with: IconTextButtonViewModel(text: "Test", image: UIImage(systemName: "cart"), backgroundColor: .systemRed))

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
