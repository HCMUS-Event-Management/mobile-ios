//
//  MyTicketsViewController.swift
//  mobile
//
//  Created by NguyenSon_MP on 17/03/2023.
//

import UIKit
import Reachability
class MyTicketsViewController: UIViewController {
    private var isLoading = false
    let refreshControl = UIRefreshControl()
    private var VM = TicketViewModel()
    @IBOutlet weak var tb: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
        

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        VM.fetchMyTicket()

    }
    
    func loadMoreData() {
        if self.isLoading == false {
            self.isLoading = true
            DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)) {
                // Download more data here
                DispatchQueue.main.async {
                    self.VM.getNextMyTicketFromServer(completion: {
                        DispatchQueue.main.async {
                            self.tb.reloadData()
                            self.isLoading = false
                        }
                    })
                   
                }
            }
        }
    }
}

extension MyTicketsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            // Return the amount of items
            if VM.myTicket.count == 0 {
                return 1
            }
            return self.VM.myTicket.count
        } else if section == 1 {
            // Return the Loading cell
            return 1
        } else {
            // Return nothing
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.section == 0 {
            if self.VM.myTicket.count == 0 {
                if let cell =  tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? TableViewCell {
                    cell.descrip.text = "Không có vé nào"
                   return cell
                }
            } else {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "TicketTableViewCell", for: indexPath) as? TicketTableViewCell  {
                    cell.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
                    
                    let ticket = VM.myTicket[indexPath.row]
                    cell.ownerName.text = ticket.owner?.fullName

                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    let date = dateFormatter.date(from: ticket.session?.startAt ?? "1970-01-01T00:00:00.000Z")
                    
                    if #available(iOS 15.0, *) {
                        let formattedDate = date?.formatted(date: .abbreviated, time: .omitted)
                        let formattedTime = date?.formatted(date: .omitted, time: .shortened)
                        cell.startTimeSession.text = "\(formattedDate ?? "") - \(formattedTime ?? "")"
                    } else {
                        dateFormatter.dateFormat = "MMM d, yyyy"
                        let formattedDate = dateFormatter.string(from: date ?? Date())
                        dateFormatter.dateFormat = "h:mm a"
                        let formattedTime = dateFormatter.string(from: date ?? Date())
                        cell.startTimeSession.text = "\(formattedTime) - \(formattedDate)"
                    }
                    
                    //                let dateFormatter = DateFormatter()
                    //                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                    //                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    //                let date = dateFormatter.date(from:  ticket.session?.startAt ?? "1970-01-01T00:00:00.000Z")
                    //
                    //                cell.startTimeSession.text = "\(date!.formatted(date: .abbreviated, time: .omitted)) - \(date!.formatted(date: .omitted, time: .shortened))"
                    cell.titleEvent.text = ticket.session?.event?.title
                    cell.location.text = ticket.session?.event?.location?.name
                    if let isOnline = ticket.session?.event?.isOnline {
                        if isOnline {
                            cell.paidName.text = "Trực tuyến"
                            cell.paidView.backgroundColor = UIColor(red: 1.0, green: 0, blue: 0, alpha: 0.5)
                        } else {
                            cell.paidName.text = "Trực tiếp"
                            cell.paidView.backgroundColor = UIColor(red: 149/255, green: 210/255, blue: 144/255, alpha: 0.75)
                        }
                    }
                    
                    cell.isChecking.isHidden = !ticket.isCheckin
                    
                    cell.img.kf.setImage(with: URL(string: ticket.session?.event!.image ?? "https://nestjs-entity-service-bucket.s3.ap-southeast-1.amazonaws.com/event_id_186/seating_plan/wF9NFk0T7NVnhDAXoh3AU8Uz1xBLBpbkrsS4a2Poo0EybGK5EE.jpeg"))
                    
                    return cell
                }
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingTableViewCell", for: indexPath) as! LoadingTableViewCell

            if self.VM.numberPageMyTicket >= self.VM.currentPageMyTicket {
                cell.indicator.startAnimating()
            } else {
                cell.indicator.stopAnimating()
                cell.indicator.hidesWhenStopped = true
            }
            return cell
        }
        
       
        return UITableViewCell()
    }
    
    
    
    
}
extension MyTicketsViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return tableView.layer.frame.height / 4
        } else {
            return 55 // Loading Cell height
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.VM.myTicket.count != 0 {
            Contanst.userdefault.set(VM.myTicket[indexPath.row].ticketCode, forKey: "ticketCodeDetail")
            changeScreen(modelType: DetailTicketViewController.self, id: "DetailTicketViewController")
        }

    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.VM.myTicket.count - 2, !isLoading {
            switch try! Reachability().connection {
              case .wifi:
                loadMoreData()
              case .cellular:
                loadMoreData()
              case .none: break
              case .unavailable: break
            }
            
        }
    }

   
}

 
extension MyTicketsViewController {

    @objc private func refreshData(_ sender: Any) {
        
        self.VM.fetchMyTicket()
    }

    func configuration() {
        self.tb.register(UINib(nibName: "TicketTableViewCell", bundle: nil), forCellReuseIdentifier: "TicketTableViewCell")
        self.tb.register( UINib(nibName: "LoadingTableViewCell", bundle: nil), forCellReuseIdentifier: "LoadingTableViewCell")
        self.tb.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")

        self.tb.dataSource = self
        self.tb.delegate = self
        
        self.refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        self.tb.refreshControl = refreshControl

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
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self?.stoppedLoader(loader: loader ?? UIAlertController())
                }
            case .dataLoaded:
                DispatchQueue.main.async {
                    self?.tb.reloadData()
                    self?.refreshControl.endRefreshing()
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
                break
            case .vadilateTicket:
                break
            case .donateSuccess:
                break
            }
        }

    }
}



