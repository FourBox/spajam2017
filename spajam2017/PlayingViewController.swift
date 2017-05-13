//
//  PlayingViewController.swift
//  
//
//  Created by Yuta on 2017/05/13.
//
//

import UIKit
import MapKit
import RealmSwift

class Location: Object {
    dynamic var latitude: Double = 0.0
    dynamic var longitude: Double = 0.0
    dynamic var createdAt = Date(timeIntervalSince1970: 1)
}

class PlayingViewController: UIViewController, CLLocationManagerDelegate {
  
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    
    var locationManager: CLLocationManager!
    
    let userDefaults = UserDefaults.standard
    
    var locations: Results<Location>!
    var token: NotificationToken!
    var isUpdating = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager() // インスタンスの生成
        locationManager.delegate = self
        locationManager.distanceFilter = 100.0
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters

        // 位置情報の更新を開始.
        locationManager.startUpdatingLocation()
        
        //現在位置を中心にセット
        mapView.setCenter(mapView.userLocation.coordinate, animated: true)
        mapView.userTrackingMode = MKUserTrackingMode.follow

    }
    
    // GPSから値を取得した際に呼び出されるメソッド.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        // 配列から現在座標を取得.
        let myLocations: NSArray = locations as NSArray
        let myLastLocation: CLLocation = myLocations.lastObject as! CLLocation
        let myLocation:CLLocationCoordinate2D = myLastLocation.coordinate
        
        print("\(myLocation.latitude), \(myLocation.longitude)")
        
        // 縮尺.
        let myLatDist : CLLocationDistance = 100
        let myLonDist : CLLocationDistance = 100
        
        // Regionを作成.
        let myRegion: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(myLocation, myLatDist, myLonDist);
        
        // MapViewに反映.
        mapView.setRegion(myRegion, animated: true)
    }
    
    // Regionが変更した時に呼び出されるメソッド.
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("regionDidChangeAnimated")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
