//
//  Extensions.swift
//  GoGo
//
//  Created by JATIN YADAV on 01/08/23.
//

import UIKit
import MapKit

extension UIView {
    
    func inputContainerView(image:UIImage , textField : UITextField? = nil , segmentedControl : UISegmentedControl? = nil) -> UIView {
        let view = UIView()
        
        let imageView = UIImageView()
        imageView.image = image
        imageView.alpha = 0.85
        view.addSubview(imageView)
        imageView.tintColor = .systemBackground
        
        
        if let textField = textField {
            imageView.centerY(inView: view)
            imageView.anchor(left: view.leftAnchor , paddingLeft: 8 , width: 24 , height: 24)
            
            
            view.addSubview(textField)
            textField.centerY(inView: view)
            textField.anchor(left: imageView.rightAnchor , bottom: view.bottomAnchor , right: view.rightAnchor , paddingLeft: 8 ,                paddingBottom: 8)
        }
        
        if let sc = segmentedControl {
            imageView.anchor(top: view.topAnchor , left: view.leftAnchor , paddingTop: -8 , paddingLeft: 8 ,width: 24 , height: 24)
            
            view.addSubview(sc)
            sc.anchor(left: view.leftAnchor , right: view.rightAnchor , paddingLeft: 8 , paddingRight: 8)
            sc.centerY(inView: view , constant: 8)
        }
        
    
        let separatorView = UIView()
        separatorView.backgroundColor = .lightGray
        view.addSubview(separatorView)
        separatorView.anchor(left: view.leftAnchor , bottom: view.bottomAnchor , right: view.rightAnchor , paddingLeft: 8 , height: 0.75)
        
        return view
    }
    
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                paddingLeft: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                paddingRight: CGFloat = 0,
                width: CGFloat? = nil,
                height: CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func center(inView view: UIView, yConstant: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: yConstant!).isActive = true
    }
    
    func centerX(inView view: UIView, topAnchor: NSLayoutYAxisAnchor? = nil, paddingTop: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        if let topAnchor = topAnchor {
            self.topAnchor.constraint(equalTo: topAnchor, constant: paddingTop!).isActive = true
        }
    }
    
    func centerY(inView view: UIView, leftAnchor: NSLayoutXAxisAnchor? = nil, paddingLeft: CGFloat? = nil, constant: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant!).isActive = true
        
        if let leftAnchor = leftAnchor, let padding = paddingLeft {
            self.leftAnchor.constraint(equalTo: leftAnchor, constant: padding).isActive = true
        }
    }
    
    func setDimensions(width: CGFloat, height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    func addConstraintsToFillView(_ view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        anchor(top: view.topAnchor, left: view.leftAnchor,
               bottom: view.bottomAnchor, right: view.rightAnchor)
    }
    
    func addShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.55
        layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        layer.masksToBounds = false
    }
}

// MARK: - UIColor

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static let backgroundColor = UIColor.rgb(red: 25, green: 25, blue: 25)
    static let mainBlueTint = UIColor.rgb(red: 17, green: 154, blue: 237)
}

extension UITextField {
    func textField(withPlaceholder placeholder:String , isSecureTextEntry: Bool) -> UITextField{
        let tf = UITextField()
        tf.borderStyle = .none
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.textColor = .white
        tf.keyboardAppearance = .dark
        tf.isSecureTextEntry = isSecureTextEntry
        tf.autocapitalizationType = .none
        tf.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        return tf
    }
}

extension MKPlacemark {
    var address :String? {
        get {
            guard let subThroughfare = subThoroughfare else {return nil}
            guard let thoroughfare = thoroughfare else {return nil}
            guard let locality = locality else {return nil}
            guard let adminArea = administrativeArea else {return nil}
            
            return "\(subThroughfare) , \(thoroughfare) , \(locality) , \(adminArea)"
        }
    }
}


extension MKMapView {
    func zoomToFit(annotations : [MKAnnotation]){
        var zoomRect = MKMapRect.null
        
        annotations.forEach { annotation in
            let annotationPoint = MKMapPoint(annotation.coordinate)
            let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0.01, height: 0.01)
            zoomRect = zoomRect.union(pointRect)
        }
        
        let insets = UIEdgeInsets(top: 100, left: 100, bottom: 250, right: 100)
        setVisibleMapRect(zoomRect,edgePadding: insets , animated: true)
    }
}

extension UIViewController {
    func shouldPresentLoadingView(_ present : Bool , message : String? = nil){
        if present {

            let loadingView = UIView()
            loadingView.frame = self.view.frame
            loadingView.backgroundColor = .black
            loadingView.alpha = 0
            loadingView.tag = 1
            
            let indicator = UIActivityIndicatorView()
            indicator.style = .whiteLarge
            indicator.center = view.center
            
            let label = UILabel()
            label.text = message
            label.font = UIFont.systemFont(ofSize: 24)
            label.textColor = .white
            label.textAlignment = .center
            label.alpha = 0.87
            
            view.addSubview(loadingView)
            view.addSubview(indicator)
            view.addSubview(label)
            
            label.centerX(inView: view)
            
            label.anchor(top: indicator.bottomAnchor, paddingTop: 32)
            
            indicator.startAnimating()
            
            UIView.animate(withDuration: 0.3) {
                loadingView.alpha = 0.7
            }
        } else{
            view.subviews.forEach { subView in
                if subView.tag == 1{
                    UIView.animate(withDuration: 0.3) {
                        subView.alpha = 0
                    } completion: { _ in
                        subView.removeFromSuperview()
                    }
                }
            }
        }
    }
}
