//
//  TicketViewModel.swift
//  mobile
//
//  Created by NguyenSon_MP on 02/04/2023.
//

import Foundation
import Reachability

class TicketViewModel {
    
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

    
    
    func getDetailTicketFromServer(_ ticketCode: String) {
        self.eventHandler?(.loading)
        APIManager.shared.request(modelType: ReponseDetailTicket.self, type: EntityEndPoint.ticketDetail(ticketCode: ticketCode), params: nil, completion: { result in

            switch result {
                case .success(let detail):
                    self.eventHandler?(.stopLoading)
                    self.detail = (detail.data?.managedObject())!
                    self.eventHandler?(.dataLoaded)
                    
                case .failure(let error):
                    if case DataError.invalidResponse(let reason) = error {
                        self.eventHandler?(.error(reason))
                    }
                    else {
                        self.eventHandler?(.error(error.localizedDescription))
                    }
            }})
    }
    
    func getDetailTicketFromDB(_ ticketCode: String) {
        let container = try! Container()

        try! container.write{
            transaction in
            let items = transaction.get(DataMyTicketObject.self)
            for item in items.filter("ticketCode == '\(ticketCode)'") {
                self.detail = item
            }
        }
        self.eventHandler?(.stopLoading)
        self.eventHandler?(.dataLoaded)

    }
    
    func fetchDetailTicket(_ ticketCode: String) {
        
        //declare this property where it won't go out of scope relative to your listener
        let reachability = try! Reachability()
        
        switch try! Reachability().connection {
          case .wifi:
            getDetailTicketFromServer(ticketCode)
          case .cellular:
            getDetailTicketFromServer(ticketCode)
          case .none:
              getDetailTicketFromDB(ticketCode)
          case .unavailable:
            getDetailTicketFromDB(ticketCode)
        }

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
                    self.numberPageMyTicket = (Double(ticket.total!) / Double(self.perPage)).rounded(.up)
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
    
    func getMyTicketFromServer() {
        self.myTicket = [DataMyTicketObject]()
        self.currentPageMyTicket = 1
        self.eventHandler?(.loading)
        APIManager.shared.request(modelType: ReponseMyTicket.self, type: EntityEndPoint.myTicket(page: Int(currentPageMyTicket), perPage: perPage), params: nil, completion: {
            result in
            self.eventHandler?(.stopLoading)

            switch result {
            case .success(let ticket):
                self.numberPageMyTicket = (Double(ticket.total!) / Double(self.perPage)).rounded(.up)
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
                if case DataError.invalidResponse(let reason) = error {
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

        let reachability = try! Reachability()
        
        switch try! Reachability().connection {
          case .wifi:
            getMyTicketFromServer()
          case .cellular:
            getMyTicketFromServer()
          case .none:
              getMyTicketDataLocalDB()
          case .unavailable:
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
                    self.numberPageBoughtTicket = (Double(ticket.total!) / Double(self.perPage)).rounded(.up)
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
    
    func getBoughtTicketFromServer() {
        self.boughtTicket = [DataBoughtTicketObject]()
        self.currentPageBoughtTicket = 1
        self.eventHandler?(.loading)
        APIManager.shared.request(modelType: ReponseBoughtTicket.self, type: EntityEndPoint.boughtTicket(page: Int(currentPageBoughtTicket), perPage: perPage), params: nil, completion: {
            result in
            self.eventHandler?(.stopLoading)

            switch result {
            case .success(let ticket):
                self.numberPageBoughtTicket = (Double(ticket.total!) / Double(self.perPage)).rounded(.up)
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
                if case DataError.invalidResponse(let reason) = error {
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

        let reachability = try! Reachability()
        
        switch try! Reachability().connection {
          case .wifi:
            getBoughtTicketFromServer()
          case .cellular:
            getBoughtTicketFromServer()
          case .none:
              getBoughtTicketDataLocalDB()
          case .unavailable:
            getBoughtTicketDataLocalDB()
        }
    }
}

extension TicketViewModel {
    func vadilateTicket(from info: VadilateTicketDto) {
        self.eventHandler?(.loading)
        let parameter = try? APIManager.shared.encodeBody(value: info)
        APIManager.shared.request(modelType: ReponseValidateTicket.self, type: EntityEndPoint.vadilateOnl, params: parameter, completion: {
            result in
            self.eventHandler?(.stopLoading)
            switch result {
            case .success(let value):
                self.eventHandler?(.vadilateTicket)
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
    
    func checkVadilateTicket(from info: VadilateTicketDto) {
        switch try! Reachability().connection {
          case .wifi:
            vadilateTicket(from: info)
          case .cellular:
            vadilateTicket(from: info)
          case .none:
            self.eventHandler?(.error("Mất kết nối mạng"))
          case .unavailable:
            self.eventHandler?(.error("Mất kết nối mạng"))
        }
    }
}

extension TicketViewModel {
    
    func donateTicket(from info: DonateTicketDto) {
        self.eventHandler?(.loading)
        let parameter = try? APIManager.shared.encodeBody(value: info)
        APIManager.shared.request(modelType: ReponseCommon.self, type: EntityEndPoint.donate, params: parameter, completion: {
            result in
            self.eventHandler?(.stopLoading)
            switch result {
            case .success(let value):
                self.eventHandler?(.donateSuccess)
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
    
    func checkDonateTicket(from info: DonateTicketDto) {
        switch try! Reachability().connection {
          case .wifi:
            donateTicket(from: info)
          case .cellular:
            donateTicket(from: info)
          case .none:
            self.eventHandler?(.error("Mất kết nối mạng"))
          case .unavailable:
            self.eventHandler?(.error("Mất kết nối mạng"))
        }
    }
    
}


extension TicketViewModel {

    enum Event {
        case loading
        case stopLoading
        case dataLoaded
        case error(String?)
        case logout
        case vadilateTicket
        case donateSuccess
//        case newProductAdded(product: AddProduct)
    }

}
