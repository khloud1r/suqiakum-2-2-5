 
import UIKit
import Kingfisher
extension UIImageView {
    func setImage(imageUrl: String){
        self.kf.indicatorType = .activity
        self.kf.setImage(with: URL(string:imageUrl), placeholder: nil, options: [.transition(.fade(0.7))],   completionHandler: nil)
    }
}
