//
//  StartViewController.swift
//  spajam2017
//
//  Created by Yuta on 2017/05/13.
//  Copyright © 2017年 Yuta. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import RealmSwift

class Location: Object {
    dynamic var latitude: Double = 0.0
    dynamic var longitude: Double = 0.0
    dynamic var createdAt = Date(timeIntervalSince1970: 1)
}

class StartViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    var coordinate: CLLocationCoordinate2D!
    var locationManager: CLLocationManager!
    var isStarting = false
    var locations : [Location]?

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.distanceFilter = 100.0
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        let status = CLLocationManager.authorizationStatus()
        
        // まだ認証が得られていない場合は、認証ダイアログを表示.
        if(status != CLAuthorizationStatus.authorizedWhenInUse) {
            locationManager.requestWhenInUseAuthorization()
        }
        
        // 位置情報の更新を開始.
        locationManager.startUpdatingLocation()
        
        //現在位置を中心にセット
        mapView.setCenter(mapView.userLocation.coordinate, animated: true)
        mapView.userTrackingMode = MKUserTrackingMode.follow
        
        
    }
    
    // GPSから値を取得した際に呼び出されるメソッド
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // 配列から現在座標を取得
        let myLocations: NSArray = locations as NSArray
        let myLastLocation: CLLocation = myLocations.lastObject as! CLLocation
        let myLocation:CLLocationCoordinate2D = myLastLocation.coordinate
        
        print("\(myLocation.latitude), \(myLocation.longitude)")
        
        // 縮尺
        let myLatDist : CLLocationDistance = 100
        let myLonDist : CLLocationDistance = 100
        
        // Regionを作成
        let myRegion: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(myLocation, myLatDist, myLonDist);
        
        // MapViewに反映
        mapView.setRegion(myRegion, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func pushStartButton(_ sender: Any) {
        if(isStarting){
            isStarting = false
            startButton.setTitle("Start", for: .normal)
            dateLabel.text = "🙆🏻月🙅🏻日"
            timeLabel.text = "所要時間   hh:mm:ss"
        }else{
            isStarting = true
           //TODO: ボタンの画像とか変更
            startButton.setTitle("Stop", for: .normal)
            dateLabel.text = "スタート時間 hh:mm:ss"
            timeLabel.text = "経過時間   hh:mm:ss"
        }
    }
    
    
    // 認証が変更された時に呼び出されるメソッド.
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status{
        case .authorizedWhenInUse:
            print("AuthorizedWhenInUse")
        case .authorized:
            print("Authorized")
        case .denied:
            print("Denied")
        case .restricted:
            print("Restricted")
        case .notDetermined:
            print("NotDetermined")
        }
    }


}
