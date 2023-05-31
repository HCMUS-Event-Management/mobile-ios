//
//  HomeViewController.swift
//  mobile
//
//  Created by NguyenSon_MP on 16/02/2023.
//

import UIKit
import RealmSwift
class HomeViewController: UIViewController {

    @IBOutlet weak var cl: UICollectionView!
    
    private var VM = HomeViewModel()
    
    private var titleSection = ["Ongoing Events 🔥","Upcoming Events ✨"]
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
        VM.getListEventForHome()
        print(Realm.Configuration.defaultConfiguration.fileURL)
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
       configNaviBar()
    }
    
    func configNaviBar() {
        navigationController?.navigationBar.tintColor = .label
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        label.text = "Xin Chào,\n"
        label.font = UIFont(name: "Helvetica", size: 18)
        label.textAlignment = .center
        label.textColor = .gray
        
        let txtFullname = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        txtFullname.text = ""
        txtFullname.font = UIFont(name: "Helvetica Bold", size: 18)
        
        txtFullname.textAlignment = .center
        
        
        if let userInfo = Contanst.userdefault.object(forKey: "userInfo") as? Data {
            let decoder = JSONDecoder()
            if let savedUser = try? decoder.decode(GetUserInfor.self, from: userInfo) {
                txtFullname.text = savedUser.fullName ?? ""
            }
        }
        
        navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: label),UIBarButtonItem(customView: txtFullname)]

    }
    
    func changeDetailEvent(indexPath: IndexPath) {
        if indexPath.section == 0 {
            Contanst.userdefault.set(VM.goingOnEvent[indexPath.row].id, forKey: "eventIdDetail")
        } else {
            Contanst.userdefault.set(VM.isCommingEvent[indexPath.row].id, forKey: "eventIdDetail")

        }
        changeScreen(modelType: DetailEventViewController.self, id: "DetailEventViewController")
    }

}


extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let eventGoingOnEvent = self.VM.goingOnEvent[indexPath.row]
            if let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "EventCollectionViewCell", for: indexPath) as? EventCollectionViewCell {
                cell.eventName.text = eventGoingOnEvent.title
                cell.owner.text = "By \(eventGoingOnEvent.user!.fullName)"
                cell.paidName.text = eventGoingOnEvent.type
                if #available(iOS 15.0, *) {
                    cell.timeStart.text = eventGoingOnEvent.startAt?.formatted(date: .abbreviated, time: .omitted)
                } else {
                    let newDateFormatter = DateFormatter()
                    newDateFormatter.dateStyle = .short
                    newDateFormatter.timeStyle = .none
                    let formattedDate = newDateFormatter.string(from: eventGoingOnEvent.startAt ?? Date())
                    cell.timeStart.text = formattedDate
                
                }
                cell.locationName.text = eventGoingOnEvent.location?.name
                
                cell.imgAvatar.kf.setImage(with: URL(string: self.VM.goingOnEvent[indexPath.row].image))

                cell.callback = {
                    self.changeDetailEvent(indexPath: indexPath)
                }
                cell.layer.cornerRadius = 10
                cell.layer.masksToBounds = true
                
                return cell
            }
        } else if indexPath.section == 1{
            let eventIsCommingEvent = self.VM.isCommingEvent[indexPath.row]
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventCollectionViewCell", for: indexPath) as? EventCollectionViewCell {
                
                cell.eventName.text = eventIsCommingEvent.title
                cell.owner.text = "By \(eventIsCommingEvent.user!.fullName)"
                cell.paidName.text = eventIsCommingEvent.type
                if #available(iOS 15.0, *) {
                    cell.timeStart.text = eventIsCommingEvent.startAt?.formatted(date: .abbreviated, time: .omitted)
                } else {
                    let newDateFormatter = DateFormatter()
                    newDateFormatter.dateStyle = .short
                    newDateFormatter.timeStyle = .none
                    let formattedDate = newDateFormatter.string(from: eventIsCommingEvent.startAt ?? Date())
                    cell.timeStart.text = formattedDate
                
                }
                cell.locationName.text = eventIsCommingEvent.location?.name
                cell.imgAvatar.kf.setImage(with: URL(string: self.VM.isCommingEvent[indexPath.row].image))

                
                cell.callback = {
                    self.changeDetailEvent(indexPath: indexPath)
                }
                
                cell.layer.cornerRadius = 10
                cell.layer.masksToBounds = true
                
                return cell
            }
        }
        
        return UICollectionViewCell()

    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(section == 0) {
            return self.VM.goingOnEvent.count
        } else {
            return self.VM.isCommingEvent.count
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2 - 10, height: 220)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HomeCollectionReusableView", for: indexPath) as? HomeCollectionReusableView{
            sectionHeader.tilte.text = titleSection[indexPath.section]
            return sectionHeader
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        changeDetailEvent(indexPath: indexPath)
    }
}


extension HomeViewController {

    func configuration() {
        self.cl.register(UINib(nibName: "EventCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "EventCollectionViewCell")
        self.cl.dataSource = self
        self.cl.delegate = self
        
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
                print(self!.VM.isCommingEvent)
                DispatchQueue.main.async {
                    self?.cl.reloadData()
                    self?.stoppedLoader(loader: loader ?? UIAlertController())
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
            }
        }

    }
}
