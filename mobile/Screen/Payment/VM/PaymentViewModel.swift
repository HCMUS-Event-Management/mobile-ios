//
//  PaymentViewModel.swift
//  mobile
//
//  Created by NguyenSon_MP on 18/05/2023.
//

import Foundation
import Reachability

class PaymentViewModel {
    var eventHandler: ((_ event: Event) -> Void)? // Data Binding Closure
    var paymentsHistory = [DataReponsePaymentHistoryObject]()
    var numberPageMyTicket = 1.0
    var currentPageMyTicket = 1.0
    var perPage = 10

    func getPaymentHistoryFromDB() {
        self.paymentsHistory = [DataReponsePaymentHistoryObject]()
        let container = try! Container()
        try! container.write{
            transaction in
            let temp = transaction.get(DataReponsePaymentHistoryObject.self)
            for i in temp.filter("status = %@", "PAID") {
                self.paymentsHistory.append(i)
            }
        }
        self.eventHandler?(.dataLoaded)
    }
    
    func getPaymentHistoryFromServer() {
        self.eventHandler?(.loading)
        self.currentPageMyTicket = 1

        APIManager.shared.request(modelType: ReponsePaymentHistory.self, type: PaymentEndPoint.paymentHistory(page: Int(currentPageMyTicket), perPage: perPage), params: nil, completion: {
            result in
            self.eventHandler?(.stopLoading)
            switch result {
            case .success(let value):
                
                self.numberPageMyTicket = (Double(value.total!) / Double(self.perPage)).rounded(.up)
                
                

                let container = try! Container()
                try! container.write { transaction in
                    value.data?.forEach{
                        i in
                        if i.status == "PAID" {
                            transaction.add(i, update: true)
                            self.paymentsHistory.append(i.managedObject())
                        }
                        
                    }

                }
                self.currentPageMyTicket+=1

                self.eventHandler?(.dataLoaded)
            case .failure(let error):
                if case DataError.invalidResponse(let reason) = error {
                    self.eventHandler?(.error(reason))
                }
                else {
                    self.eventHandler?(.error(error.localizedDescription))
                }
            }
        })
    }
    
    
    func fetchPaymentHistory() {
        
        
        //declare this property where it won't go out of scope relative to your listener
        let reachability = try! Reachability()
        
        switch try! Reachability().connection {
          case .wifi:
              print("Reachable via WiFi")
            getPaymentHistoryFromServer()
          case .cellular:
              print("Reachable via Cellular")
            getPaymentHistoryFromServer()
          case .none:
              print("Network not reachable")
              getPaymentHistoryFromDB()
          case .unavailable:
              print("Network not reachable")
            getPaymentHistoryFromDB()
        }

    }
    
    
    
}


extension PaymentViewModel {
    func getNextPaymentHistory(completion: @escaping (() -> ())) {
        
        if self.currentPageMyTicket <= self.numberPageMyTicket {
            APIManager.shared.request(modelType: ReponsePaymentHistory.self, type: PaymentEndPoint.paymentHistory(page: Int(currentPageMyTicket), perPage: perPage), params: nil, completion: {
                result in

                switch result {
                case .success(let ticket):
                    self.numberPageMyTicket = (Double(ticket.total!) / Double(self.perPage)).rounded(.up)
                    let container = try! Container()
                    try! container.write { transaction in
                        ticket.data?.forEach{
                            i in
                            if i.status == "PAID" {
                                transaction.add(i, update: true)
                                self.paymentsHistory.append(i.managedObject())
                            }
                        }

                    }
                    self.currentPageMyTicket+=1
                    completion()
                case .failure(let error):
                    if case DataError.invalidResponse(let reason) = error {
                        self.eventHandler?(.error(reason))
                    }
                    else {
                        self.eventHandler?(.error(error.localizedDescription))
                    }
                    completion()

                }
            })
        }
        

    }
}

extension PaymentViewModel {
    enum Event {
        case loading
        case stopLoading
        case dataLoaded
        case error(String?)
    }
}
