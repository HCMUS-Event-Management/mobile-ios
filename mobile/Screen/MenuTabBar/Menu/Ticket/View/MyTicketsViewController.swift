//
//  MyTicketsViewController.swift
//  mobile
//
//  Created by NguyenSon_MP on 17/03/2023.
//

import UIKit

class MyTicketsViewController: UIViewController {
    
    private var VM = TicketViewModel()
    @IBOutlet weak var tb: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
    }
    override func viewWillAppear(_ animated: Bool) {
        VM.fetchMyTicket()
    }
}

extension MyTicketsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.VM.myTicket.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TicketTableViewCell", for: indexPath) as? TicketTableViewCell  {
            cell.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
            
            let ticket = VM.myTicket[indexPath.section]
            
            cell.ownerName.text = ticket.owner?.fullName
            cell.startTimeSession.text = ticket.session?.startAt
            cell.titleEvent.text = ticket.session?.event?.title
            cell.location.text = ticket.session?.event?.location

            return cell
        }
        return UITableViewCell()
    }
    
    
    
    
}
extension MyTicketsViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.layer.frame.height / 4.8
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.VM.idxDetail = indexPath.section
        changeScreen(modelType: DetailTicketViewController.self, id: "DetailTicketViewController")

    }

   
}


extension MyTicketsViewController {

    func configuration() {
        self.tb.register(UINib(nibName: "TicketTableViewCell", bundle: nil), forCellReuseIdentifier: "TicketTableViewCell")

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
                print("My Ticket User loaded...")
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



