//
//  PickupController.swift
//  GoGo
//
//  Created by JATIN YADAV on 09/08/23.
//
import UIKit
import MapKit

protocol PickupControllerDelegate : AnyObject {
    func didAcceptTrip(_ trip : Trip)
}

class PickupController : UIViewController {
    
    //MARK: - Properties
    weak var delegate : PickupControllerDelegate?
    
    private let mapView = MKMapView()
    
    let trip : Trip
    
    private let cancelButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        return button
    }()
    
    private let pickupLabel : UILabel = {
       let label = UILabel()
        label.text = "Would you like to pick this passenger"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    private let acceptTripButton : UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(handleAcceptTrip), for: .touchUpInside)
        button.backgroundColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("ACCEPT TRIP", for: .normal)
        return button
    }()
    
    
    //MARK: - Lifecycle

    init(trip: Trip){
        self.trip = trip
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureMapView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    //MARK: - Selectors
    
    @objc func handleDismissal() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleAcceptTrip() {
        Service.shared.acceptTrip(trip: trip) { error, ref in
            self.delegate?.didAcceptTrip(self.trip)
        }
    }

    //MARK: - API
    
    
    //MARK: - Helper Functions
    
    func configureMapView() {
        let region = MKCoordinateRegion(center: trip.pickupCoordinates, latitudinalMeters: 1000,
                                        longitudinalMeters: 1000)
        mapView.setRegion(region, animated: false)
        
        let placemark = MKPlacemark(coordinate: trip.pickupCoordinates)
        let anno = MKPointAnnotation()
        anno.coordinate = trip.pickupCoordinates
        mapView.addAnnotation(anno)
        mapView.selectAnnotation(anno, animated: true)
    }
    
    func configureUI() {
        view.backgroundColor = .backgroundColor
        
        view.addSubview(cancelButton)
        cancelButton.anchor(top: view.safeAreaLayoutGuide.topAnchor , left: view.leftAnchor ,
                            paddingLeft: 16)
        
        view.addSubview(mapView)
        mapView.setDimensions(width: 270, height: 270)
        mapView.layer.cornerRadius = 270 / 2
        mapView.centerX(inView: view)
        mapView.centerY(inView: view , constant: -200)
        
        view.addSubview(pickupLabel)
        pickupLabel.centerX(inView: view)
        pickupLabel.anchor(top: mapView.bottomAnchor , paddingTop: 16)
        
        view.addSubview(acceptTripButton)
        acceptTripButton.anchor(top: pickupLabel.bottomAnchor , left: view.leftAnchor , right:
                                    view.rightAnchor , paddingTop: 16 , paddingLeft: 32 , paddingRight:
                                    32 , height: 50)
    }
}
