//
//  TicketViewModel.swift
//  mobile
//
//  Created by NguyenSon_MP on 02/04/2023.
//

import Foundation
import Reachability

class TicketViewModel {
    
    var idxDetail = 0
    var idxDetailType = "M"
    var detail = DataMyTicketObject()
    
    // my ticket
    var myTicket = [DataMyTicketObject]()
    var numberPageMyTicket = 1.0
    var currentPageMyTicket = 1.0

    // bought ticket
    var boughtTicket = [DataBoughtTicketObject]()
    var numberPageBoughtTicket = 1.0
    var currentPageBoughtTicket = 1.0
    
    var perPage = 10
    var eventHandler: ((_ event: Event) -> Void)? // Data Binding Closure

    func fetchDetailTicket(_ ticketCode: String) {
        self.eventHandler?(.loading)
        APIManager.shared.request(modelType: ReponseDetailTicket.self, type: EntityEndPoint.ticketDetail(ticketCode: ticketCode), params: nil, completion: { result in
            self.eventHandler?(.stopLoading)

            switch result {
                case .success(let detail):
                    self.detail = (detail.data?.managedObject())!
                print(self.detail.id)
                    self.eventHandler?(.dataLoaded)
                    
                case .failure(let error):
                    if case DataError.invalidResponse400(let reason) = error {
                        self.eventHandler?(.error(reason))
                    }
                    else {
                        self.eventHandler?(.error(error.localizedDescription))
                    }
            }})
        
        }
    
    
//    func fetchBoughtTicket() {
//
//        let container = try! Container()
//        try! container.write {
//            transaction in
//            let check = transaction.objectExist(DataBoughtTicketObject.self)
//            if check {
//                self.eventHandler?(.loading)
//                APIManager.shared.request(modelType: ReponseBoughtTicket.self, type: EntityEndPoint.boughtTicket(page: Int(currentPage), perPage: perPage), params: nil, completion: {
//                    result in
//                    self.eventHandler?(.stopLoading)
//
//                    switch result {
//                    case .success(let ticket):
//                        print(ticket)
//                        let container = try! Container()
//                        try! container.write { transaction in
//                            ticket.data?.forEach{
//                                i in
//                                transaction.add(i, update: true)
//                                self.boughtTicket.append(i.managedObject())
//                            }
//
//                        }
//                        self.eventHandler?(.dataLoaded)
//
//                    case .failure(let error):
//                        if case DataError.invalidResponse400(let reason) = error {
//                            self.eventHandler?(.error(reason))
//                        }
//                        else {
//                            self.eventHandler?(.error(error.localizedDescription))
//                        }
//
//                    }
//                })
//            } else {
//                self.boughtTicket = [DataBoughtTicketObject]()
//                let container = try! Container()
//                try! container.write{
//                    transaction in
//                    let temp = transaction.get(DataBoughtTicketObject.self)
//                    temp.forEach {
//                        i in
//                        self.boughtTicket.append(i)
//                    }
//                }
//                self.eventHandler?(.dataLoaded)
//            }
//        }
//
//
//    }
    
//    func fetchMyTicket() {
//        let container = try! Container()
//        try! container.write {
//            transaction in
//            let check = transaction.objectExist(DataMyTicketObject.self)
//            if check {
//                self.eventHandler?(.loading)
//                APIManager.shared.request(modelType: ReponseMyTicket.self, type: EntityEndPoint.myTicket(page: page, perPage: perPage), params: nil, completion: {
//                    result in
//                    self.eventHandler?(.stopLoading)
//
//                    switch result {
//                    case .success(let ticket):
//                        print(ticket)
//                        let container = try! Container()
//                        try! container.write { transaction in
//                            ticket.data?.forEach{
//                                i in
//                                transaction.add(i, update: true)
//                                self.myTicket.append(i.managedObject())
//                            }
//
//                        }
//                        self.eventHandler?(.dataLoaded)
//
//                    case .failure(let error):
//                        if case DataError.invalidResponse400(let reason) = error {
//                            self.eventHandler?(.error(reason))
//                        }
//                        else {
//                            self.eventHandler?(.error(error.localizedDescription))
//                        }
//
//                    }
//                })
//            } else {
//                self.myTicket = [DataMyTicketObject]()
//                let container = try! Container()
//                try! container.write{
//                    transaction in
//                    let temp = transaction.get(DataMyTicketObject.self)
//                    temp.forEach {
//                        i in
//                        self.myTicket.append(i)
//                    }
//                }
//                self.eventHandler?(.dataLoaded)
//            }
//        }
//
//
//    }
}


extension TicketViewModel {

    enum Event {
        case loading
        case stopLoading
        case dataLoaded
        case error(String?)
        case logout
//        case newProductAdded(product: AddProduct)
    }

}


// My_ticket
extension TicketViewModel {
    

    func getNextMyTicketFromServer(completion: @escaping (() -> ())) {
        
        if self.currentPageMyTicket <= self.numberPageMyTicket {
            APIManager.shared.request(modelType: ReponseMyTicket.self, type: EntityEndPoint.myTicket(page: Int(currentPageMyTicket), perPage: perPage), params: nil, completion: {
                result in

                switch result {
                case .success(let ticket):
//                    Contanst.userdefault.set(ticket.total, forKey: "myTicketTotal")
                    self.numberPageMyTicket = round(Double(ticket.total!) / Double(self.perPage))
                    let container = try! Container()
                    try! container.write { transaction in
                        ticket.data?.forEach{
                            i in
                            transaction.add(i, update: true)
                            self.myTicket.append(i.managedObject())
                        }

                    }
                    self.currentPageMyTicket+=1
                    completion()
                case .failure(let error):
                    if case DataError.invalidResponse400(let reason) = error {
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
    
    func getMyTicketFromServer() {
        self.currentPageMyTicket = 1
        self.eventHandler?(.loading)
        APIManager.shared.request(modelType: ReponseMyTicket.self, type: EntityEndPoint.myTicket(page: Int(currentPageMyTicket), perPage: perPage), params: nil, completion: {
            result in
            self.eventHandler?(.stopLoading)

            switch result {
            case .success(let ticket):
//                Contanst.userdefault.set(ticket.total, forKey: "myTicketTotal")
                self.numberPageMyTicket = round(Double(ticket.total!) / Double(self.perPage))
                self.myTicket = [DataMyTicketObject]()
                let container = try! Container()
                try! container.write { transaction in
                    ticket.data?.forEach{
                        i in
                        transaction.add(i, update: true)
                        self.myTicket.append(i.managedObject())
                    }

                }
                self.currentPageMyTicket+=1

                self.eventHandler?(.dataLoaded)

            case .failure(let error):
                if case DataError.invalidResponse400(let reason) = error {
                    self.eventHandler?(.error(reason))
                }
                else {
                    self.eventHandler?(.error(error.localizedDescription))
                }

            }
        })
    }
    
    func getMyTicketDataLocalDB() {
        self.myTicket = [DataMyTicketObject]()
        let container = try! Container()
        try! container.write{
            transaction in
            let temp = transaction.get(DataMyTicketObject.self)
            temp.forEach {
                i in
                self.myTicket.append(i)
            }
        }
        self.eventHandler?(.dataLoaded)
    }
    
    func fetchMyTicket() {

        //declare this property where it won't go out of scope relative to your listener
        let reachability = try! Reachability()
        
        switch try! Reachability().connection {
          case .wifi:
              print("Reachable via WiFi")
            getMyTicketFromServer()
          case .cellular:
              print("Reachable via Cellular")
            getMyTicketFromServer()
          case .none:
              print("Network not reachable")
              getMyTicketDataLocalDB()
          case .unavailable:
              print("Network not reachable")
              getMyTicketDataLocalDB()
        }
    }
}

extension TicketViewModel {
    func getNextBoughtTicketFromServer(completion: @escaping (() -> ())) {
        
        if self.currentPageBoughtTicket <= self.numberPageBoughtTicket {
            APIManager.shared.request(modelType: ReponseBoughtTicket.self, type: EntityEndPoint.boughtTicket(page: Int(currentPageBoughtTicket), perPage: perPage), params: nil, completion: {
                result in

                switch result {
                case .success(let ticket):
//                    Contanst.userdefault.set(ticket.total, forKey: "myTicketTotal")
                    self.numberPageBoughtTicket = round(Double(ticket.total!) / Double(self.perPage))
                    let container = try! Container()
                    try! container.write { transaction in
                        ticket.data?.forEach{
                            i in
                            transaction.add(i, update: true)
                            self.boughtTicket.append(i.managedObject())
                        }

                    }
                    self.currentPageBoughtTicket+=1
                    completion()
                case .failure(let error):
                    if case DataError.invalidResponse400(let reason) = error {
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
    
    func getBoughtTicketFromServer() {
        self.currentPageBoughtTicket = 1
        self.eventHandler?(.loading)
        APIManager.shared.request(modelType: ReponseBoughtTicket.self, type: EntityEndPoint.boughtTicket(page: Int(currentPageBoughtTicket), perPage: perPage), params: nil, completion: {
            result in
            self.eventHandler?(.stopLoading)

            switch result {
            case .success(let ticket):
//                Contanst.userdefault.set(ticket.total, forKey: "myTicketTotal")
                self.numberPageBoughtTicket = round(Double(ticket.total!) / Double(self.perPage))
                self.boughtTicket = [DataBoughtTicketObject]()
                let container = try! Container()
                try! container.write { transaction in
                    ticket.data?.forEach{
                        i in
                        transaction.add(i, update: true)
                        self.boughtTicket.append(i.managedObject())
                    }

                }
                self.currentPageBoughtTicket+=1

                self.eventHandler?(.dataLoaded)

            case .failure(let error):
                if case DataError.invalidResponse400(let reason) = error {
                    self.eventHandler?(.error(reason))
                }
                else {
                    self.eventHandler?(.error(error.localizedDescription))
                }

            }
        })
    }
    
    func getBoughtTicketDataLocalDB() {
        self.boughtTicket = [DataBoughtTicketObject]()
        let container = try! Container()
        try! container.write{
            transaction in
            let temp = transaction.get(DataBoughtTicketObject.self)
            temp.forEach {
                i in
                self.boughtTicket.append(i)
            }
        }
        self.eventHandler?(.dataLoaded)
    }
    
    func fetchBoughtTicket() {

        //declare this property where it won't go out of scope relative to your listener
        let reachability = try! Reachability()
        
        switch try! Reachability().connection {
          case .wifi:
              print("Reachable via WiFi")
            getBoughtTicketFromServer()
          case .cellular:
              print("Reachable via Cellular")
            getBoughtTicketFromServer()
          case .none:
              print("Network not reachable")
              getBoughtTicketDataLocalDB()
          case .unavailable:
              print("Network not reachable")
            getBoughtTicketDataLocalDB()
        }
    }
}
