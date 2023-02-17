//
//  ProfileAccountViewController.swift
//  mobile
//
//  Created by NguyenSon_MP on 13/02/2023.
//

import UIKit

class ProfileAccountViewController: UIViewController {

    @IBOutlet weak var tb: UITableView!
    
    var dataInfo = ["Nguyễn Sơn"]
    var dataMenuAccount = ["Profile","Payment Methods","Payment History","Security","Language","Help Center","Logout"]
    var dataMenuEvent = ["Magane Events","Favorite Events"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configTb()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func configTb() {
        self.tb.register(UINib(nibName: "InfoTableViewCell", bundle: nil), forCellReuseIdentifier: "InfoTableViewCell")
        self.tb.register(UINib(nibName: "IconMenuTableViewCell", bundle: nil), forCellReuseIdentifier: "IconMenuTableViewCell")

        self.tb.dataSource = self
        self.tb.delegate = self
    }
    
    func changeProfile() {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileDetailViewController") as? ProfileDetailViewController else {
            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func changePaymentMethod() {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "PaymentMethodViewController") as? PaymentMethodViewController else {
            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.isNavigationBarHidden = true
        navigationItem.title = "Profile"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20.0)]

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
                cell.txtName.text = self.dataInfo[indexPath.row]
                return cell
            }
        } else if (indexPath.section == 1){
            if let cell = tableView.dequeueReusableCell(withIdentifier: "IconMenuTableViewCell", for: indexPath) as? IconMenuTableViewCell {
                cell.name.text = self.dataMenuEvent[indexPath.row]
                cell.icon.image = UIImage(named: self.dataMenuEvent[indexPath.row])
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "IconMenuTableViewCell", for: indexPath) as? IconMenuTableViewCell {
                cell.name.text = self.dataMenuAccount[indexPath.row]
                cell.icon.image = UIImage(named: self.dataMenuAccount[indexPath.row])
                return cell
            }
        }
       
        
        return UITableViewCell()
    }
    
    
    
}

extension ProfileAccountViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if (indexPath.section == 0) {
            return 180
        }
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 0.5))
        footer.backgroundColor = .lightGray
        return footer
    }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
//        return 20.0
//    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section != 2 ? 0.5 : 0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        
        if(indexPath.section == 2 && indexPath.row == 0) {
            self.changeProfile()
            
        } else if (indexPath.section == 2 && indexPath.row == 1) {
            self.changePaymentMethod()
        }
    }
    
    
}
