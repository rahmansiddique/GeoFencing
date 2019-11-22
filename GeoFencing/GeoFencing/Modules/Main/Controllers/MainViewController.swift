//
//  ViewController.swift
//  GeoFencing
//
//  Created by Inam Ur Rahman on 10/11/2019.
//  Copyright © 2019 Systems Limited. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MainViewController: BaseVC {
    
    //MARK: Properties
    var geoFenceZoneViewModel:GeofenceZoneViewModel = GeofenceZoneViewModel()
    let annotation = MKPointAnnotation()

    
    //MARK: - IBOutlets
    @IBOutlet weak var ssidTextField: UITextField!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var radiusSlider: UISlider!
    @IBOutlet weak var radiusLabel: UILabel!
    
    //MARK: - Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        observeChangesInViewModel()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    //MARK: - Functions
    
    func setupUI(){
        ssidTextField.delegate = self
        self.geoFenceZoneViewModel.updateRegion(with: Double(radiusSlider.value))
        //MARK: - Adding tap gesture to dismiss keyboard on tap, without adding any library
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        //MARK: - Adding tap gesture to map to fetch the coordinated of the fetched location
        let mapTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(convertTapToPoint(gesture:)))
        mapView.addGestureRecognizer(mapTap)
    }
    
    func observeChangesInViewModel(){
        geoFenceZoneViewModel.resultStringUpdate = { [weak self] (message) in
            guard let weakSelf = self else {return}
            weakSelf.statusLabel.text = message
        }
        
        geoFenceZoneViewModel.deviceLocationChangeCallback = { [weak self] (newCenterPoint) in
            guard let weakSelf = self else {return}
            guard  let newPoint = newCenterPoint else {return}
            weakSelf.plotZoneCenterToMap(newPoint)
        }
        
        geoFenceZoneViewModel.radiusUpdatedCallback = { [weak self] (radiusString) in
            guard let weakSelf = self else {return}
            weakSelf.radiusLabel.text = radiusString
        }
    }
    
    func plotZoneCenterToMap(_ center:CLLocationCoordinate2D){
        print("Device location changed")
        mapView.removeAnnotation(annotation)
        annotation.coordinate = center
        mapView.addAnnotation(annotation)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    //MARK: - Selectors
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func convertTapToPoint(gesture:UITapGestureRecognizer) {
        let point = gesture.location(in: self.mapView)
        let tapCoordinates = self.mapView.convert(point, toCoordinateFrom: self.view)
        self.geoFenceZoneViewModel.updateRegion(with: tapCoordinates)
    }
    
    //MARK: - IBActions
    @IBAction func switchToDefaultZoneTapped(_ sender: Any) {
        self.geoFenceZoneViewModel.updateToDefaultZone()
    }
    @IBAction func radiusSliderChanged(_ sender: Any) {
        guard let slider = sender as? UISlider else {return}
        self.geoFenceZoneViewModel.updateRegion(with: Double(slider.value))
    }
}

extension MainViewController:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField == ssidTextField{
            self.geoFenceZoneViewModel.updateSSID(with: textField.text ?? "")
        }
    }
}
