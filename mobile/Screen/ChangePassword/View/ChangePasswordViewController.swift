//
//  ChangePasswordViewController.swift
//  mobile
//
//  Created by NguyenSon_MP on 20/02/2023.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    var dataLabel = ["Old password:","Current password:","Confirm password:"]
    var VM = ChangePasswordViewModel()

    @IBOutlet weak var tb: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
        // Do any additional setup after loading the view.
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


extension ChangePasswordViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataLabel.count + 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if(indexPath.row == dataLabel.count){
            if let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileButtonTableViewCell", for: indexPath) as? EditProfileButtonTableViewCell {
                cell.delegate = self
                cell.btnSelect.setTitle("Change", for: .normal)
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileDetailTableViewCell", for: indexPath) as? ProfileDetailTableViewCell {
                cell.lbl.text = dataLabel[indexPath.row]
                return cell
            }
        }

        return UITableViewCell()

    }
    
    
    
}


extension ChangePasswordViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

extension ChangePasswordViewController: EditProfileButtonTableViewCellDelegate {
    func backScreen() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func callApi() {
        let cellOldPassword = self.tb.cellForRow(at: [0,0]) as? ProfileDetailTableViewCell
        let cellNewPassword = self.tb.cellForRow(at: [0,1]) as? ProfileDetailTableViewCell
        let cellConfirmPassword = self.tb.cellForRow(at: [0,2]) as? ProfileDetailTableViewCell

        
        if cellNewPassword?.tf.text == cellConfirmPassword?.tf.text {
            var params = ChangePassword(password: cellOldPassword?.tf.text ?? "", passwordNew: cellNewPassword?.tf.text ?? "", comfirmPassword: cellConfirmPassword?.tf.text ?? "")
            
            self.VM.ChangePass(params: params)
        } else {
            self.showToast(message: "Mật khẩu không khớp", font: .systemFont(ofSize: 12))
        }
      
        
        
        

    }
}


extension ChangePasswordViewController {

    func configuration() {
        
        self.tb.register(UINib(nibName: "EditProfileButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "EditProfileButtonTableViewCell")
        self.tb.register(UINib(nibName: "ProfileDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileDetailTableViewCell")


        self.tb.dataSource = self
        self.tb.delegate = self
        
        initViewModel()
        observeEvent()
    }

    func initViewModel() {
        
    }

    // Data binding event observe - communication
    func observeEvent() {
        
        var loader: UIAlertController?
        VM.eventHandler = { [weak self] event in
            switch event {
            case .loading:
                loader = self?.loader()
            case .stopLoading:
                self?.stoppedLoader(loader: loader ?? UIAlertController())
            case .dataLoaded:
                print("Data loaded...")
            case .error(let error):
                let err = error as! DataError
                if (err == DataError.invalidResponse500) {
                    DispatchQueue.main.async {
                        self?.showToast(message: "Mật khẩu cũ không đúng", font: .systemFont(ofSize: 12.0))
                        self?.stoppedLoader(loader: loader ?? UIAlertController())
                    }
                }
            case .logout:
                // xử lý logout tại đây
                DispatchQueue.main.async {
                    self?.showToast(message: "Đổi mật khẩu thành công", font: .systemFont(ofSize: 12.0))
                    self?.changeScreen(modelType: LoginFirstScreenViewController.self, id: "LoginFirstScreenViewController")
                }
                print("logout")
            }
        }
    }

}

