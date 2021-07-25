//
//  MapTapSelectViewController.swift
//  Cafe_Original
//
//  Created by Ryosuke Masuko on 2021/07/02.
//  Copyright © 2021 Ryosuke4869. All rights reserved.
//

import UIKit
import MapKit
import NCMB
import CoreLocation
import SVProgressHUD


class MapTapSelectViewController: UIViewController,MKMapViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate, UISearchBarDelegate  {
    
    @IBOutlet var mapView: MKMapView!
    
    var pointAno = [MKPointAnnotation]()
    var latitudes = [Double]()
    var longitudes = [Double]()
    
    var locManager: CLLocationManager!
    
    var cafeInfos = [CafeInfo]()
    
    var selectedGeoPoint = NCMBGeoPoint()
    
    @IBOutlet var longPressGesRec: UILongPressGestureRecognizer!
    
    
    var detailId = [String]()
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
    //var latitudes = [Double]()
    //var longitudes = [Double]()
    var geolatitudes = [Double]()
    var geolongitudes = [Double]()
    var currentLatitude: Double!
    var currentLongitude: Double!
    
    var adressString = ""
    var annotationList = [MKPointAnnotation]()
    @IBOutlet var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        //locationManagerの設定
        setupLocationManager()
        
        //地図の初期化
        setSearchBar()
        initMap()
        setupScaleBar()
        setupCompass()
        //        loadPin()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setSearchBar()
        //        loadPin()
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
    func load(selectedGeoPoint: NCMBGeoPoint?) {
        let query = NCMBQuery(className: "HomeImage")
        
        if let geoPoint = selectedGeoPoint {
            query?.whereKey("geoPoint", equalTo: geoPoint)
        }
        
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
                    
                    let cafeinfo = CafeInfo(objectId: cafeInfoObject.objectId, basicInfo: basicInfo, introduction: introduciton, money: money, phoneNumber: phoneNumber, time: time, web: web, text: text, imageUrl: imageUrl, streetAdress: streetAdress, geoPoint: geoPoint, category: category)
                    self.cafeInfos.append(cafeinfo)
                    self.mapView.reloadInputViews()
                    print(self.cafeInfos)
                    
                }
                
            }
        })
    }
    
    
    
    @IBAction func mapViewDidLongPress(_ sender: UILongPressGestureRecognizer) {
        // ロングタップ開始
        if sender.state == .began {
            print("ロングタップ成功")
            //アノテーション格納リストのピンを
            for i in 0...self.detailId.count{
                if i == self.detailId.count{
                    break
                }else{
                    self.mapView.removeAnnotation(pointAno[i])
                    print("ピンを削除しました。")
                    continue
                }
            }
        }
        // ロングタップ終了（手を離した）
        else if sender.state == .ended {
            let tapPoint = sender.location(in: view)
            let center = mapView.convert(tapPoint, toCoordinateFrom: mapView)
            
            let longitude = center.longitude.description
            let latitude = center.latitude.description
            print("longitude : ",longitude)
            print("latitude : " ,latitude)
            
            let tapCenter = CLLocationCoordinate2D(latitude: Double(latitude)!, longitude: Double(longitude)!)
            let radius:  CLLocationDistance = 500
            let circularRegion = CLCircularRegion(center: tapCenter, radius: radius, identifier: "identifier")
            
            
            //ニフティに登録されている緯度経度をとってくる。
            let query = NCMBQuery(className: "HomeImage")
            query?.findObjectsInBackground({ result, error in
                if error != nil{
                    print("error=",error)
                }else{
                    self.latitudes = []
                    self.longitudes = []
                    self.detailId = []
                    self.detailtext = []
                    self.pointAno = []
                    self.cafeInfos = []
                    for object in result as! [NCMBObject]{
                        let objectId = object.object(forKey: "objectId") as! String
                        let geoPoint = object.object(forKey: "geoPoint") as! NCMBGeoPoint
                        // 投稿の情報を取得
                        let text = object.object(forKey: "text") as! String
                        let basicInfo = object.object(forKey: "basicInfo") as! String
                        let introduciton = object.object(forKey: "introduction") as! String
                        let money = object.object(forKey: "money") as! String
                        let time = object.object(forKey: "time") as! String
                        let web = object.object(forKey: "web") as! String
                        let phoneNumber = object.object(forKey: "phoneNumber") as! String
                        let imageUrl = object.object(forKey: "imageUrl") as! Array<Any>
                        let streetAdress = object.object(forKey: "streetAdress") as! String
                        let category = object.object(forKey: "category") as! String
                        let cafeinfo = CafeInfo(objectId: object.objectId, basicInfo: basicInfo, introduction: introduciton, money: money, phoneNumber: phoneNumber, time: time, web: web, text: text, imageUrl: imageUrl, streetAdress: streetAdress, geoPoint: geoPoint, category: category)
                        
                        //タップした位置の緯度・経度
                        let registerdLocation = CLLocationCoordinate2D(latitude: geoPoint.latitude, longitude: geoPoint.longitude)
                        //タップした位置からの半径内に、緯度、経度が入ってたら、、、
                        if circularRegion.contains(registerdLocation) {
                            //入っていたピンの緯度・経度、objectIDをリストにappend
                            self.detailId.append(objectId)
                            self.latitudes.append(geoPoint.latitude)
                            self.longitudes.append(geoPoint.longitude)
                            self.detailtext.append(text)
                            self.cafeInfos.append(cafeinfo)
                            print("半径内に含まれています。")
                        }
                        
                    }
                    //ピンを立てる
                    for i in 0...self.detailId.count{
                        if i == self.detailId.count{
                            break
                        }else{
                            var searchAnnotation = MKPointAnnotation()
                            searchAnnotation.title = self.detailtext[i]
                            let x = self.latitudes[i]
                            let y = self.longitudes[i]
                            print("x=",x,"y=",y)
                            searchAnnotation.coordinate = CLLocationCoordinate2D(latitude: x, longitude: y)
                            //いきなりピンを立てるのではなく、pointAnoリストにピン情報をappendしていく。
                            self.pointAno.append(searchAnnotation)
                            self.pointAno[i].title = self.detailtext[i]
                            //pointAnoリストのi番目から、読み取ることで、一つひとつfor文でピンを立てている。
                            self.mapView.addAnnotation(self.pointAno[i])
                            self.mapView.selectAnnotation(self.pointAno[i], animated: true)
                            print("pointAnoは",self.pointAno[i])
                            print("objectIdは",self.detailId[i])
                            print("カフェ名は",self.cafeInfos[i].text)
                            continue
                        }
                    }
                }
            })
            //            マップをロングタップしたら呼ばれる関数内で、これを書くと、ニフティに、タップした緯度経度が保存される。
            //            let object = NCMBObject(className: "Map")
            //            object?.setObject(lonStr, forKey: "longitude")
            //            object?.setObject(latStr, forKey: "latitude")
            //            object?.saveInBackground({ error in
            //                if error != nil{
            //                    print(error)
            //                }else{
            //                    print("ニフティクラウドに登録完了")
            //                }
            //            })
            
            print("ロングタップ終了")
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //値渡し
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail"{
            let detailVC = segue.destination as! DetailViewController
            detailVC.homeImageId = cafeInfos[0].objectId
        }
    }
    
    //ピンの見た目を変える
    //ピンを立てたいならMKPinAnotationView　マーカーを立てたいならMKMarkerAnotationView
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil{
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.animatesDrop = true
            pinView?.pinTintColor = UIColor.systemBlue
            pinView?.canShowCallout = true
        }else{
            pinView?.annotation = annotation
            pinView?.canShowCallout = true
        }
        pinView?.canShowCallout = true
        return pinView
    }
    
    //吹き出しをタップした時に起こる関数
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        //処理
        performSegue(withIdentifier: "toDetail", sender: nil)
    }
    
    //ピンをタップしたときに呼ばれる
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture(gestureRecognizer:)))
        //queryでgeoPointが同じカフェを遷移先で表示する
        let coordinate = view.annotation?.coordinate
        selectedGeoPoint = NCMBGeoPoint(latitude: coordinate!.latitude, longitude: coordinate!.longitude)
        load(selectedGeoPoint: selectedGeoPoint)
        
        if self.detailId.count != 0{
            for i in 0...self.detailId.count{
                print("detailtext=",detailtext)
                if i == self.detailId.count {
                    break
                }else {
                    if (view.annotation!.title!)! == self.detailtext[i]{
                        self.nextId = self.detailId[i]
                        self.nextText = self.detailtext[i]
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
        if new == true{
            self.performSegue(withIdentifier: "toDetail", sender: nil)
        }
    }
    
    //マップの背景変更
    @IBAction func changeMapType(_ sender: Any) {
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
    
    
}
