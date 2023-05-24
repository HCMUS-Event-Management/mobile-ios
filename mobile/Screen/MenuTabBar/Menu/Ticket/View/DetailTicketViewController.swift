//
//  DetailTicketViewController.swift
//  mobile
//
//  Created by NguyenSon_MP on 17/03/2023.
//

import UIKit
import SwiftyRSA
class DetailTicketViewController: UIViewController {
    
    private var VM = TicketViewModel()
    private var profileViewModel = ProfileViewModel()
    @IBOutlet weak var tb: UITableView!
//    var callback : (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
        profileViewModel.getUser()
        VM.getMyTicketDataLocalDB()
        VM.getBoughtTicketDataLocalDB()

        let ticketCodeDetail = Contanst.userdefault.string(forKey: "ticketCodeDetail")!
        
        VM.fetchDetailTicket(ticketCodeDetail)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configNaviBar()
    }
    
    func configNaviBar() {
        navigationController?.navigationBar.tintColor = .label
        
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        title.text = "Detail Ticket"
        title.font = UIFont(name: "Helvetica Bold", size: 18)
        title.textAlignment = .center
        
        navigationItem.leftBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .done, target: self, action: #selector(backScreen)),UIBarButtonItem(customView: title)]
    }
    
    @objc func backScreen() {
        navigationController?.popViewController(animated: true)
    }
    
    

}


extension DetailTicketViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ticket = VM.detail

        if indexPath.section == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ImageQRCodeTableViewCell", for: indexPath) as? ImageQRCodeTableViewCell  {
                // hash
                let info = "\(VM.detail.eventId)-\(VM.detail.ticketCode)-\(profileViewModel.userInfo!.id!)"
                let encryptedString = hashRSA(from: info)
                decodeRSA(from: encryptedString ?? "")
                let image = generateQRCode(from: encryptedString!)
                cell.imgQR.image = image
                return cell
            }
        } else if indexPath.section == 1 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "InfoEventTableViewCell", for: indexPath) as? InfoEventTableViewCell  {

                cell.eventName.text = ticket.session?.event?.title
                cell.location.text = ticket.session?.event?.locationId
                
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                let startDate = dateFormatter.date(from:  ticket.session?.startAt ?? "1970-01-01T00:00:00.000Z")
                let endDate = dateFormatter.date(from:  ticket.session?.endAt ?? "1970-01-01T00:00:00.000Z")
                
                cell.date.text = "\tStart Date: \(startDate!.formatted(date: .abbreviated, time: .omitted))  \(startDate!.formatted(date: .omitted, time: .shortened)) \n\n\tEnd Date  : \(endDate!.formatted(date: .abbreviated, time: .omitted)) \(endDate!.formatted(date: .omitted, time: .shortened))"
                
                cell.organizer.text = ticket.owner?.fullName
                return cell
            }
        } else if indexPath.section == 2 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "InfoTicketTableViewCell", for: indexPath) as? InfoTicketTableViewCell  {
                cell.buyerId.text = ticket.buyer?.fullName
//                cell.eventTicket.text = ticket.se
                if let ownerId = ticket.owner?.id {
                    cell.btnAddOwner.isHidden = true
                    cell.ownerId.isHidden = false
                    cell.ownerId.text = ownerId
                }
                
                
                return cell
            }
        } else if indexPath.section == 3 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "InfoPaymentTableViewCell", for: indexPath) as? InfoPaymentTableViewCell  {
                cell.eventId.text = ticket.session?.eventId
                cell.method.text = ticket.paymentMethod
                cell.discount.text = ticket.discount.formatted(.currency(code: "VND"))
                cell.ticketPrice.text = ticket.price.formatted(.currency(code: "VND"))
                cell.total.text = (ticket.price - ticket.discount).formatted(.currency(code: "VND"))
                return cell
            }
        }
        

        return UITableViewCell()
    }
    
    
    
    
}
extension DetailTicketViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return tableView.layer.frame.height / 3
        } else if indexPath.section == 2 {
            return tableView.layer.frame.height / 4
        } else if indexPath.section == 3 {
            return tableView.layer.frame.height / 3.5
        }
        
        return tableView.layer.frame.height / 2.5
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.changeScreen(modelType: DetailTicketViewController.self, id: "DetailTicketViewController")
//    }

   
}

extension DetailTicketViewController {

    func configuration() {
        
        self.tb.register(UINib(nibName: "InfoEventTableViewCell", bundle: nil), forCellReuseIdentifier: "InfoEventTableViewCell")
        self.tb.register(UINib(nibName: "InfoTicketTableViewCell", bundle: nil), forCellReuseIdentifier: "InfoTicketTableViewCell")
        self.tb.register(UINib(nibName: "ImageQRCodeTableViewCell", bundle: nil), forCellReuseIdentifier: "ImageQRCodeTableViewCell")
        self.tb.register(UINib(nibName: "InfoPaymentTableViewCell", bundle: nil), forCellReuseIdentifier: "InfoPaymentTableViewCell")

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
                self?.stoppedLoader(loader: loader ?? UIAlertController())
            case .dataLoaded:
                print("Detaik Ticket loaded...")
                DispatchQueue.main.async {
//                    self?.tb.reloadSections([0], with: .none)
                    self?.tb.reloadData()
//                    self?.stoppedLoader(loader: loader ?? UIAlertController())

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
//                DispatchQueue.main.async {
//                    self?.changeScreen(modelType: LoginFirstScreenViewController.self, id: "LoginFirstScreenViewController")
//                }
                print("logout")
            }
        }
    }

}
