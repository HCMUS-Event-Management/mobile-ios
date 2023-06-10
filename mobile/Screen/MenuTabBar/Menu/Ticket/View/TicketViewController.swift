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
    override func viewDidLoad() {
        super.viewDidLoad()

        pageView.dataSource = self
        pageView.delegate = self
        pageView.hostController = self
        
        
        let vc1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyTicketsViewController") as! MyTicketsViewController
        vc1.title = "Vé của tôi"
        
        let vc2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BoughtTicketsViewController") as! BoughtTicketsViewController
        vc2.title = "Vé mua"
        subControllers = [vc1, vc2]
        pageView.reload()
        
//        configuration()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = false
        print(Realm.Configuration.defaultConfiguration.fileURL)
        configNaviBar()
        
    }
    
    func configNaviBar() {
        navigationController?.navigationBar.tintColor = .label
        
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        title.text = "Mục Vé"
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





