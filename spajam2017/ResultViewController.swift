//
//  ResultViewController.swift
//  spajam2017
//
//  Created by Yuta on 2017/05/14.
//  Copyright © 2017年 Yuta. All rights reserved.
//

import Foundation
import MapKit
import UIKit
import Charts

class ResultViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var speeds: [Float]?
    
    @IBOutlet weak var mapView: MKMapView!
    
    var coordinate: CLLocationCoordinate2D!
    var locationManager: CLLocationManager!
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "詳細"

        mapView.setCenter(mapView.userLocation.coordinate, animated: true)
        
        if(true){
            print("debug")
        }
        
        let slat = userDefaults.double(forKey: "startLocationLat")
        let slon = userDefaults.double(forKey: "startLocationLon")
        let startPin: MKPointAnnotation = MKPointAnnotation() //ピンを生成
        let scenter: CLLocationCoordinate2D = CLLocationCoordinate2DMake(slat, slon)
        startPin.coordinate = scenter
        startPin.title = "スタート地点"
        mapView.addAnnotation(startPin)
        
        let glat = userDefaults.double(forKey: "goalLocationLat")
        let glon = userDefaults.double(forKey: "goalLocationLon")
        let goalPin: MKPointAnnotation = MKPointAnnotation() //ピンを生成
        let gcenter: CLLocationCoordinate2D = CLLocationCoordinate2DMake(glat, glon)
        goalPin.coordinate = gcenter
        goalPin.title = "ゴール地点"
        mapView.addAnnotation(goalPin)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // 配列から現在座標を取得
        let myLocations: NSArray = locations as NSArray
        let myLastLocation: CLLocation = myLocations.lastObject as! CLLocation
        let myLocation:CLLocationCoordinate2D = myLastLocation.coordinate
        
        print("\(myLocation.latitude), \(myLocation.longitude)")
        
    }
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("regionDidChangeAnimated")
    }

}

