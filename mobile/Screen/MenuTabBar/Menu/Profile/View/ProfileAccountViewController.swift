//
//  ProfileAccountViewController.swift
//  mobile
//
//  Created by NguyenSon_MP on 13/02/2023.
//

import UIKit

class ProfileAccountViewController: UIViewController {

    @IBOutlet weak var tb: UITableView!
    
    var VM = ProfileViewModel()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
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
        

    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        let title = UILabel()
        title.text = "Profile"
        title.font = UIFont(name: "Helvetica Bold", size: 18)
        title.textAlignment = .center


        let spacer = UIView()

        let constraint = spacer.widthAnchor.constraint(greaterThanOrEqualToConstant: CGFloat.greatestFiniteMagnitude)
        constraint.isActive = true
        constraint.priority = .defaultLow

        let stack = UIStackView(arrangedSubviews: [title, spacer])
        stack.axis = .horizontal

        navigationItem.titleView = stack

    }

}


extension ProfileAccountViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 1
        } else if(section == 1){
            return 2
        } else {
            return 7
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "InfoTableViewCell", for: indexPath) as? InfoTableViewCell {
                cell.txtName.text = self.VM.userInfo?.fullName
                return cell
            }
        } else if (indexPath.section == 1){
            if let cell = tableView.dequeueReusableCell(withIdentifier: "IconMenuTableViewCell", for: indexPath) as? IconMenuTableViewCell {
                cell.setDataEvent(id: indexPath.row)
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "IconMenuTableViewCell", for: indexPath) as? IconMenuTableViewCell {
                cell.setDataAccount(id: indexPath.row)
                return cell
            }
        }

        return UITableViewCell()
    }
    
    
    
}

extension ProfileAccountViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if (indexPath.section == 0) {
            return 170
        }
        return 55
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 0.5))
        footer.backgroundColor = .lightGray
        return footer
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section != 2 ? 0.5 : 0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        
        if(indexPath.section == 2 && indexPath.row == 0) {
            self.changeScreen(modelType: ProfileDetailViewController.self, id: "ProfileDetailViewController")
        } else if (indexPath.section == 2 && indexPath.row == 1) {
            self.changeScreen(modelType: PaymentMethodViewController.self, id: "PaymentMethodViewController")
        } else if (indexPath.section == 1 && indexPath.row == 1) {
            self.changeScreen(modelType: FavoriteEventsViewController.self, id: "FavoriteEventsViewController")
        } else if (indexPath.section == 2 && indexPath.row == 6) {
            VM.logout()
        }
    }
    
    
}


extension ProfileAccountViewController {

    func configuration() {
        
        self.tb.register(UINib(nibName: "InfoTableViewCell", bundle: nil), forCellReuseIdentifier: "InfoTableViewCell")
        self.tb.register(UINib(nibName: "IconMenuTableViewCell", bundle: nil), forCellReuseIdentifier: "IconMenuTableViewCell")

        self.tb.dataSource = self
        self.tb.delegate = self
        
        initViewModel()
        observeEvent()
    }

    func initViewModel() {
        self.VM.getUser()
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
            case .error(let error):
                print(error)
            case .logout:
                // xử lý logout tại đây
                TokenService.tokenInstance.removeTokenAndInfo()
                DispatchQueue.main.async {
                    self?.changeScreen(modelType: LoginFirstScreenViewController.self, id: "LoginFirstScreenViewController")
                }

                print("logout")
            }
        }
    }

}
