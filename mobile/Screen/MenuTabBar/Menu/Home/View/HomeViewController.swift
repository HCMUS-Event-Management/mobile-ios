//
//  HomeViewController.swift
//  mobile
//
//  Created by NguyenSon_MP on 16/02/2023.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var cl: UICollectionView!
    private var titleSection = ["Ongoing Events 🔥","Upcoming Events ✨"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cl.register(UINib(nibName: "EventCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "EventCollectionViewCell")
        self.cl.dataSource = self
        self.cl.delegate = self
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
//        tabBarController?.tabBar.isHidden = false
       configNaviBar()
    }
    
    func configNaviBar() {
        navigationController?.navigationBar.tintColor = .label
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        label.text = "Xin Chào,"
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventCollectionViewCell", for: indexPath) as? EventCollectionViewCell {
            
            cell.layer.cornerRadius = 10
            cell.layer.masksToBounds = true
            
            return cell
        }
        return UICollectionViewCell()

    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
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
}

