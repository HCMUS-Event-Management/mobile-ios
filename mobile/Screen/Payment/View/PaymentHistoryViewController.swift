//
//  PaymentHistoryViewController.swift
//  mobile
//
//  Created by NguyenSon_MP on 18/05/2023.
//

import UIKit
import Reachability
class PaymentHistoryViewController: UIViewController {
    private var isLoading = false
    @IBOutlet weak var tb: UITableView!
    private var VM =  PaymentViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        VM.fetchPaymentHistory()
        configNaviBar()
    }
    
    
    func configNaviBar() {
        navigationController?.navigationBar.tintColor = .label
        
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        title.text = "Lịch sử thanh toán"
        title.font = UIFont(name: "Helvetica Bold", size: 18)
        title.textAlignment = .center
        
        navigationItem.leftBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .done, target: self, action: #selector(backScreen)),UIBarButtonItem(customView: title)]
    }
    
    @objc func backScreen() {
        navigationController?.popViewController(animated: true)
    }

    
    func loadMoreData() {
        if self.isLoading == false {
            self.isLoading = true
            DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)) { // Remove the 1-second delay if you want to load the data without waiting
                // Download more data here
                DispatchQueue.main.async {
                    self.VM.getNextPaymentHistory(completion: {
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

extension PaymentHistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.VM.paymentsHistory.count - 2, !isLoading {
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

extension PaymentHistoryViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            // Return the amount of items
            if VM.paymentsHistory.count == 0 {
                return 1
            }
            return VM.paymentsHistory.count
        } else if section == 1 {
            // Return the Loading cell
            return 1
        } else {
            // Return nothing
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            if self.VM.paymentsHistory.count == 0 {
                if let cell =  tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? TableViewCell {
                    cell.descrip.text = "Không có thanh toán nào"
                   return cell
                }
            } else {
                let payment = VM.paymentsHistory[indexPath.row]
                if let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentHistoryTableViewCell", for: indexPath) as? PaymentHistoryTableViewCell  {
                    cell.desciption.text = payment.description1
                    cell.owner.text = payment.user?.fullName
                    //                cell.price.text = "\(payment.price.formatted(.currency(code: payment.currency)))"
                    
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    
                    let date = dateFormatter.date(from: payment.createdAt)
                    
                    if #available(iOS 15.0, *) {
                        cell.date.text = date?.formatted(date: .abbreviated, time: .omitted)
                    } else {
                        // Xử lý cho phiên bản iOS dưới 15.0
                        // Ví dụ: Hiển thị ngày giờ theo định dạng tùy chỉnh
                        let customDateFormatter = DateFormatter()
                        customDateFormatter.dateFormat = "yyyy-MM-dd"
                        let dateString = customDateFormatter.string(from: date ?? Date())
                        cell.date.text = dateString
                    }
                    
                    //                let dateFormatter = DateFormatter()
                    //                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                    //                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    //
                    //                let date = dateFormatter.date(from:payment.createdAt)
                    //
                    //                cell.date.text = date?.formatted(date: .abbreviated, time: .omitted)
                    
                    if payment.method == "paypal" {
                        cell.logo.image  = UIImage(named: "PaypalLogo")
                    } else if payment.method == "vnpay" {
                        cell.logo.image  = UIImage(named: "VnpayLogo")
                    }
                    
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


extension PaymentHistoryViewController {

    func configuration() {
        
        self.tb.register(UINib(nibName: "PaymentHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "PaymentHistoryTableViewCell")
        self.tb.register( UINib(nibName: "LoadingTableViewCell", bundle: nil), forCellReuseIdentifier: "LoadingTableViewCell")
        self.tb.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")

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
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self?.stoppedLoader(loader: loader ?? UIAlertController())
                }
            case .dataLoaded:
                DispatchQueue.main.async {
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
            }
        }

    }
}
