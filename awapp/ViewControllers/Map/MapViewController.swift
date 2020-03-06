//
//  MapViewController.swift
//  awapp
//
//  Created by Putte on 2019-11-12.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var header: UINavigationItem!
    @IBOutlet weak var navigation: UIBarButtonItem!
    @IBOutlet weak var hours: UILabel!
    @IBOutlet weak var monThur: UILabel!
    @IBOutlet weak var friday: UILabel!
    @IBOutlet weak var weekend: UILabel!
    @IBOutlet weak var lunch: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        translateCode()
        
        mapView.delegate = self
        
        //Calling method to set annotation point
        setAnnotation()
    }
    
    func translateCode(){
        header.title = NSLocalizedString("map_header", comment: "")
        navigation.title = NSLocalizedString("map_navigation_button", comment: "")
        hours.text = NSLocalizedString("map_opening_hours", comment: "")
        monThur.text = NSLocalizedString("map_monday_thursday", comment: "")
        friday.text = NSLocalizedString("map_friday", comment: "")
        weekend.text = NSLocalizedString("map_weekend", comment: "")
        lunch.text = NSLocalizedString("map_lunch_closed", comment: "")
    }
    
    //Set annotation point on map
    func setAnnotation(){
        //Creating annotation point of location
        let location = MKPointAnnotation()
        
        //Adding title and subtitle
        location.title = "Aw Verkstad"
        location.subtitle = "Tagenevägen 9 422 59 Hisings Backa"
        
        //Adding coordinates
        location.coordinate = CLLocationCoordinate2D(latitude: 57.768451, longitude: 11.992650)
        
        //Adding the annotation to the mapview
        mapView.addAnnotation(location)
        
        //Zooming in to location
        let viewRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 400, longitudinalMeters: 400)
        
        self.mapView.setRegion(viewRegion, animated: true)
    }
    
    //Open navigation in maps
    @IBAction func openNavigation(_ sender: Any) {
        
        let coordinate = CLLocationCoordinate2DMake(57.768451, 11.992650)
        
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        
        mapItem.name = "Mekonomen AW Verkstad"
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
    }
    
}
