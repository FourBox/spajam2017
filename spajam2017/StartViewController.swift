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
    var locations: Results<Location>!
    var locations2: [Location]!
    var timer : Timer!
    var startTime: NSDate!
    var finishiTime: NSDate!
    var userDefaults: UserDefaults!
    var locationData:CLLocation!
    var apiString: String!
    var lat: String!
    var lon: String!
    var check:Bool!  //apiStringの初回読み込みに使用

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.distanceFilter = 100.0
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        let status = CLLocationManager.authorizationStatus()
        deleteAllLocations()
        locations2 = Array()
        apiString = ""
        lat = ""
        lon = ""
        check = true
        
        // まだ認証が得られていない場合は、認証ダイアログを表示.
        if(status != CLAuthorizationStatus.authorizedWhenInUse) {
            locationManager.requestWhenInUseAuthorization()
        }
        
        // 位置情報の更新を開始.
        locationManager.startUpdatingLocation()
        
        //現在位置を中心にセット
        mapView.setCenter(mapView.userLocation.coordinate, animated: true)
        mapView.userTrackingMode = MKUserTrackingMode.follow
        
        //ロケーションデータをロード
        self.locations = self.loadStoredLocations()
    }

    // GPSから値を取得した際に呼び出されるメソッド
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // 配列から現在座標を取得
        let myLocations: NSArray = locations as NSArray
        let myLastLocation: CLLocation = myLocations.lastObject as! CLLocation
        let myLocation:CLLocationCoordinate2D = myLastLocation.coordinate
        
        print("\(myLocation.latitude), \(myLocation.longitude)")
        
        locationData = myLastLocation
        lat = String(myLocation.latitude)
        lon = String(myLocation.longitude)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func pushStartButton(_ sender: Any) {
        if(isStarting){
            isStarting = false
            finishiTime = NSDate() //終了時刻の記録
            startButton.setTitle("Start", for: .normal)
            dateLabel.text = "🙆🏻月🙅🏻日"
            let date_String = pastTimeCheck(data1: finishiTime, data2: startTime)
            timeLabel.text = "所要時間   " + date_String
            timer.invalidate()

            finishing()
        }else{
            isStarting = true
            startTime = NSDate() //開始時刻の記録
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm:ss"
            let timeString = formatter.string(from: startTime as Date)
           //TODO: ボタンの画像とか変更
            startButton.setTitle("Stop", for: .normal)
            dateLabel.text = "スタート時間  " + timeString
            timeLabel.text = "経過時間   00:00:00"
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(StartViewController.onUpdate(timer:)), userInfo: nil, repeats: true)
        }
    }
    
    //Locationデータの作成
    fileprivate func makeLocation(rawLocation: CLLocation) -> Location {
        let location = Location()
        location.latitude = rawLocation.coordinate.latitude
        location.longitude = rawLocation.coordinate.longitude
        location.createdAt = Date()
        return location
    }
    
    //直近の緯度経度を記録
    fileprivate func addCurrentLocation(_ rowLocation: CLLocation) {
        let location = makeLocation(rawLocation: rowLocation)
        let realm = try! Realm()
        try! realm.write {
            realm.add(location)
        }
        locations2.append(location)
    }
    
    //realmをロード
    fileprivate func loadStoredLocations() -> Results<Location> {
        let realm = try! Realm()
        return realm.objects(Location.self).sorted(byKeyPath: "createdAt", ascending: false)
    }
    
    //realmのデータ全削除
    fileprivate func deleteAllLocations() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    //Stopボタンを押したときに実行
    func finishing(){
        let realm = try! Realm()
        let result: Results<Location> = realm.objects(Location.self).sorted(byKeyPath: "createdAt", ascending: false)
            let array = Array(result) //中身が消える？
            apiString = apiString + "]"
            postAPI()
    }

    //緯度経度を送ったら速度が返ってくる
    func postAPI() {
        let postString = apiString
        var request = URLRequest(url: URL(string: "http://133.242.224.242/")!)
        request.httpMethod = "POST"
        request.httpBody = postString?.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) in
            if error != nil {
                print(error)
                return
            }
            print("response: \(response!)")
            let output = String(data: data!, encoding: .utf8)!
            print("output: \(output)")
        })
        task.resume()
    }

    func onUpdate(timer : Timer){
        let date_String = pastTimeCheck(data1: NSDate(), data2: startTime)
        timeLabel.text = "経過時間   " + date_String
        
        let time = NSDate().timeIntervalSince(startTime as Date) // 現在時刻と開始時刻の差
        let hh = Int(time / 3600)
        let mm = Int((time - Double(hh * 3600)) / 60)
        let ss = Int(time - Double(hh * 3600 + mm * 60))
        //5秒ごとに緯度経度を作成・保存
        if(ss%5==0){
            if(isStarting){
                addCurrentLocation(locationData)
                if(check){
                    apiString = "[[" + lat + "," + lon + "]"
                    check = false
                }else{
                    apiString = apiString + ",[" + lat + "," + lon + "]"
                }
            }
        }
    }
    
    func pastTimeCheck(data1: NSDate, data2: NSDate) -> String{
        let time = data1.timeIntervalSince(data2 as Date)
        let hh = Int(time / 3600)
        let mm = Int((time - Double(hh * 3600)) / 60)
        let ss = Int(time - Double(hh * 3600 + mm * 60))
        let date_String = String(format: "%02d:%02d:%02d", hh, mm, ss)
        return date_String
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
