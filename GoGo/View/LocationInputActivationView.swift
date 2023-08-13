//
//  LocationInputActivationView.swift
//  GoGo
//
//  Created by JATIN YADAV on 03/08/23.
//

import UIKit

protocol LocationInputActivationViewDelegate : AnyObject {
    func presentLocationInputView()
}

class LocationInputActivationView : UIView {
    //MARK: - PROPERTIES
    
    weak var delegate : LocationInputActivationViewDelegate?
    
    private let indicatiorView : UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    private let placeholderLabel :UILabel = {
        let label = UILabel()
        label.text = "Where you want to go?"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .darkGray
        return label
    }()
    
    //MARK: - LIFECYCLE
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        backgroundColor = .white
        addShadow()
        
        addSubview(indicatiorView)
        indicatiorView.centerY(inView: self , leftAnchor: leftAnchor , paddingLeft: 16)
        indicatiorView.setDimensions(width: 6, height: 6)
        
        addSubview(placeholderLabel)
        placeholderLabel.centerY(inView: self , leftAnchor: indicatiorView.rightAnchor , paddingLeft: 20 )
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(presentLocationInputView))
        addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func presentLocationInputView() {
        delegate?.presentLocationInputView()
    }
}

