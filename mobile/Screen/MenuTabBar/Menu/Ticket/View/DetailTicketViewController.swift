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
        title.text = "Chi tiết"
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
            print(ticket.session)
            if ticket.session?.event?.isOnline == false {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "ImageQRCodeTableViewCell", for: indexPath) as? ImageQRCodeTableViewCell  {
                    // hash
                    let info = "\(VM.detail.eventId)-\(VM.detail.ticketCode)-\(profileViewModel.userInfo!.id!)"
    //                let encryptedString = hashRSA(from: info)
    //                decodeRSA(from: encryptedString ?? "")
    //                let image = generateQRCode(from: encryptedString!)
                    let image = generateQRCode(from: info)

                    cell.imgQR.image = image
                    return cell
                }
            } else {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "OpenZoomTableViewCell", for: indexPath) as? OpenZoomTableViewCell  {
                    
                    let currentDate = Date() // Get the current date and time
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    let startDate = dateFormatter.date(from: ticket.session?.startAt ?? "1970-01-01T00:00:00.000Z")
                    let endDate = dateFormatter.date(from: ticket.session?.endAt ?? "1970-01-01T00:00:00.000Z")
                    
                    if let startDate = startDate {
                        let calendar = Calendar.current
                        let yourStartDate = calendar.date(byAdding: .minute, value: -30, to: startDate)!

                        let comparisonResult = calendar.compare(currentDate, to: yourStartDate, toGranularity: .minute)
                        if comparisonResult == .orderedDescending {
                            if let endDate = endDate {
                                
                                let comparisonResult1 = calendar.compare(currentDate, to: endDate, toGranularity: .minute)
                                
                                if comparisonResult1 == .orderedAscending {
                                    cell.btnOpenZoom.isEnabled = true
                                    cell.zoomURL = ticket.session?.zoomJoinUrl
                                    cell.info = VadilateTicketDto(eventId:  Int(ticket.eventId) ,ownerId:  Int(profileViewModel.userInfo!.id!) ,ticketCode:  ticket.ticketCode)
                                    cell.delegate = self
                                } else {
                                    cell.btnOpenZoom.isEnabled = false
                                    cell.btnOpenZoom.backgroundColor = .gray
                                }
                                
                            } else {
                                print("Invalid comparison date format.")
                            }
                            

                        } else if comparisonResult == .orderedAscending {
                            cell.btnOpenZoom.isEnabled = false
                            cell.btnOpenZoom.backgroundColor = .gray
                        } else {
                            
                            cell.btnOpenZoom.isEnabled = true
                            cell.zoomURL = ticket.session?.zoomJoinUrl
                            cell.info = VadilateTicketDto(eventId:  Int(ticket.eventId) ,ownerId:  Int(profileViewModel.userInfo!.id!) ,ticketCode:  ticket.ticketCode)
                            cell.delegate = self
                        }
                        
                    } else {
                        print("Invalid comparison date format.")
                    }

                    cell.img.kf.setImage(with: URL(string: ticket.session?.event?.image ?? ""))

                    return cell
                }
            }
            
        } else if indexPath.section == 1 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "InfoEventTableViewCell", for: indexPath) as? InfoEventTableViewCell  {

                cell.eventName.text = ticket.session?.event?.title
                cell.location.text = ticket.session?.event?.location?.name  
                
//                let dateFormatter = DateFormatter()
//                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//                let startDate = dateFormatter.date(from:  ticket.session?.startAt ?? "1970-01-01T00:00:00.000Z")
//                let endDate = dateFormatter.date(from:  ticket.session?.endAt ?? "1970-01-01T00:00:00.000Z")
//
//                cell.date.text = "Start Date : \(startDate!.formatted(date: .abbreviated, time: .omitted))  \(startDate!.formatted(date: .omitted, time: .shortened)) \nEnd Date   : \(endDate!.formatted(date: .abbreviated, time: .omitted)) \(endDate!.formatted(date: .omitted, time: .shortened))"
                
                
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

                let startDate = dateFormatter.date(from: ticket.session?.startAt ?? "1970-01-01T00:00:00.000Z")
                let endDate = dateFormatter.date(from: ticket.session?.endAt ?? "1970-01-01T00:00:00.000Z")

                var formattedStartDate: String
                var formattedEndDate: String

                if #available(iOS 15.0, *) {
                    formattedStartDate = startDate?.formatted(date: .abbreviated, time: .omitted) ?? ""
                    formattedEndDate = endDate?.formatted(date: .abbreviated, time: .omitted) ?? ""
                } else {
                    let newDateFormatter = DateFormatter()
                    newDateFormatter.dateStyle = .short
                    newDateFormatter.timeStyle = .none
                    formattedStartDate = newDateFormatter.string(from: startDate ?? Date())
                    formattedEndDate = newDateFormatter.string(from: endDate ?? Date())
                }
                
                let timeFormatter = DateFormatter()
                timeFormatter.locale = Locale(identifier: "en_US_POSIX")
                timeFormatter.dateFormat = "HH:mm"

                let formattedStartTime = timeFormatter.string(from: startDate ?? Date())
                let formattedEndTime = timeFormatter.string(from: endDate ?? Date())
                

                
                
                cell.date.text = "\(formattedStartTime) \(formattedStartDate) - \(formattedEndTime) \(formattedEndDate)"
                
                
                
                
                cell.organizer.text = ticket.owner?.fullName
                return cell
            }
        } else if indexPath.section == 2 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "InfoTicketTableViewCell", for: indexPath) as? InfoTicketTableViewCell  {
                cell.buyerId.text = ticket.buyer?.fullName
//                cell.eventTicket.text = ticket.se
                
                
                return cell
            }
        } else if indexPath.section == 3 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "InfoPaymentTableViewCell", for: indexPath) as? InfoPaymentTableViewCell  {
                cell.method.text = ticket.paymentMethod
                let currencyFormatter = NumberFormatter()
                currencyFormatter.numberStyle = .currency
                currencyFormatter.currencyCode = "VND"

                if #available(iOS 15.0, *) {
                    currencyFormatter.formattingContext = .standalone
                }

                

                if #available(iOS 15.0, *) {
                    cell.discount.text = ticket.discount.formatted(.currency(code: "VND"))
                    cell.ticketPrice.text = ticket.price.formatted(.currency(code: "VND"))
                    let total = ticket.price - ticket.discount
                    cell.total.text = total.formatted(.currency(code: "VND"))
                } else {
                    let discountFormatted = currencyFormatter.string(from: NSNumber(value: ticket.discount))
                    cell.discount.text = discountFormatted
                    let priceFormatted = currencyFormatter.string(from: NSNumber(value: ticket.price))
                    cell.ticketPrice.text = priceFormatted
                    let totalFormatted = currencyFormatter.string(from: NSNumber(value: ticket.price - ticket.discount))
                    cell.total.text = totalFormatted
                }
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
            return tableView.layer.frame.height / 5
        } else if indexPath.section == 3 {
            return tableView.layer.frame.height / 4
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
        self.tb.register(UINib(nibName: "OpenZoomTableViewCell", bundle: nil), forCellReuseIdentifier: "OpenZoomTableViewCell")

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
                print("loading")
                loader = self?.loader()
            case .stopLoading:
                print("stoploading")
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self?.stoppedLoader(loader: loader ?? UIAlertController())
                }
            case .dataLoaded:
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self?.tb.reloadData()
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
            case .logout:
                // xử lý logout tại đây
//                DispatchQueue.main.async {
//                    self?.changeScreen(modelType: LoginFirstScreenViewController.self, id: "LoginFirstScreenViewController")
//                }
                print("logout")
            case .vadilateTicket:
                DispatchQueue.main.async {
                    guard let url = URL(string: self?.VM.detail.session?.zoomJoinUrl ?? "") else {
                        return
                    }
            
                    // Check if the device has Zoom installed
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        // Zoom is not installed, handle the case as needed
                        // For example, show an error message or redirect to Zoom website
                    }
                }
            }
        }
    }

}


extension DetailTicketViewController: OpenZoomTableViewCellDelegate {
    func callApi() {
        self.VM.vadilateTicket(from: VadilateTicketDto(eventId:  Int(VM.detail.eventId) ,ownerId:  Int(profileViewModel.userInfo!.id!) ,ticketCode:  VM.detail.ticketCode))
    }
}
