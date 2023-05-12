
import UIKit
import Kingfisher

class EventTableViewCell: UITableViewCell, ReusableView, NibLoadableView {

    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var startAt: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var imgView: UIView!
    @IBOutlet weak var mainView: UIView!

    func configure(app: DataReponseSearch) {
        imgView.layer.cornerRadius = 20
        imgView.layer.borderColor = UIColor(red: 94/255, green: 135/255, blue: 240/255, alpha: 1).cgColor
        imgView.layer.borderWidth = 0.5

        mainView.layer.cornerRadius = 20
        mainView.layer.masksToBounds = true
        title.text = app.title
        startAt.text = app.startAt
        location.text = app.locationId
        img.kf.setImage(with: URL(string: app.image!))
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func cancel() {
    }
}
