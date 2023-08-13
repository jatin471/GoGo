//
//  LocationInputView.swift
//  GoGo
//
//  Created by JATIN YADAV on 03/08/23.
//

import UIKit

protocol LocationInputViewDelegate : AnyObject {
    func dismissLocationInputView()
    func executeSearch(query:String)
}

class LocationInputView: UIView {
    
    //MARK: - PROPERTIES
    
    var user : User? {
        didSet { titleLabel.text = user?.fullname }
    }
    
    weak var delegate : LocationInputViewDelegate?
    
    private let backButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
        button.addTarget(self, action: #selector(handleBackTapped), for: .touchUpInside)
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 26)
        label.textColor = .darkGray
        return label
    }()
    
    private let startLocationIndicatorView : UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    private let linkingView : UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    private let destinationIndicatorView : UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    private lazy var startingLocationTextField : UITextField = {
       let tf = UITextField()
        tf.placeholder = "Current Location"
        tf.backgroundColor = .groupTableViewBackground
//        tf.isEnabled = false
        tf.autocapitalizationType = .none
        tf.layer.cornerRadius = 14
        
        let paddingView = UIView()
        paddingView.setDimensions(width: 8, height: 30)
        tf.leftView = paddingView
        tf.leftViewMode = .always
        
        return tf
    }()
    
    private lazy var destinationLocationTextField : UITextField = {
       let tf = UITextField()
        tf.placeholder = "Enter a destination"
        tf.backgroundColor = .lightGray
//        tf.isEnabled = false
        tf.autocapitalizationType = .none
        tf.returnKeyType = .search
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.layer.cornerRadius = 14
        
        let paddingView = UIView()
        paddingView.setDimensions(width: 8, height: 30)
        tf.leftView = paddingView
        tf.leftViewMode = .always
        tf.delegate = self
        
        return tf
    }()
    
    //MARK: - LIFECYCLE
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addShadow()
        
        backgroundColor = .white
        
        addSubview(backButton)
        backButton.anchor(top: topAnchor , left: leftAnchor , paddingTop: 44 , paddingLeft: 12 , width: 24 , height: 25)
        
        addSubview(titleLabel)
        titleLabel.centerY(inView: backButton)
        titleLabel.centerX(inView: self)
        
        addSubview(startingLocationTextField)
        startingLocationTextField.anchor(top: backButton.bottomAnchor , left: leftAnchor , right: rightAnchor ,
                                         paddingTop: 8 , paddingLeft: 40 , paddingRight: 40 , height: 30)
        
        addSubview(destinationLocationTextField)
        destinationLocationTextField.anchor(top: startingLocationTextField.bottomAnchor , left: leftAnchor ,
                                            right: rightAnchor , paddingTop: 12 , paddingLeft: 40 ,
                                            paddingRight: 40 , height: 30)
        
        addSubview(startLocationIndicatorView)
        startLocationIndicatorView.centerY(inView: startingLocationTextField , leftAnchor: leftAnchor ,
                                           paddingLeft: 20)
        startLocationIndicatorView.setDimensions(width: 6, height: 6)
        startLocationIndicatorView.layer.cornerRadius = 6 / 2
        
        addSubview(destinationIndicatorView)
        destinationIndicatorView.centerY(inView: destinationLocationTextField , leftAnchor: leftAnchor ,
                                           paddingLeft: 20)
        destinationIndicatorView.setDimensions(width: 6, height: 6)
        
        addSubview(linkingView)
        linkingView.centerX(inView: startLocationIndicatorView)
        linkingView.anchor(top: startLocationIndicatorView.bottomAnchor , bottom: destinationIndicatorView.topAnchor , paddingTop: 4 ,paddingBottom: 4 , width: 1)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - HELPERS
    
    @objc func handleBackTapped() {
        delegate?.dismissLocationInputView()
    }
}

//MARK: - UITextFieldDelegate
extension LocationInputView : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let query = textField.text else {return false}
        delegate?.executeSearch(query: query)
        return  true
    }
}
