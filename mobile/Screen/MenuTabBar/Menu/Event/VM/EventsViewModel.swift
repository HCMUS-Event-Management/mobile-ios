//
//  EventsViewModel.swift
//  mobile
//
//  Created by NguyenSon_MP on 17/05/2023.
//

import Foundation

class EventsViewModel {
    var eventHandler: ((_ event: Event) -> Void)? // Data Binding Closure
    var catagorys = [CategoryObject]()
    var events = [DataEventObject]()
    func getCategoryAllFromServer() {
        self.eventHandler?(.loading)

        APIManager.shared.request(modelType: ReponseGetAllCategory.self, type: EntityEndPoint.getAllCategory, params: nil, completion: {
            result in
            self.eventHandler?(.stopLoading)

            switch result {
            case .success(let value):
                let container = try! Container()
                try! container.write { transaction in
                    value.data?.forEach{
                        i in
                        transaction.add(i, update: true)
                        self.catagorys.append(i.managedObject())
                    }
                }
                self.eventHandler?(.categoryLoaded)
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func getListEventOfUserFromServer(fullTextSearch: String) {
        self.eventHandler?(.loading)

        APIManager.shared.request(modelType: ReponseListEvent.self, type: EntityEndPoint.listEventOfUser(page: 1, perPage: 10, filterStatus: "APPROVED", sort: "", fullTextSearch: fullTextSearch, type: ""), params: nil, completion: {
            result in
            self.eventHandler?(.stopLoading)

            switch result {
            case .success(let value):
                self.events = [DataEventObject]()
                let container = try! Container()
                try! container.write { transaction in
                    value.data?.forEach{
                        i in
                        transaction.add(i, update: true)
                        self.events.append(i.managedObject())
                    }
                }
                self.eventHandler?(.dataLoaded)
            case .failure(let error):
                print(error)
            }
        })
    }
    
}

extension EventsViewModel {

    enum Event {
        case loading
        case stopLoading
        case categoryLoaded
        case dataLoaded
        case error(String?)
    }

}
