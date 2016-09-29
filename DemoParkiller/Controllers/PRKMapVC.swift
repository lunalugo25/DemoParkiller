//
//  PRKMapVC.swift
//  DemoParkiller
//
//  Created by jorge luna on 25/09/16.
//  Copyright © 2016 Jorge Luna. All rights reserved.
//

import Foundation
import GoogleMaps
import GooglePlacesSearchController
import UIKit

enum PRKStatus {
    case Missing
    case Pending
    case Confirmed
}

class PRKMapVC : UIViewController, GMSMapViewDelegate {
    
    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var btnAction: UIButton!
    @IBOutlet var lblInformation: UILabel!
    @IBOutlet var heigthInformation: NSLayoutConstraint!
    
    private var locationMexico = CLLocationCoordinate2D()
    private var currentPositionMarker = GMSMarker()
    private var circleGreen = GMSCircle()
    private var circleYellow = GMSCircle()
    private var circleOrange = GMSCircle()
    private var circleRed = GMSCircle()
    private var pathTwoDirections = GMSMutablePath()
    private var polyLineTwoDirections = GMSPolyline()
    private var statusView : PRKStatus = PRKStatus.Missing
    
    private var myContext = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationMexico = CLLocationCoordinate2D(latitude: 19.435478, longitude: -99.136479)
        
        let camera = GMSCameraPosition.cameraWithLatitude(locationMexico.latitude, longitude: locationMexico.longitude, zoom: 13.0)
        mapView.animateToCameraPosition(camera)
        mapView.myLocationEnabled = true
        mapView.settings.compassButton = true
        mapView.mapType = kGMSTypeNormal
        mapView.settings.myLocationButton = true
        mapView.delegate = self
        mapView.myLocation
        mapView.addObserver(self, forKeyPath: "myLocation", options:NSKeyValueObservingOptions.New, context: &myContext)
        
        currentPositionMarker = GMSMarker()
        currentPositionMarker.position = locationMexico
        currentPositionMarker.draggable = true
        currentPositionMarker.icon = UIImage.init(named: "btnMarker")
        
        circleGreen = GMSCircle(position: currentPositionMarker.position, radius: 10)
        circleGreen.fillColor = UIColor.greenColor().colorWithAlphaComponent(0.1)
        circleGreen.strokeColor = UIColor.greenColor()
        circleGreen.strokeWidth = 1
        circleYellow = GMSCircle(position: currentPositionMarker.position, radius: 50)
        circleYellow.fillColor = UIColor.yellowColor().colorWithAlphaComponent(0.1)
        circleYellow.strokeColor = UIColor.yellowColor()
        circleYellow.strokeWidth = 1
        circleOrange = GMSCircle(position: currentPositionMarker.position, radius: 100)
        circleOrange.fillColor = UIColor.orangeColor().colorWithAlphaComponent(0.1)
        circleOrange.strokeColor = UIColor.orangeColor()
        circleOrange.strokeWidth = 1
        circleRed = GMSCircle(position: currentPositionMarker.position, radius: 200)
        circleRed.fillColor = UIColor.redColor().colorWithAlphaComponent(0.1)
        circleRed.strokeColor = UIColor.redColor()
        circleRed.strokeWidth = 1
        
        btnAction.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        self.changeStatusView()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let mylocation = mapView.myLocation {
            print("User's location: \(mylocation)")
        } else {
            print("User's location is unknown")
        }
        
        self.updateNavigationButtons()
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if context == &myContext {
            //if let newValue = change?[.newKey] {
            guard let changeKey = change, let newValue = changeKey["new"] else { return }
            
            print("Date changed: \(newValue)")
            switch statusView {
            case .Confirmed:
                self.changeStatusView()
            case .Missing:
                guard let myLocation = mapView.myLocation else { return  }
                currentPositionMarker.position = myLocation.coordinate
                mapView.animateToCameraPosition(GMSCameraPosition.cameraWithTarget(myLocation.coordinate, zoom: 17.0))
            default:
                return
            }
            /*
            if let newValue = change!["new"] {
                print("Date changed: \(newValue)")
            }
             */
        }
    }
    
    @IBAction func clickButtonAction(sender: AnyObject) {
        switch statusView {
        case .Missing:
            statusView = .Pending
        case .Pending:
            statusView = .Confirmed
        case .Confirmed:
            statusView = .Pending
        }
        self.changeStatusView()
    }
    
    func updateNavigationButtons(){
        let imageSearch = UIImage.init(named: "itemSearch")
        let search = UIBarButtonItem.init(image: imageSearch, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(searchAddress))
        self.navigationItem.rightBarButtonItems = [search]
    }
    
    func searchAddress() {
        NSLog("searchAddress")
        
        let coord = locationMexico
        let controller = GooglePlacesSearchController(
            apiKey: "AIzaSyCGv0qpZwLr2AhG4hXhp8BFjD10LjZEaag",
            placeType: PlaceType.Address,
            coordinate: coord,
            radius: 1000
        )
        
        controller.didSelectGooglePlace { (place) -> Void in
            print(place.description)
            
            self.currentPositionMarker.position = place.coordinate
            self.mapView.animateToCameraPosition(GMSCameraPosition.cameraWithTarget(place.coordinate, zoom: 17.0))
            controller.active = false
            self.statusView = .Pending
            self.changeStatusView()
        }
        
        presentViewController(controller, animated: true, completion: nil)
    }
    
    func updateCurrentPositionMarker(currentLocation: CLLocation) {
        self.currentPositionMarker.map = nil
        self.currentPositionMarker = GMSMarker(position: currentLocation.coordinate)
        self.currentPositionMarker.icon = GMSMarker.markerImageWithColor(UIColor.cyanColor())
        self.currentPositionMarker.map = mapView
    }
    
    func mapView(mapView: GMSMapView, didTapAtCoordinate coordinate: CLLocationCoordinate2D){
        NSLog("didTapAtCoordinate")
        switch statusView {
        case .Confirmed:
            return
        default:
            currentPositionMarker.position = coordinate
            mapView.animateToCameraPosition(GMSCameraPosition.cameraWithTarget(coordinate, zoom: 17.0))
            statusView = .Pending
            self.changeStatusView()
        }
    }
    
    func mapView(mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        switch statusView {
        case .Pending:
            let calloutView = NSBundle.mainBundle().loadNibNamed("PRKMarkerWindow", owner: self, options: nil)![0] as! UIView
        return calloutView
        default:
            return nil
        }
    }
    
    func mapView(mapView: GMSMapView, didTapInfoWindowOfMarker marker: GMSMarker) {
        statusView = .Confirmed
        self.changeStatusView()
    }
    
    func changeStatusView(){
        switch statusView {
        case .Missing:
            btnAction.setTitle("Agregar Marcador", forState: UIControlState.Normal)
            btnAction.backgroundColor = UIColor.blueColor()
            currentPositionMarker.map = nil
            mapView.clear()
            
            heigthInformation.constant = 0
            lblInformation.text = ""
        case .Pending:
            btnAction.setTitle("Confirmar Marcador", forState: UIControlState.Normal)
            btnAction.backgroundColor = UIColor.greenColor()
            currentPositionMarker.map = mapView
            circleGreen.map = nil
            circleYellow.map = nil
            circleOrange.map = nil
            circleRed.map = nil
            polyLineTwoDirections.map = nil
            heigthInformation.constant = 0
            lblInformation.text = ""
        case .Confirmed:
            mapView.clear()
            btnAction.setTitle("Cancelar", forState: UIControlState.Normal)
            btnAction.backgroundColor = UIColor.redColor()
            currentPositionMarker.map = mapView
            circleGreen.map = mapView
            circleGreen.position = currentPositionMarker.position
            circleYellow.map = mapView
            circleYellow.position = currentPositionMarker.position
            circleOrange.map = mapView
            circleOrange.position = currentPositionMarker.position
            circleRed.map = mapView
            circleRed.position = currentPositionMarker.position
            mapView.selectedMarker = nil
            
            guard let myLocation = mapView.myLocation else { return }
            pathTwoDirections = GMSMutablePath.init()
            pathTwoDirections.addCoordinate(currentPositionMarker.position)
            pathTwoDirections.addCoordinate(myLocation.coordinate)
            polyLineTwoDirections = GMSPolyline(path: pathTwoDirections)
            polyLineTwoDirections.strokeWidth = 2.0
            polyLineTwoDirections.map = mapView
            
            let markerLocation = CLLocation.init(latitude: currentPositionMarker.position.latitude, longitude: currentPositionMarker.position.longitude)
            let distance = myLocation.distanceFromLocation(markerLocation)
            NSLog("Distancia: \(distance)")
            
            var stringInfo:String
            if distance <= 10 {
                stringInfo = "Estás en el punto objetivo"
            }else if distance <= 50 {
                stringInfo = "Estás muy próximo al punto objetivo"
            }else if distance <= 100 {
                stringInfo = "Estás próximo al punto objetivo"
            }else if distance <= 200 {
                stringInfo = "Estás lejos del punto objetivo"
            }else  {
                stringInfo = "Estás muy lejos del punto objetivo"
            }
            
            
            lblInformation.text = stringInfo
            
            let bounds = GMSCoordinateBounds(coordinate: currentPositionMarker.position, coordinate: myLocation.coordinate)
            let camera = mapView.cameraForBounds(bounds, insets:UIEdgeInsetsMake(40, 20, 80, 20))
            mapView.camera = camera!
            heigthInformation.constant = 200
            
        }
        btnAction.setNeedsLayout()
    }
}
