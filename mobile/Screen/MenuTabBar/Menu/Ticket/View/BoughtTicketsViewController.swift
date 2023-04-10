//
//  MyTicketsViewController.swift
//  mobile
//
//  Created by NguyenSon_MP on 17/03/2023.
//

import UIKit

class BoughtTicketsViewController: UIViewController {
    
    private var isLoading = false
    private var VM = TicketViewModel()
    @IBOutlet weak var tb: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
        VM.fetchBoughtTicket()

    }
    override func viewWillAppear(_ animated: Bool) {
    }
    
    func loadMoreData() {
        if self.isLoading == false {
            self.isLoading = true
            DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)) { // Remove the 1-second delay if you want to load the data without waiting
                // Download more data here
                DispatchQueue.main.async {
                    self.VM.getNextBoughtTicketFromServer(completion: {
                        DispatchQueue.main.async {
                            self.tb.reloadData()
                            self.isLoading = false
                        }
                    })
                   
                }
            }
        } else {
            print("loading")
        }
    }
}

extension BoughtTicketsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            // Return the amount of items
            return self.VM.boughtTicket.count
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
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return self.VM.boughtTicket.count
//    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return .leastNormalMagnitude
//    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return UIView()
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    
    
    if indexPath.section == 0 {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TicketTableViewCell", for: indexPath) as? TicketTableViewCell  {
            cell.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
            
            let ticket = VM.boughtTicket[indexPath.section]
            
            cell.ownerName.text = ticket.owner?.fullName
            cell.startTimeSession.text = ticket.session?.startAt
            cell.titleEvent.text = ticket.session?.event?.title
            cell.location.text = ticket.session?.event?.location

            return cell
        }
    } else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingTableViewCell", for: indexPath) as! LoadingTableViewCell
//            print(self.VM.currentPage)
//            print(self.VM.numberPage)

        if self.VM.numberPageBoughtTicket >= self.VM.currentPageBoughtTicket {
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


extension BoughtTicketsViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return tableView.layer.frame.height / 4
        } else {
            return 55 // Loading Cell height
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Contanst.userdefault.set("B", forKey: "idxDetailType")
        Contanst.userdefault.set(indexPath.row, forKey: "idxDetail")

        print(indexPath.row)
        changeScreen(modelType: DetailTicketViewController.self, id: "DetailTicketViewController")

    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.VM.boughtTicket.count - 4, !isLoading {
            loadMoreData()
        }
    }
    
}


extension BoughtTicketsViewController {

    func configuration() {
        self.tb.register(UINib(nibName: "TicketTableViewCell", bundle: nil), forCellReuseIdentifier: "TicketTableViewCell")
        self.tb.register( UINib(nibName: "LoadingTableViewCell", bundle: nil), forCellReuseIdentifier: "LoadingTableViewCell")

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
                print("Bought Ticket User loaded...")
                DispatchQueue.main.async {
                    self?.tb.reloadData()
                }
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



