//
//  ViewController.swift
//  MapKitSample
//
//  Created by 藤田えりか on 2020/07/31.
//  Copyright © 2020 com.erica. All rights reserved.
//

import UIKit
import MapKit
import NCMB
import CoreLocation

//自分だけが見れて設定できるマップの画面
class MapOnlyViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate, UISearchBarDelegate  {
    
    @IBOutlet var mapView: MKMapView!
    
    var pointAno: MKPointAnnotation = MKPointAnnotation()
    
    var locManager: CLLocationManager!
    
    var cafeInfos = [CafeInfo]()
    
    @IBOutlet var longPressGesRec: UILongPressGestureRecognizer!
    
    
    var detailId = [String]()
    var detailsub = [String]()
    var detailImage = [String]()
    var detailtext = [String]()
    var likes = [Bool]()
    var smileCounts = [Int]()
    var userImages = [String]()
    var userNames = [String]()
    var blockUserIdArray = [String]()
    
    var nextId : String?
    var nextText : String?
    var nextTitle: String?
    var nextImage: String?
    
    
    
    var new:Bool?
    
    var latitude : Double!
    var longitude : Double!
    var latitudes = [Double]()
    var longitudes = [Double]()
    
    var currentLatitude: Double!
    var currentLongitude: Double!
    
    var adressString = ""
    var annotationList = [MKPointAnnotation]()
    @IBOutlet var searchBar: UISearchBar!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //locationManagerの設定
        setupLocationManager()
        
        //地図の初期化
        setSearchBar()
        initMap()
        setupScaleBar()
        setupCompass()
    
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        mapView.delegate = self
        
        //longPressGesRec.delegate = self
        
        load()
        
    }
    
    func setSearchBar(){
        searchBar.delegate = self
        searchBar.placeholder = "都市名で検索"
        searchBar.autocapitalizationType = UITextAutocapitalizationType.none
    }
    
    //searchBarをクリック時
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    //キャンセルボタンを押した時の処理
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchPlaces(searchText: nil)
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    //searchBarで検索時(Enter押した時)呼ばれる関数
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchPlaces(searchText: searchBar.text)
    }
    
    func searchPlaces(searchText: String?){
        if let searchKey = searchText {
                    
                    let geocoder = CLGeocoder()
                    
                    geocoder.geocodeAddressString(searchKey, completionHandler: { (placemarks, error) in
                        
                        if let unwrapPlacemarks = placemarks {
                            if let firstPlacemark = unwrapPlacemarks.first {
                                if let location = firstPlacemark.location {
                                    
                                    // annotationの初期化
                                    self.mapView.removeAnnotations(self.annotationList)
                                    
                                    let targetCoordinate = location.coordinate
                                    print(targetCoordinate)
                                    self.latitude = targetCoordinate.latitude
                                    self.longitude = targetCoordinate.longitude
                                    
                                    let pin = MKPointAnnotation()
                                    pin.coordinate = targetCoordinate
                                    pin.title = searchKey
                                    self.mapView.addAnnotation(pin)
                                    self.annotationList.append(pin)
                                    self.mapView.region = MKCoordinateRegion(center: targetCoordinate, latitudinalMeters: 500.0, longitudinalMeters: 500.0)
                                    
                                    print(searchKey)
                                    self.adressString = searchKey
                                }
                            }
                        }
                    })
                }
    }
    
    
    //locationManagerの設定
    func setupLocationManager(){
        // locationManagerオブジェクトの初期化
                locManager = CLLocationManager()
                
                // locationManagerオブジェクトが初期化に成功している場合のみ許可をリクエスト
                guard let locManager = locManager else { return }
                
                // ユーザに対して、位置情報を取得する許可をリクエスト
                locManager.requestWhenInUseAuthorization()
                
                // ユーザから「アプリ使用中の位置情報取得」の許可が得られた場合のみ、マネージャの設定を行う
                let status = CLLocationManager.authorizationStatus()
                if status == .authorizedWhenInUse {
                    
                    // ViewControllerクラスが管理マネージャのデリゲート先になるように設定
                    locManager.delegate = self
                    // メートル単位で設定
                    locManager.distanceFilter = 10
                    // 位置情報の取得を開始
                    locManager.startUpdatingLocation()
        }

    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            
            // 現在位置の取得
            let location = locations.first
            // 緯度の取得
            currentLatitude = location?.coordinate.latitude
            // 経度の取得
            currentLongitude = location?.coordinate.longitude
            
            print("latitude: \(currentLatitude!)\nlongitude: \(currentLongitude!)")
            
            // 現在位置が更新される度に地図の中心位置を変更する（アニメーション）
            mapView.userTrackingMode = .follow
        }

    
    // 地図の初期化
        func initMap() {
            // 縮尺を設定
            var region: MKCoordinateRegion = mapView.region
            region.span.latitudeDelta = 0.02
            region.span.longitudeDelta = 0.02
            mapView.setRegion(region,animated:true)
            
            // 現在位置表示の有効化
            mapView.showsUserLocation = true
            // 現在位置設定（デバイスの動きとしてこの時の一回だけ中心位置が現在位置で更新される）
            mapView.userTrackingMode = .follow
        }
    
    
    func setupScaleBar() {
            // スケールバーの表示
            let scale = MKScaleView(mapView: mapView)
            scale.frame.origin.x = 15
            scale.frame.origin.y = 45
            scale.legendAlignment = .leading
            self.view.addSubview(scale)
        }
    
    func setupCompass() {
            // コンパスの表示
            let compass = MKCompassButton(mapView: mapView)
            compass.compassVisibility = .adaptive
            compass.frame = CGRect(x: 10, y: 150, width: 40, height: 40)
            self.view.addSubview(compass)
            // デフォルトのコンパスを非表示にする
            mapView.showsCompass = false
        }

    
    // 緯度・経度から住所(String型)へ変換
        func convert(lat: CLLocationDegrees, long: CLLocationDegrees) {
            let geocorder = CLGeocoder()
            let location = CLLocation(latitude: lat, longitude: long)
            geocorder.reverseGeocodeLocation(location) { (placeMark, error) in
                if let placeMark = placeMark {
                    if let pm = placeMark.first {
                        if pm.administrativeArea != nil && pm.locality != nil {
                            self.adressString = pm.administrativeArea! + pm.locality!
                        }else{
                            self.adressString = pm.name!
                        }
                    }
                }
            }
        }



    
    
    
    
    
    
    
    //NCMBから読み込み
    func load() {
        let query = NCMBQuery(className: "HomeImage")
        
        query?.findObjectsInBackground({ (result, error) in
            if error != nil{
                
            }else{
                self.cafeInfos = []
                
                let objects = result as! [NCMBObject]
                for cafeInfoObject in objects{
                    
                    let text = cafeInfoObject.object(forKey: "text") as! String
                    let basicInfo = cafeInfoObject.object(forKey: "basicInfo") as! String
                    let introduciton = cafeInfoObject.object(forKey: "introduction") as! String
                    let money = cafeInfoObject.object(forKey: "money") as! String
                    let time = cafeInfoObject.object(forKey: "time") as! String
                    let web = cafeInfoObject.object(forKey: "web") as! String
                    let phoneNumber = cafeInfoObject.object(forKey: "phoneNumber") as! String
                    let imageUrl = cafeInfoObject.object(forKey: "imageUrl") as! Array<Any>
                    let streetAdress = cafeInfoObject.object(forKey: "streetAdress") as! String
                    let geoPoint = cafeInfoObject.object(forKey: "geoPoint") as! NCMBGeoPoint
                    let category = cafeInfoObject.object(forKey: "category") as! String
                    
                    // 投稿の情報を取得
                    
                    let cafeinfo = CafeInfo(objectId: cafeInfoObject.objectId, basicInfo: basicInfo, introduction: introduciton, money: money, phoneNumber: phoneNumber, time: time, web: web, text: text, imageUrl: imageUrl, streetAdress: streetAdress,geoPoint: geoPoint, category: category )
                    self.cafeInfos.append(cafeinfo)
                    self.mapView.reloadInputViews()
                    self.loadPin()
                }
                
            }
        })
    }
    
    //NCMBから読み込み
    func loadPin() {
        let query = NCMBQuery(className: "Map")
        
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                
            }else {
                self.detailId = []
                
                let objects = result as! [NCMBObject]
                for object in objects{
                    
                    let latitude = object.object(forKey: "latitude") as! Double
                    let longitude = object.object(forKey: "longitude") as! Double
                    
                    // 投稿の情報を取得
                    let text = object.object(forKey: "text") as! String
                    let sub  = object.object(forKey: "subtext") as! String
                    
                    self.detailId.append(object.objectId)
                    self.detailtext.append(text)
                    self.detailsub.append(sub)
                    self.latitudes.append(latitude)
                    self.longitudes.append(longitude)
                    
                }
                
                
                //複数ピンをfor文を回して立てる
                for i in 0...self.detailId.count{
                    
                    if i == self.detailId.count {
                        break
                    }else {
                        var pointAno3 : MKPointAnnotation = MKPointAnnotation()
                        pointAno3.title = self.detailtext[i]
                        pointAno3.subtitle = self.detailsub[i]
                        let x = self.latitudes[i]
                        let y = self.longitudes[i]
                        pointAno3.coordinate = CLLocationCoordinate2DMake(x, y)
                        self.mapView.addAnnotation(pointAno3)
                        continue
                    }
                    
                }
                
            }
        }
        )}
    
    
    // UILongPressGestureRecognizerのdelegate：ロングタップを検出する
    @IBAction func mapViewDidLongPress(_ sender: UILongPressGestureRecognizer) {
        loadPin()
        // ロングタップ開始
        if sender.state == .began {
        }
        // ロングタップ終了（手を離した）
        else if sender.state == .ended {
            // タップした位置（CGPoint）を指定してMkMapView上の緯度経度を取得する
            let tapPoint = sender.location(in: view)
            let center = mapView.convert(tapPoint, toCoordinateFrom: mapView)
            
            let lonStr = center.longitude
            let latStr = center.latitude
            
            latitude = latStr
            longitude = lonStr
            
            new = false
            // 新規でピンを定義する
            pointAno.title = "タイトル"
            //pointAno.subtitle = "サブタイトル"
            annotationList.append(pointAno)
            // ロングタップを検出した位置にピンを立てる
            pointAno.coordinate = center
            mapView.addAnnotation(pointAno)
        }
    }
    
    
    // 地図の種類を変更
        @IBAction func changeMaptype(_ sender: Any) {
            switch (sender as AnyObject).selectedSegmentIndex {
            case 0:
                mapView.mapType = .standard
            case 1:
                mapView.mapType = .satellite
            case 2:
                mapView.mapType = .hybrid
            default:
                mapView.mapType = .standard
            }
        }
    
    @IBAction func toPost() {
            if adressString == "" || latitude == nil || longitude == nil {
                SimpleAlert.showAlert(viewController: self, title: "確認", message: "まだ位置情報が定められていません。", buttonTitle: "OK")
            } else {
                self.performSegue(withIdentifier: "toPost", sender: nil)
            }
        }
        
    
    


    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAdd" {
            let addVC = segue.destination as! AddViewController
            addVC.latitude = latitude
            addVC.longitude = longitude
        }else if segue.identifier == "toDetail"{
            let detailVC = segue.destination as! MapDetailViewController
            detailVC.nextTitle = self.nextTitle
            detailVC.nextText = self.nextText
            
        }else{
            let postVC = segue.destination as! PostViewController
            postVC.placeLatitude = latitude
            postVC.placeLongitude = longitude
            //postVC.adressString = adressString
                
        }
    }
    
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.animatesDrop = false
            pinView?.pinTintColor = UIColor.purple
            let rightImageView = UIImageView()
            print(cafeInfos.count)
            if cafeInfos.count != 0{
                for i in 0...cafeInfos.count - 1 {
                    //                if i == self.cafeInfos.count{
                    //                    break
                    //                }else{
                    print(i)
                    if annotation.title == self.cafeInfos[i].text{
//                        let imageUrl = self.cafeInfos[i].imageUrl
//                        print(imageUrl)
//                        rightImageView.kf.setImage(with: URL(string: imageUrl))
                    }
                    //                }
                    
                    
                }
            }
//            rightImageView.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
//            rightImageView.contentMode = .scaleAspectFit
//            pinView?.leftCalloutAccessoryView = rightImageView
            
            
            pinView?.canShowCallout = true
            let rightButton: AnyObject! = UIButton(type: UIButton.ButtonType.detailDisclosure)
            pinView?.rightCalloutAccessoryView = rightButton as? UIView
        }
        else {
            pinView?.annotation = annotation
        }
        return pinView
    }
    
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        //処理
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture(gestureRecognizer:)))
        
        
        if self.detailId.count != 0{
            for i in 0...self.detailId.count{
                if i == self.detailId.count {
                    break
                }else {
                    if (view.annotation!.title!)! == self.detailtext[i]{
                        
                        self.nextId = self.detailId[i]
                        self.nextText = self.detailtext[i]
                        self.nextTitle = self.detailsub[i]
                        new = true
                    }else{
                        
                    }
                }
            }
        }
        view.addGestureRecognizer(tapGesture)
    }
    
    
    @objc func tapGesture(gestureRecognizer: UITapGestureRecognizer){
        let view = gestureRecognizer.view
        let tapPoint = gestureRecognizer.location(in: view)
        //ピン部分のタップだったらリターン
        if tapPoint.x >= 0 && tapPoint.y >= 0 {
            return
        }
        
//        if new == true{
//            self.performSegue(withIdentifier: "toDetail", sender: nil)
//        }else{
//            self.performSegue(withIdentifier: "toAdd", sender: nil)
//        }
        
    }
    
    
    
}


