//
//  ViewController.swift
//  GeoFencing
//
//  Created by Inam Ur Rahman on 10/11/2019.
//  Copyright © 2019 Systems Limited. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: BaseVC {
    
    //MARK: Properties
    var geoFenceZoneViewModel:GeofenceZoneViewModel = GeofenceZoneViewModel()
    
    //MARK: - IBOutlets
    @IBOutlet weak var radiusTextField: UITextField!
    @IBOutlet weak var ssidTextField: UITextField!
    @IBOutlet weak var statusLabel: UILabel!
    
    //MARK: - Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        observeChangesInViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    //MARK: - Functions
    
    func setupUI(){
        radiusTextField.delegate = self
        ssidTextField.delegate = self
        //Adding tap gesture to dismiss keyboard on tap, without adding any library
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func observeChangesInViewModel(){
        geoFenceZoneViewModel.resultStringUpdate = { [weak self] (message) in
            guard let weakSelf = self else {return}
            weakSelf.statusLabel.text = message
        }
    }
    
    //MARK: - Selectors
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension MainViewController:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField == radiusTextField{
            let newRadius  = Double(textField.text ?? "") ?? 0.0
            self.geoFenceZoneViewModel.updateRegion(with: newRadius)
        }else if textField == ssidTextField{
            self.geoFenceZoneViewModel.updateSSID(with: textField.text ?? "")
        }
    }
}
