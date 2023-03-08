//
//  ProfileDetailViewController.swift
//  mobile
//
//  Created by NguyenSon_MP on 17/02/2023.
//

import UIKit

class ProfileDetailViewController: UIViewController {

    @IBOutlet weak var btnDeleteaccount: UIButton!
    @IBOutlet weak var btnChangepassword: UIButton!
    @IBOutlet weak var tb: UITableView!
    var dataLabel = ["Email:","Number phone:","Address:","Birthday:","Identity card:","Gender:"]
    
    var VM = ProfileViewModel()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnChangepassword.addTarget(self, action: #selector(changeChangePasswordController), for: .touchUpInside)

        configuration()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        tabBarController?.tabBar.isHidden = true
        
        let title = UILabel()
        title.text = "Profile"
        title.font = UIFont(name: "Helvetica Bold", size: 18)
        let spacer = UIView()
        
        let constraint = spacer.widthAnchor.constraint(greaterThanOrEqualToConstant: CGFloat.greatestFiniteMagnitude)
        constraint.isActive = true
        constraint.priority = .defaultLow
        
        let btnEdit = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        btnEdit.setBackgroundImage(UIImage(named: "btnEdit"), for: UIControl.State.normal)
        btnEdit.sizeToFit()
        btnEdit.addTarget(self, action: #selector(changeEditProfileController), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [title, spacer, btnEdit])
        stack.axis = .horizontal

        navigationItem.titleView = stack
        
        btnDeleteaccount.layer.cornerRadius = 15
        btnDeleteaccount.layer.masksToBounds = true
        
        btnChangepassword.layer.cornerRadius = 15
        btnChangepassword.layer.masksToBounds = true

    }
    
    
    @objc func changeChangePasswordController() {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordViewController") as? ChangePasswordViewController else {
            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func changeEditProfileController() {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") as? EditProfileViewController else {
            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }


}

extension ProfileDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataLabel.count + 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if (indexPath.row == 0) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "InfoTableViewCell", for: indexPath) as? InfoTableViewCell {
                cell.txtName.text = VM.userInfoDetail?.fullName
                return cell
            }
        } else if (indexPath.row == 1) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileDetailTableViewCell", for: indexPath) as? ProfileDetailTableViewCell {
                cell.lbl.text = dataLabel[indexPath.row-1]
                cell.tf.text = VM.userInfoDetail?.email
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


extension ProfileDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if (indexPath.row == 0) {
            return 180
        }
        return 80
    }
    
}


extension ProfileDetailViewController {

    func configuration() {
        
        self.tb.register(UINib(nibName: "InfoTableViewCell", bundle: nil), forCellReuseIdentifier: "InfoTableViewCell")
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
        VM.eventHandler = { [weak self] event in
            switch event {
            case .loading:
                print("Profile loading....")
            case .stopLoading:
                print("Profile Stop loading...")
            case .dataLoaded:
                print("get User loaded...")
                DispatchQueue.main.async {
                    self?.tb.reloadData()
                }
            case .error(let error):
                print(error)
            case .logout: break
            }
        }
    }

}
