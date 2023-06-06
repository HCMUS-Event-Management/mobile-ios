//
//  ProfileAccountViewController.swift
//  mobile
//
//  Created by NguyenSon_MP on 13/02/2023.
//

import UIKit
import Reachability
class ProfileAccountViewController: UIViewController {

    @IBOutlet weak var tb: UITableView!
    
    var VM = ProfileViewModel()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
    }


    
    override func viewWillAppear(_ animated: Bool) {
        VM.getUserDetailFromLocalDB()
        tabBarController?.tabBar.isHidden = false
        configNaviBar()
    }
    
    
    func configNaviBar() {
        navigationController?.navigationBar.tintColor = .label
        
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        title.text = "Profile"
        title.font = UIFont(name: "Helvetica Bold", size: 18)
        title.textAlignment = .center
        
        navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: title)]
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
                
                if let url = URL(string: (VM.userInfoDetail?.avatar) ?? "") {
                    let task = URLSession.shared.dataTask(with: url) { data, response, error in
                        guard let data = data, error == nil else { return }
                        
                        DispatchQueue.main.async { /// execute on main thread
                            cell.imgAvatar.image = UIImage(data: data)
                        }
                    }
                    
                    task.resume()
                } else {
                    cell.imgAvatar.image = UIImage(named: "avatar test")
                }
                
                cell.txtName.text = self.VM.userInfoDetail?.fullName
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
            return (tableView.layer.frame.height/13) * 3.8
        }
        return (tableView.layer.frame.height/13)
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
            changeScreen(modelType: ProfileDetailViewController.self, id: "ProfileDetailViewController")
        } else if (indexPath.section == 2 && indexPath.row == 1) {
            changeScreen(modelType: PaymentMethodViewController.self, id: "PaymentMethodViewController")
        } else if (indexPath.section == 2 && indexPath.row == 2) {
            changeScreen(modelType: PaymentHistoryViewController.self, id: "PaymentHistoryViewController")
        } else if (indexPath.section == 1 && indexPath.row == 1) {
            changeScreen(modelType: FavoriteEventsViewController.self, id: "FavoriteEventsViewController")
        } else if (indexPath.section == 2 && indexPath.row == 6) {
            switch try! Reachability().connection {
              case .wifi:
                VM.logout()
              case .cellular:
                VM.logout()
              case .none:
                showToast(message: "Network not reachable", font: .systemFont(ofSize: 12))
              case .unavailable:
                showToast(message: "Network not reachable", font: .systemFont(ofSize: 12))
            }
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
                print("get User loaded...")
                DispatchQueue.main.async {
                    self?.tb.reloadData()
                }
            case .error(let error):
//                let err = error as! DataError
                if (error == DataError.invalidResponse401.localizedDescription) {
                    DispatchQueue.main.async {
                        self?.showToast(message: "Hết phiên đăng nhập", font: .systemFont(ofSize: 12.0))
                        TokenService.tokenInstance.removeTokenAndInfo()
                        self?.changeScreen(modelType: LoginFirstScreenViewController.self, id: "LoginFirstScreenViewController")
                    }
                } else if (error == DataError.invalidResponse500.localizedDescription){
                    DispatchQueue.main.async {
                        self?.showToast(message: "Chưa kết nối mạng", font: .systemFont(ofSize: 12.0))
                        self?.stoppedLoader(loader: loader ?? UIAlertController())
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.showToast(message: error!, font: .systemFont(ofSize: 12.0))
                        self?.stoppedLoader(loader: loader ?? UIAlertController())
                    }
                }
            case .logout:
                // xử lý logout tại đây
                DispatchQueue.main.async {
                    self?.changeScreen(modelType: LoginFirstScreenViewController.self, id: "LoginFirstScreenViewController")
                }


                print("logout")
            case .updateProfile: break
                // gọi realoadtb
            }
        }
    }

}
