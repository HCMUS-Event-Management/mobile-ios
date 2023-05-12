//
//  EditProfileViewController.swift
//  mobile
//
//  Created by NguyenSon_MP on 20/02/2023.
//

import UIKit
import DropDown
class EditProfileViewController: UIViewController, EditProfileButtonTableViewCellDelegate , UINavigationControllerDelegate, UIImagePickerControllerDelegate{
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
            let infoProfile = UpdateProfile(fullName: fullname?.tf.text ?? "", phone: phone?.tf.text ?? "", birthday: VM.userInfoDetail?.birthday ?? "", identityCard: idCard?.tf.text ?? "", gender: gender?.tf.text ?? "", avatar: VM.userInfoDetail?.avatar ?? "", address: address?.tf.text ?? "", isDeleted: false)
            
            VM.updateUserDetail(params: infoProfile)
        }
        
    }
    
    var VM = ProfileViewModel()

    var imagePicker = UIImagePickerController()


    var dataLabel = ["Fullname:","Number phone:","Address:","Birthday:","Identity card:","Gender:"]
    var dataPlaceHolder = ["Ex: ngyenvana@gmail.com","Ex: 01234567892","Ex: 123 Võ Văn Kiệt, P6, Quận 5, TP.HCM","Ex: 09/07/2001","Ex: 212950358","Ex: Male"]
    
    @IBOutlet weak var tb: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configNaviBar()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let image = info[.originalImage] as? UIImage {
            let imageData:Data = image.pngData()!
            VM.uploadAvatar(imageData: imageData)
        } else{
           print("Something went wrong")
        }
        
       self.dismiss(animated: true, completion: nil)
      }
    
    func configNaviBar() {
        navigationController?.navigationBar.tintColor = .label
        
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        title.text = "Edit Profile"
        title.font = UIFont(name: "Helvetica Bold", size: 18)
        title.textAlignment = .center
        
        navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: title)]
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
//        VM.userInfoDetail?.birthday = sender.date.formatted('YYYY-MM-DD')
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let date = dateFormatter.string(from: sender.date) + "T00:00:00.000Z"
        
        VM.userInfoDetail?.birthday = date
        tb.reloadRows(at: [IndexPath(row: 4, section: 0)], with: .none)

    }
  

}


extension EditProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataLabel.count + 2
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if (indexPath.row == 0) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileTableViewCell", for: indexPath) as? EditProfileTableViewCell {
                
                if let url = URL(string: (VM.userInfoDetail?.avatar) ?? "data:image/png;base64,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") {
                    let task = URLSession.shared.dataTask(with: url) { data, response, error in
                        guard let data = data, error == nil else { return }
                        
                        DispatchQueue.main.async { /// execute on main thread
                            cell.avatar.image = UIImage(data: data)
                        }
                    }
                    
                    task.resume()
                } else {
                    cell.avatar.image = UIImage(named: "avatar test")
                }
                
                
                
                
                cell.callback = {
                    if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                        print("Button capture")
            
                        self.imagePicker.delegate = self
                        self.imagePicker.sourceType = .savedPhotosAlbum
                        self.imagePicker.allowsEditing = false
            
                        self.present(self.imagePicker, animated: true, completion: nil)
                    }
                }
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
                cell.tf.keyboardType = .numberPad
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
                
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                
                let date = dateFormatter.date(from:  VM.userInfoDetail?.birthday ?? "1970-01-01T00:00:00.000Z")

                
                cell.tf.text = date?.formatted(date: .abbreviated, time: .omitted)
                
                // date Picker
                let datePicker = UIDatePicker()
                datePicker.setDate(date ?? Date(), animated: true)
                datePicker.datePickerMode = .date
                datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
                datePicker.preferredDatePickerStyle = .inline
                cell.tf.inputView = datePicker
                
                return cell
            }
        } else if (indexPath.row == 5) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileDetailTableViewCell", for: indexPath) as? ProfileDetailTableViewCell {
                cell.lbl.text = dataLabel[indexPath.row-1]
                cell.tf.text = VM.userInfoDetail?.identityCard
                cell.tf.keyboardType = .numberPad
                return cell
            }
        } else if (indexPath.row == 6) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileDetailTableViewCell", for: indexPath) as? ProfileDetailTableViewCell {
                cell.lbl.text = dataLabel[indexPath.row-1]
            
                // dropDown
                let countryValuesArray = ["MALE", "FEMALE"]

                let myDropDown = DropDown()
                myDropDown.anchorView = cell.mainView
                myDropDown.dataSource = countryValuesArray
                myDropDown.bottomOffset = CGPoint(x: 0, y: (myDropDown.anchorView?.plainView.bounds.height)!)
                myDropDown.topOffset = CGPoint(x: 0, y: -(myDropDown.anchorView?.plainView.bounds.height)!)
                myDropDown.direction = .bottom
                
                myDropDown.selectionAction = { (index: Int, item: String) in
                    self.VM.userInfoDetail?.gender = countryValuesArray[index]
//                    self.tb.reloadData()
                    self.tb.reloadRows(at: [indexPath], with: .none)

                }
                
                cell.callback = {
                    cell.tf.endEditing(true)
                    myDropDown.show()
                }
                
                //default
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
            return (tableView.layer.frame.height/12) * 3
        }
        return (tableView.layer.frame.height/11)
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
//                let err = error as! DataError
                if (error == DataError.invalidResponse401.localizedDescription) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self?.showToast(message: "Hết phiên đăng nhập", font: .systemFont(ofSize: 12.0))
                        TokenService.tokenInstance.removeTokenAndInfo()
                        self?.changeScreen(modelType: LoginFirstScreenViewController.self, id: "LoginFirstScreenViewController")
                    }
                } else if (error == DataError.invalidResponse500.localizedDescription){
                    DispatchQueue.main.async {
                        self?.showToast(message: "Chưa kết nối mạng", font: .systemFont(ofSize: 12.0))
                        self?.stoppedLoader(loader: loader ?? UIAlertController())
                    }
                }
                else {
                    DispatchQueue.main.async {
                        self?.showToast(message: error!, font: .systemFont(ofSize: 12.0))
                        self?.stoppedLoader(loader: loader ?? UIAlertController())
                    }
                }
            case .logout: break
            case .updateProfile:
                DispatchQueue.main.async {
                    self?.VM.getUserDetailFromSever()
                }
                //reloadtb
            }
        }
    }

}

