 
import UIKit
extension UITextField{
    
    func addTxtFieldShadowWith(color: UIColor, radius: CGFloat, opacity: Float?) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity ?? 0.7
    }
    
    func addTxtFieldNormalShadow(){
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.2
        
    }
    
    func addTxtFieldCornerRadius(_ radius: CGFloat = 0) {
        if radius == 0 {
            self.layer.cornerRadius = self.frame.size.height / 2
        } else {
            self.layer.cornerRadius = radius
        }
    }
    
    func addTxtFieldBorderWith(width: CGFloat, color: UIColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
    func roundedTxtFieldFromSide(corners: UIRectCorner, cornerRadius: Double) {
        
        let size = CGSize(width: cornerRadius, height: cornerRadius)
        let bezierPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: size)
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = self.bounds
        shapeLayer.path = bezierPath.cgPath
        self.layer.mask = shapeLayer
    }
    
    func roundedTxtField(borderWidth: CGFloat, cornerRadius: CGFloat, borderColor: UIColor) {
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        self.layer.borderColor = borderColor.cgColor
    }
    
}
