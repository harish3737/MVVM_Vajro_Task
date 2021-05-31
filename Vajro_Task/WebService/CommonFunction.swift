//
//  CommonFunction.swift
//  Vajro_Task
//
//  Created by Sethuram Vijayakumar on 26/05/21.
//

import Foundation
import UIKit

func VerifyURL(_ urlString :String?) -> Bool{
    if let urlstring  = urlString{
        if let url = URL(string: urlstring){
            return UIApplication.shared.canOpenURL(url)
        }
    }
    return false
}


func showToast(msg : String ) {
    let window = UIApplication.shared.windows.first!
    let toastLabel = PaddingLabel()
    
    toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.8)
    toastLabel.textColor = UIColor.white
    toastLabel.translatesAutoresizingMaskIntoConstraints = false
    toastLabel.textAlignment = .center;
    toastLabel.font = UIFont.systemFont(ofSize: 12)
    toastLabel.text = msg
    
    toastLabel.alpha = 1.0
    toastLabel.numberOfLines = 0
    toastLabel.lineBreakMode = .byWordWrapping
    toastLabel.layer.cornerRadius = 10;
    toastLabel.clipsToBounds  =  true
    toastLabel.removeFromSuperview()
    window.addSubview(toastLabel)
    toastLabel.bringSubviewToFront(window)
    NSLayoutConstraint.activate([
        toastLabel.leadingAnchor.constraint(greaterThanOrEqualTo: window.leadingAnchor, constant: 20),
        toastLabel.trailingAnchor.constraint(lessThanOrEqualTo: window.trailingAnchor,constant: -20),
        toastLabel.bottomAnchor.constraint(greaterThanOrEqualTo: window.bottomAnchor, constant:  -15),
        toastLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 30),
        toastLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 150),
        toastLabel.centerXAnchor.constraint(equalTo: window.centerXAnchor)
        
    ])
    UIView.animate(withDuration: 4.0, delay: 0.0, options: .curveEaseOut, animations: {
        toastLabel.alpha = 0.0
    }, completion: {(isCompleted) in
        toastLabel.removeFromSuperview()
    })
}



//MARK:- ShowLoader

internal func createActivityIndicator(_ uiView : UIView)->UIView{
    
    let container: UIView = UIView(frame: CGRect.zero)
    container.layer.frame.size = uiView.frame.size
    container.center = CGPoint(x: uiView.bounds.width/2, y: uiView.bounds.height/2)
    container.backgroundColor = UIColor(white: 0.2, alpha: 0.3)
    
    let loadingView: UIView = UIView()
    loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
    loadingView.center = container.center
    loadingView.backgroundColor = UIColor(white:0.1, alpha: 0.7)
    loadingView.clipsToBounds = true
    loadingView.layer.cornerRadius = 10
    loadingView.layer.shadowRadius = 5
    loadingView.layer.shadowOffset = CGSize(width: 0, height: 4)
    loadingView.layer.opacity = 2
    loadingView.layer.masksToBounds = false
    loadingView.layer.shadowColor = UIColor.gray.cgColor
    
    let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    actInd.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
    actInd.clipsToBounds = true
    actInd.style = .large
    
    actInd.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
    loadingView.addSubview(actInd)
    container.addSubview(loadingView)
    container.isHidden = true
    uiView.addSubview(container)
    actInd.startAnimating()
    
    return container
    
}


public func convertToDictionary<T : Codable>(model : T) -> [String: Any]? {
    
    let jsonData = try! JSONEncoder().encode(model)
    let jsonString = String(data: jsonData, encoding: .utf8)!
    
    if let data = jsonString.data(using: .utf8) {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] ?? ["" : ""]
        } catch {
            print(error.localizedDescription)
        }
    }
    return ["" : ""]
}

import UIKit
extension UILabel{
    var getText: String{
        return self.text ?? ""
    }
}

class PaddingLabel: UILabel {
    
    @IBInspectable var topInset: CGFloat = 5.0
    @IBInspectable var bottomInset: CGFloat = 5.0
    @IBInspectable var leftInset: CGFloat = 5.0
    @IBInspectable var rightInset: CGFloat = 5.0
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += topInset + bottomInset
            contentSize.width += leftInset + rightInset
            return contentSize
        }
    }
}


enum YesNo{
    case yes
    case no
}
