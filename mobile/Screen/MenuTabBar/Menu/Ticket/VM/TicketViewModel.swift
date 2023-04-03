//
//  TicketViewModel.swift
//  mobile
//
//  Created by NguyenSon_MP on 02/04/2023.
//

import Foundation


class TicketViewModel {
    
    var page = "1"
    var perPage = "10"
    var eventHandler: ((_ event: Event) -> Void)? // Data Binding Closure

    func fetchMyTicket() {
        self.eventHandler?(.loading)
        APIManager.shared.request(modelType: ReponseMyTicket.self, type: EntityEndPoint.myTicket(page: page, perPage: perPage), params: nil, completion: {
            result in
            self.eventHandler?(.stopLoading)

            switch result {
            case .success(let ticket):
                let container = try! Container()
                try! container.write { transaction in
                    ticket.data?.forEach{
                        i in
//                        transaction.add(i.session!, update: true)
                        transaction.add(i, update: true)
                    }
                }
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
