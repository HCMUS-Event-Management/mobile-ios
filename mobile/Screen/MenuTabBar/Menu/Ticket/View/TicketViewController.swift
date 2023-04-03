//
//  TicketViewController.swift
//  mobile
//
//  Created by NguyenSon_MP on 16/02/2023.
//

import UIKit
import LZViewPager
import RealmSwift
class TicketViewController: UIViewController {

    @IBOutlet weak var pageView: LZViewPager!
    private var subControllers:[UIViewController] = []
    private var VM = TicketViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()

        pageView.dataSource = self
        pageView.delegate = self
        pageView.hostController = self
        
        
        let vc1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyTicketsViewController") as! MyTicketsViewController
        vc1.title = "My ticket"
        
        let vc2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BoughtTicketsViewController") as! BoughtTicketsViewController
        vc2.title = "Bought ticket"
        subControllers = [vc1, vc2]
        pageView.reload()
        
        configuration()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = false
        print(Realm.Configuration.defaultConfiguration.fileURL)
        configNaviBar()
        
        VM.fetchMyTicket()
    }
    
    func configNaviBar() {
        navigationController?.navigationBar.tintColor = .label
        
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        title.text = "Ticket"
        title.font = UIFont(name: "Helvetica Bold", size: 18)
        title.textAlignment = .center
        
        navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: title)]
    }
    


}

extension TicketViewController: LZViewPagerDataSource, LZViewPagerDelegate {
    func numberOfItems() -> Int {
        return self.subControllers.count
        }
    
    func controller(at index: Int) -> UIViewController {
        return subControllers[index]

    }
    
    func button(at index: Int) -> UIButton {
        //Customize your button styles here
       let button = UIButton()
       button.setTitleColor(UIColor.black, for: .normal)
        button.setTitleColor( UIColor(red: 94/255, green: 135/255, blue: 240/255, alpha: 1), for: .selected)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left

       return button
    }
    func widthForIndicator(at index: Int) -> CGFloat {
        return pageView.layer.frame.width / 3
    }
    func heightForIndicator() -> CGFloat {
        return 4
    }
    
    func colorForIndicator(at index: Int) -> UIColor {
        return UIColor(red: 94/255, green: 135/255, blue: 240/255, alpha: 1)
    }
    
    func widthForButton(at index: Int) -> CGFloat {
        return pageView.layer.frame.width / 3
    }
    
    func shouldShowSeparator() -> Bool {
        return true
    }
    
    func colorForSeparator()-> UIColor {
        return UIColor.lightGray
    }
    
    func heightForSeparator() -> CGFloat {
        return 1
    }
    
    func backgroundColorForHeader() -> UIColor {
        return UIColor.white
    }
}


extension TicketViewController {

    func configuration() {

        
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
                self?.stoppedLoader(loader: loader ?? UIAlertController())
            case .dataLoaded:
                print("get User loaded...")
                let container = try! Container()
                try! container.get(DataMyTicketObject.self)
            case .error(let error):
//                let err = error as! DataError
                if (error == DataError.invalidResponse401.localizedDescription) {
                    DispatchQueue.main.async {
                        self?.showToast(message: "Hết phiên đăng nhập", font: .systemFont(ofSize: 12.0))
                        TokenService.tokenInstance.removeTokenAndInfo()
                        self?.changeScreen(modelType: LoginFirstScreenViewController.self, id: "LoginFirstScreenViewController")
                    }
                }
            case .logout:
                // xử lý logout tại đây
//                DispatchQueue.main.async {
//                    self?.changeScreen(modelType: LoginFirstScreenViewController.self, id: "LoginFirstScreenViewController")
//                }
                print("logout")
        }
    }

}
}


