//
//  SecondPasswordViewController.swift
//  Blockchain
//
//  Created by Sjors Provoost on 18-06-15.
//  Copyright (c) 2015 Blockchain Luxembourg S.A. All rights reserved.
//

import UIKit

protocol SecondPasswordDelegate {
    func didGetSecondPassword(_: String)
    func returnToRootViewController(_ completionHandler: @escaping () -> Void ) -> Void
    var isVerifying : Bool {get set}
}

class SecondPasswordViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var navigationBar: UINavigationBar?
    @IBOutlet weak var password: BCSecureTextField?
    @IBOutlet var continueButton: UIButton!

    @IBOutlet var descriptionLabel: UILabel!
    
    var topBar: UIView?
    var closeButton: UIButton?
    
    var wallet : Wallet?
    
    var delegate : SecondPasswordDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topBar = UIView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: Constants.Measurements.DefaultHeaderHeight));
        topBar!.backgroundColor = Constants.Colors.BlockchainBlue
        self.view.addSubview(topBar!);
        
        let headerLabel = UILabel(frame:CGRect(x: 60, y: 27, width: 200, height: 30));
        headerLabel.font = UIFont(name:"Montserrat-Regular", size: Constants.FontSizes.Small)
        headerLabel.textColor = UIColor.white
        headerLabel.textAlignment = .center;
        headerLabel.adjustsFontSizeToFitWidth = true;
        headerLabel.text = NSLocalizedString("Second Password Required", comment: "");
        headerLabel.center = CGPoint(x: topBar!.center.x, y: headerLabel.center.y);
        topBar!.addSubview(headerLabel);
        
        descriptionLabel.center = CGPoint(x: view.center.x, y: descriptionLabel.center.y);
        
        password!.center = CGPoint(x: view.center.x, y: password!.frame.origin.y)
        password!.setupOnePixelLine()
        
        continueButton!.center = CGPoint(x: view.center.x, y: continueButton!.frame.origin.y)
        
        closeButton = UIButton(type: UIButtonType.custom)
        closeButton!.frame = CGRect(x: self.view.frame.size.width - 80, y: 15, width: 80, height: 51);
        closeButton!.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
        closeButton!.contentHorizontalAlignment = .right
        closeButton!.center = CGPoint(x: closeButton!.center.x, y: headerLabel.center.y);
        closeButton!.setImage(UIImage(named:"close"), for: UIControlState())
        closeButton!.addTarget(self, action:#selector(SecondPasswordViewController.close(_:)), for: UIControlEvents.touchUpInside);
        topBar!.addSubview(closeButton!);
        
        password?.returnKeyType = .done
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        password?.becomeFirstResponder()
    }

    @IBAction func done(_ sender: UIButton) {
        checkSecondPassword()
    }
    
    @IBAction func close(_ sender: UIButton) {
        password?.resignFirstResponder()
        delegate!.returnToRootViewController { () -> Void in
            self.dismiss(animated: true, completion: nil)
        }
    }

    func checkSecondPassword() {
        let secondPassword = password!.text
        if secondPassword!.isEmpty {
            alertUserWithErrorMessage((NSLocalizedString("No Password Entered", comment: "")))
        }
        else if wallet!.validateSecondPassword(secondPassword) {
            password?.resignFirstResponder()
            delegate?.didGetSecondPassword(secondPassword!)
            if (delegate!.isVerifying) {
                // if we are verifying backup, go to verify words view controller
                self.navigationController?.performSegue(withIdentifier: "backupVerify", sender: nil)
            }
                self.dismiss(animated: true, completion: nil)
        } else {
            alertUserWithErrorMessage((NSLocalizedString("Second Password Incorrect", comment: "")))
        }
    }
    
    func alertUserWithErrorMessage(_ message : String) {
        let alert = UIAlertController(title:  NSLocalizedString("Error", comment:""), message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment:""), style: .default, handler: { (UIAlertAction) -> Void in
             self.password?.text = ""
        }))
        NotificationCenter.default.addObserver(alert, selector: #selector(UIViewController.autoDismiss), name: NSNotification.Name(rawValue: "reloadToDismissViews"), object: nil)
        present(alert, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        checkSecondPassword()
        return true
    }
    
}
