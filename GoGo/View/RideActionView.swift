//
//  RideActionView.swift
//  GoGo
//
//  Created by JATIN YADAV on 07/08/23.
//

import UIKit
import MapKit

protocol RideActionViewDelegate : AnyObject {
    func uploadTrip(_ view:RideActionView)
}

enum RideActionViewConfiguration {
    case requestRide
    case tripAccepted
    case pickupPassenger
    case tripInProgress
    case endTrip
    
    init() {
        self = .requestRide
    }
}

enum ButtonAction : CustomStringConvertible{
    
    case requestRide
    case cancel
    case getDirections
    case pickup
    case dropOff
    
    var description: String{
        switch self {
        case .requestRide: return "CONFIRM GOGO"
        case .cancel: return "CANCEL RIDE"
        case .getDirections: return "GET DIRECTIONS"
        case .pickup: return "PICKUP PASSENGER"
        case .dropOff: return "DROP OFF PASSENGER"
        }
    }
    
    init(){
        self = .requestRide
    }
}

class RideActionView: UIView {
    
    //MARK: - Properties
    var destination : MKPlacemark? {
        didSet{
            titleLabel.text = destination?.name
            addressLabel.text = destination?.address
        }
    }
    
    var config = RideActionViewConfiguration()
    var buttonAction = ButtonAction()
    
    weak var delegate : RideActionViewDelegate?
    
    let titleLabel : UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "Test Address Field"
        label.textAlignment = .center
        return label
    }()
    
    let addressLabel : UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "123 M St , NW Washington DC"
        label.numberOfLines = 2 //Extra
        label.textAlignment = .center
        return label
    }()
    
    private let infoView : UIView = {
        let view = UIView()
        view.backgroundColor = .black
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30)
        label.textColor = .white
        label.text = "X"
        
        view.addSubview(label)
        label.centerX(inView: view)
        label.centerY(inView: view)
        
        return view
    }()
    
    private let gogoLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "GoGo"
        label.textAlignment = .center
        return label
    }()
    
    
    private let actionButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .black
        button.setTitle("Confirm GoGo", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(actionButtonPressed), for: .touchUpInside)
        return button
    }()
    
    
    
    override init(frame:CGRect){
        super.init(frame: frame)
        backgroundColor = .white
        addShadow()
        
        let stack = UIStackView(arrangedSubviews: [titleLabel , addressLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.distribution = .fillEqually
        
        addSubview(stack)
        stack.centerX(inView: self)
        stack.anchor(top: topAnchor , paddingTop: 12)
        
        addSubview(infoView)
        infoView.centerX(inView: self)
        infoView.anchor(top:stack.bottomAnchor , paddingTop: 16)
        infoView.setDimensions(width: 60, height: 60)
        infoView.layer.cornerRadius = 60 / 2
        
        
        addSubview(gogoLabel)
        gogoLabel.anchor(top:infoView.bottomAnchor , paddingTop: 8)
        gogoLabel.centerX(inView: self)
        
        let separatorView = UIView()
        separatorView.backgroundColor = .lightGray
        addSubview(separatorView)
        separatorView.anchor(top : gogoLabel.bottomAnchor , left: leftAnchor , right: rightAnchor
                             , paddingTop: 4 , height: 0.75)
        
        
        addSubview(actionButton)
        actionButton.anchor(left: leftAnchor , bottom: safeAreaLayoutGuide.bottomAnchor , right:
                                rightAnchor ,paddingLeft: 12 , paddingBottom: 12 , paddingRight: 12 ,
                            height: 50)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    @objc func actionButtonPressed() {
        delegate?.uploadTrip(self)
    }
    
    
    //MARK: - Helper Functions
    
    func configureUI(withConfig config : RideActionViewConfiguration){
        switch config {
        case .requestRide:
            break
        case .tripAccepted:
            titleLabel.text = "Take The Passenger"
            buttonAction = .getDirections
            actionButton.setTitle(buttonAction.description, for: .normal)
        case .pickupPassenger:
            break
        case .tripInProgress:
            break
        case .endTrip:
            break
        }
    }
}
