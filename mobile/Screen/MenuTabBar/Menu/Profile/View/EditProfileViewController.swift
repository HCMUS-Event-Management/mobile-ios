//
//  EditProfileViewController.swift
//  mobile
//
//  Created by NguyenSon_MP on 20/02/2023.
//

import UIKit

class EditProfileViewController: UIViewController, EditProfileButtonTableViewCellDelegate {
    func backScreen() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func callApi() {
        let fullname = tb.cellForRow(at: [0,1]) as? ProfileDetailTableViewCell
        let phone = tb.cellForRow(at: [0,2]) as? ProfileDetailTableViewCell
        let address = tb.cellForRow(at: [0,3]) as? ProfileDetailTableViewCell
        let dot = tb.cellForRow(at: [0,4]) as? ProfileDetailTableViewCell
        let idCard = tb.cellForRow(at: [0,5]) as? ProfileDetailTableViewCell
        let gender = tb.cellForRow(at: [0,6]) as? ProfileDetailTableViewCell
        
        if (fullname?.tf.text == VM.userInfoDetail?.fullName && phone?.tf.text == VM.userInfoDetail?.phone && dot?.tf.text == VM.userInfoDetail?.birthday && idCard?.tf.text == VM.userInfoDetail?.identityCard && gender?.tf.text == VM.userInfoDetail?.gender && address?.tf.text == VM.userInfoDetail?.address){
            showToast(message: "Không có gì thay đổi", font: .systemFont(ofSize: 12))
        } else {
            let infoProfile = UpdateProfile(fullName: fullname?.tf.text ?? "", phone: phone?.tf.text ?? "", birthday: dot?.tf.text ?? "", identityCard: idCard?.tf.text ?? "", gender: gender?.tf.text ?? "", avatar: VM.userInfoDetail?.avatar ?? "", address: address?.tf.text ?? "", isDeleted: false)
            
            VM.updateUserDetail(params: infoProfile)
        }
        
    }
    
    var VM = ProfileViewModel()

    

    var dataLabel = ["Fullname:","Number phone:","Address:","Birthday:","Identity card:","Gender:"]
    var dataPlaceHolder = ["Ex: ngyenvana@gmail.com","Ex: 01234567892","Ex: 123 Võ Văn Kiệt, P6, Quận 5, TP.HCM","Ex: 09/07/2001","Ex: 212950358","Ex: Male"]
    
    @IBOutlet weak var tb: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
        
    }
}


extension EditProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataLabel.count + 2
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if (indexPath.row == 0) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileTableViewCell", for: indexPath) as? EditProfileTableViewCell {
                return cell
            }
        } else if(indexPath.row == dataLabel.count + 1){
            if let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileButtonTableViewCell", for: indexPath) as? EditProfileButtonTableViewCell {
                cell.delegate = self
                cell.btnSelect.setTitle("Update", for: .normal)

                return cell
            }
        } else if (indexPath.row == 1) {
            print(indexPath)
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileDetailTableViewCell", for: indexPath) as? ProfileDetailTableViewCell {
                cell.lbl.text = dataLabel[indexPath.row-1]
                cell.tf.text = VM.userInfoDetail?.fullName
                return cell
            }
        } else if (indexPath.row == 2) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileDetailTableViewCell", for: indexPath) as? ProfileDetailTableViewCell {
                cell.lbl.text = dataLabel[indexPath.row-1]
                cell.tf.text = VM.userInfoDetail?.phone
                cell.tf.isEnabled = false // hợp lí
                return cell
            }
        } else if (indexPath.row == 3) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileDetailTableViewCell", for: indexPath) as? ProfileDetailTableViewCell {
                cell.lbl.text = dataLabel[indexPath.row-1]
                cell.tf.text = VM.userInfoDetail?.address
                return cell
            }
        } else if (indexPath.row == 4) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileDetailTableViewCell", for: indexPath) as? ProfileDetailTableViewCell {
                cell.lbl.text = dataLabel[indexPath.row-1]
                cell.tf.text = VM.userInfoDetail?.birthday
                return cell
            }
        } else if (indexPath.row == 5) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileDetailTableViewCell", for: indexPath) as? ProfileDetailTableViewCell {
                cell.lbl.text = dataLabel[indexPath.row-1]
                cell.tf.text = VM.userInfoDetail?.identityCard
                return cell
            }
        } else if (indexPath.row == 6) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileDetailTableViewCell", for: indexPath) as? ProfileDetailTableViewCell {
                cell.lbl.text = dataLabel[indexPath.row-1]
                cell.tf.text = VM.userInfoDetail?.gender
                return cell
            }
        }
        
        
        
        return UITableViewCell()

    }
    
    
    
}


extension EditProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if (indexPath.row == 0) {
            return 180
        }
        return 80
    }
    
}

extension EditProfileViewController {

    func configuration() {
        
        self.tb.register(UINib(nibName: "EditProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "EditProfileTableViewCell")
        self.tb.register(UINib(nibName: "EditProfileButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "EditProfileButtonTableViewCell")
        self.tb.register(UINib(nibName: "ProfileDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileDetailTableViewCell")


        self.tb.dataSource = self
        self.tb.delegate = self
        
        initViewModel()
        observeEvent()
    }

    func initViewModel() {
//        self.VM.updateUserDetail()
        self.VM.fetchUserDetail()
    }

    // Data binding event observe - communication
    func observeEvent() {
        var loader:UIAlertController?
        VM.eventHandler = { [weak self] event in
            switch event {
            case .loading:
                loader = self?.loader()
            case .stopLoading:
                DispatchQueue.main.async {
                    self?.stoppedLoader(loader: loader ?? UIAlertController())
                }
            case .dataLoaded:
                DispatchQueue.main.async {
                    self?.tb.reloadData()
                    self?.stoppedLoader(loader: loader ?? UIAlertController())
                }
            case .error(let error):
                print(error)

//                let err = error as! DataError
//                if (err == DataError.invalidResponse401) {
//                    DispatchQueue.main.async {
//                        self?.stoppedLoader(loader: loader ?? UIAlertController())
//                    }
//                }
            case .logout: break
            case .updateProfile:
                self?.VM.fetchUserDetail()
                //reloadtb
            }
        }
    }

}

