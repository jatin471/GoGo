//
//  SignUpController.swift
//  GoGo
//
//  Created by JATIN YADAV on 01/08/23.
//

import UIKit
import Firebase
import GeoFire

class SignUpController: UIViewController {
    
    //MARK: - PROPERTIES
    
    private var location = LocationHandler.shared.locationManager.location
    
    private let titleLabel:UILabel = {
        let label = UILabel()
        label.text = "GOGO"
        label.font = UIFont(name: "Avenir-Light", size: 36)
        label.textColor = UIColor(white: 1, alpha: 0.8)
        return label
    }()
    
    private lazy var emailContainerView : UIView = {
        let view = UIView().inputContainerView(image: UIImage(systemName: "envelope")!, textField: emailTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    
    }()
    
    
    private lazy var passwordContainerView : UIView = {
        let view = UIView().inputContainerView(image: UIImage(systemName: "lock")!, textField: passwordTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private lazy var fullnameContainerView : UIView = {
        let view = UIView().inputContainerView(image: UIImage(systemName: "person")!, textField: fullnameTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private lazy var accountTypeContainerView : UIView = {
        let view = UIView().inputContainerView(image: UIImage(systemName: "person.circle.fill")!, segmentedControl: accountTypeSegmentedControl)
        view.heightAnchor.constraint(equalToConstant: 80).isActive = true
        return view
    }()
    
    private let emailTextField : UITextField = {
        return UITextField().textField(withPlaceholder: "Email", isSecureTextEntry: false)
    }()
    
    private let passwordTextField : UITextField = {
        return UITextField().textField(withPlaceholder: "Password", isSecureTextEntry: true)
    }()
    
    

    private let fullnameTextField : UITextField = {
        return UITextField().textField(withPlaceholder: "Fullname", isSecureTextEntry: false)
    }()
    
    private let accountTypeSegmentedControl : UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Rider" , "Driver"])
        sc.backgroundColor = .backgroundColor
        sc.tintColor = UIColor(white: 1, alpha: 0.87)
        sc.selectedSegmentIndex = 0
        return sc
    }()
    
    
    private let signUpButton : UIButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    private let alreadyHaveAccountButton :UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Already Have An Account ? " ,attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16) ,NSAttributedString.Key.foregroundColor :UIColor.lightGray])
        
        attributedTitle.append(NSAttributedString(string: "Log In" ,attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 16) ,NSAttributedString.Key.foregroundColor :UIColor.mainBlueTint]))
        button.addTarget(self, action: #selector(handleShowLogIn), for: .touchUpInside)
        button.setAttributedTitle(attributedTitle, for: .normal)
        return button
    }()
    
    
    
    //MARK: - LIFECYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureUI()
        
        
        
    }

    //MARK: - SELECTORS
    
    
    @objc func handleShowLogIn(){
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleSignUp(){
        guard let email = emailTextField.text else {return}
        guard let password  = passwordTextField.text else {return}
        guard let fullname = fullnameTextField.text else {return}
        let accountTypeIndex = accountTypeSegmentedControl.selectedSegmentIndex
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Failed to register with error \(error)")
                return
            }
            
            guard let uid = result?.user.uid else {return}
            
            let values = ["email":email ,
                          "fullname" : fullname,
                          "accountType" : accountTypeIndex] as [String : Any]
            
            
            if accountTypeIndex == 1 {
                var geofire = GeoFire(firebaseRef: REF_DRIVER_LOCATIONS)
                
                guard let location = self.location else { return }
                
                geofire.setLocation(location, forKey: uid) { error in
                    
                    self.uploadUserDataAndShowHomeController(uid: uid, values: values)
                }
            }
            
            self.uploadUserDataAndShowHomeController(uid: uid, values: values)
            
        }
    }
    
    //MARK: - Helper Functions
    
    func uploadUserDataAndShowHomeController(uid: String , values : [String : Any]) {
        REF_USERS.child(uid).updateChildValues(values) { error, ref in
            guard let controller = UIApplication.shared.keyWindow?.rootViewController as? HomeController else {return}
            controller.configure()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func configureUI(){
        
        view.backgroundColor = .backgroundColor
        
        view.addSubview(titleLabel)
        titleLabel.anchor(top:view.safeAreaLayoutGuide.topAnchor)
        titleLabel.centerX(inView: view)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView ,fullnameContainerView ,  passwordContainerView ,accountTypeContainerView, signUpButton])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 24
        
        view.addSubview(stack)
        stack.anchor(top: titleLabel.bottomAnchor , left: view.leftAnchor , right: view.rightAnchor , paddingTop: 40 , paddingLeft: 16 , paddingRight: 16)
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.centerX(inView: view)
        alreadyHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor , height: 32)
        
    }
    
}
