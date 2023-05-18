//
//  EventViewController.swift
//  mobile
//
//  Created by NguyenSon_MP on 17/05/2023.
//

import UIKit

class EventViewController: UIViewController {

    @IBOutlet weak var clEvent: UICollectionView!
    @IBOutlet weak var clType: UICollectionView!
    
    private var VM = EventsViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configuration()
        VM.getCategoryAllFromServer()
    }

    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        configNaviBar()
    }
    
    func configNaviBar() {
        navigationController?.navigationBar.tintColor = .label
        
        
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        title.text = "Events"
        title.font = UIFont(name: "Helvetica Bold", size: 18)
        title.textAlignment = .center
        
        navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: title)]
    }


}


extension EventViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.clType {
            return VM.catagorys.count
        } else if collectionView == self.clEvent {
            return VM.events.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.clType {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TypeCollectionViewCell", for: indexPath) as? TypeCollectionViewCell {
                cell.layer.cornerRadius = 30
                cell.layer.masksToBounds = true
                cell.category.text = VM.catagorys[indexPath.row].name
                return cell
            }
            
        }else if collectionView == self.clEvent {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventCollectionViewCell", for: indexPath) as? EventCollectionViewCell {
                
                cell.eventName.text = VM.events[indexPath.row].title
                cell.layer.cornerRadius = 10
                cell.layer.masksToBounds = true
                
                return cell
            }
        }
        return UICollectionViewCell()
    }
     
}


extension EventViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.clEvent {
            return CGSize(width: collectionView.frame.width/2 - 10, height: 220)

        } else if collectionView == self.clType {
            return CGSize(width: collectionView.frame.width/4, height: 100)
        }
        return CGSize(width: collectionView.frame.width/2 - 10, height: 220)

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.clType {
//            if let selectedCell:UICollectionViewCell = self.clType.cellForItem(at: indexPath) {
//                if selectedCell.isSelected == true {
//                    selectedCell.contentView.backgroundColor = UIColor(red: 102/256, green: 255/256, blue: 255/256, alpha: 0.66)
//                } else {
//                    selectedCell.contentView.backgroundColor = UIColor.clear
//                }
//            }
            VM.getListEventOfUserFromServer(fullTextSearch: VM.catagorys[indexPath.row].label)
        } else if collectionView == self.clEvent {
            Contanst.userdefault.set(VM.events[indexPath.row].id, forKey: "eventIdDetail")
            changeScreen(modelType: DetailEventViewController.self, id: "DetailEventViewController")
        }
    }
}



extension EventViewController {

    func configuration() {
        self.clEvent.register(UINib(nibName: "EventCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "EventCollectionViewCell")
        self.clType.register(UINib(nibName: "TypeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TypeCollectionViewCell")
//
        self.clType.dataSource = self
        self.clType.delegate = self

        self.clEvent.dataSource = self
        self.clEvent.delegate = self
        
        self.clType.contentInsetAdjustmentBehavior = .never;
    
        
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
            case .categoryLoaded:
                DispatchQueue.main.async {
                    self?.clType.reloadData()
                    let ind =  IndexPath(item: 0, section: 0)
                    self?.clType.selectItem(at:ind, animated: false, scrollPosition: [])
                    self?.collectionView((self?.clType)!, didSelectItemAt:ind)
                    self?.clEvent.reloadData()
                    self?.stoppedLoader(loader: loader ?? UIAlertController())
                }
            case .dataLoaded:
                DispatchQueue.main.async {
//                    self?.clType.reloadData()
                    self?.clEvent.reloadData()
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
    
