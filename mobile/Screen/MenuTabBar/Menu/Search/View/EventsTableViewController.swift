//
//  AppsTableViewController.swift
//  AppStoreSearch
//
//  Created by Marcos Griselli on 14/07/2018.
//  Copyright © 2018 Marcos Griselli. All rights reserved.
//

import UIKit
import Kingfisher

class EventsTableViewController: UITableViewController {
    var apps = [DataReponseSearch]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(EventTableViewCell.self)
        tableView.register(EmptyTableViewCell.self)

        tableView.separatorStyle = .none
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Found \(apps.count) results"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if apps.count == 0 {
            return 1
        } else {
            return apps.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if apps.count == 0 {
            let cell: EmptyTableViewCell =
                tableView.dequeueReusableCell(forIndexPath: indexPath)
            return cell
        } else {
            let cell: EventTableViewCell =
                tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))

            cell.configure(app: apps[indexPath.row])
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? EventTableViewCell else { return }
        cell.cancel()
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if apps.count == 0 {
            return tableView.layer.frame.height
        } else {
            return tableView.layer.frame.height / 5
        }
    }
    
    /// For the purpose of a simple blog post this is network call
    /// is placed on the view controller.
    ///
    /// - Parameter term: Term to search.
    func search(term: String) {
        let encodedTerm = term //.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        APIManager.shared.request(modelType: ReponseSearch.self, type: EntityEndPoint.search(query: encodedTerm  ?? String()), params: nil, completion: { result in
            switch result {
            case .success(let data):
                self.handle(response: data)
            case .failure(let error):
                print(error)
            }

        })
        
        
        
    }
    
    //vm
    
    /// Handles the networking response with the searched apps.
    ///
    /// - Parameter response: ReponseSearch retrieved from the network.
    private func handle(response: ReponseSearch) {
        apps = response.data ?? [DataReponseSearch]()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
