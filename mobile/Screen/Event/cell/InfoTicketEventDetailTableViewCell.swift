//
//  InfoTicketEventDetailTableViewCell.swift
//  mobile
//
//  Created by NguyenSon_MP on 16/05/2023.
//

import UIKit

class InfoTicketEventDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tb: UITableView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mainView.layer.masksToBounds = true
        mainView.layer.cornerRadius = 10
        self.tb.delegate = self
        self.tb.dataSource = self
        self.tb.register(UINib(nibName: "EventSessionTableViewCell", bundle: nil), forCellReuseIdentifier: "EventSessionTableViewCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension InfoTicketEventDetailTableViewCell:  UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "EventSessionTableViewCell", for: indexPath) as? EventSessionTableViewCell
        {
            return cell
        }
        return UITableViewCell()
    }

}
