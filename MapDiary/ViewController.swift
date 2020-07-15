//
//  ViewController.swift
//  MapDiary
//
//  Created by Yuki Shinohara on 2020/07/15.
//  Copyright © 2020 Yuki Shinohara. All rights reserved.
//  https://qiita.com/yuta-sasaki/items/3151b3faf2303fe78312

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var locManager: CLLocationManager!
    var mapViewType: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initMap()
        
        locManager = CLLocationManager()
        locManager.delegate = self
        
        locManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            switch CLLocationManager.authorizationStatus() {
            case .authorizedWhenInUse:
                locManager.startUpdatingLocation()
                break
            default:
                break
            }
        }
        //デバイスのサイズを取得→どのデバイスでも同じ位置に配置するためん
        let dispSize: CGSize = UIScreen.main.bounds.size
        let height = Int(dispSize.height)
        let width = Int(dispSize.width)
        
        let trakingBtn = MKUserTrackingButton(mapView: mapView)
        trakingBtn.layer.backgroundColor = UIColor(white: 1, alpha: 0.7).cgColor
        trakingBtn.frame = CGRect(x:40, y:height - 82, width:40, height:40)
        self.view.addSubview(trakingBtn)
        
        // スケールバーの表示
        let scale = MKScaleView(mapView: mapView)
        scale.frame.origin.x = 15
        scale.frame.origin.y = 45
        scale.legendAlignment = .leading
        self.view.addSubview(scale)
        
        // コンパスの表示
        let compass = MKCompassButton(mapView: mapView)
        compass.compassVisibility = .visible
        compass.frame = CGRect(x: width - 50, y: 150, width: 40, height: 40)
        self.view.addSubview(compass)
        // デフォルトのコンパスを非表示にする
        mapView.showsCompass = false
        
        // 地図表示タイプを切り替えるボタンを配置する
        mapViewType = UIButton(type: UIButton.ButtonType.detailDisclosure)
        mapViewType.frame = CGRect(x:width - 50, y:60, width:40, height:40)
        mapViewType.layer.backgroundColor = UIColor(white: 1, alpha: 0).cgColor // 背景色
        mapViewType.layer.borderWidth = 0.5 // 枠線の幅
        mapViewType.layer.borderColor = UIColor.clear.cgColor // 枠線の色
        self.view.addSubview(mapViewType)
        
        mapViewType.addTarget(self, action: #selector(ViewController.mapViewTypeBtnThouchDown(_:)), for: .touchDown)
    }
    
//    delegate設定すると位置が変化する度に下記の関数がCallされる
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let lonStr = (locations.last?.coordinate.longitude.description)!
//        let latStr = (locations.last?.coordinate.latitude.description)!
//        print("緯度: " + lonStr)
//        print("経度: " + latStr)
        
        updateCurrentPos((locations.last?.coordinate)!)
        
//        switch mapView.userTrackingMode {
//        case .follow:
//            mapView.userTrackingMode = .followWithHeading
//            break
//        case .followWithHeading:
//            mapView.userTrackingMode = .none
//            break
//        default:
//            mapView.userTrackingMode = .follow
//            break
//        }
    }
    
    func initMap(){
        // 縮尺
        var region = mapView.region
        region.span.latitudeDelta = 0.02
        region.span.longitudeDelta = 0.02
        mapView.setRegion(region, animated: true)
        
        //現在地の更新
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .followWithHeading
    }
    
    func updateCurrentPos(_ coordinate: CLLocationCoordinate2D){
        var region: MKCoordinateRegion = mapView.region
        region.center = coordinate
        mapView.setRegion(region, animated: true)
    }

    
    @objc internal func mapViewTypeBtnThouchDown(_ sender: Any) {
        switch mapView.mapType {
        case .standard:         // 標準の地図
            mapView.mapType = .satellite
            break
        case .satellite:        // 航空写真
            mapView.mapType = .hybrid
            break
        case .hybrid:           // 標準の地図＋航空写真
            mapView.mapType = .satelliteFlyover
            break
        case .satelliteFlyover: // 3D航空写真
            mapView.mapType = .hybridFlyover
            break
        case .hybridFlyover:    // 3D標準の地図＋航空写真
            mapView.mapType = .mutedStandard
            break
        case .mutedStandard:    // 地図よりもデータを強調
            mapView.mapType = .standard
            break
        }
    }
    
}

///位置情報エラー
//Press command + shift + , in Xcode to open the scheme editor
//Select the Run scheme
//Go to the Options tab
//Check ✅ Allow Location Simulation
//Select a Default Location in the dropdown

///回転
//optionキー

//汎用性高そう
//let dispSize: CGSize = UIScreen.main.bounds.size
//let height = Int(dispSize.height)
//let width = Int(dispSize.width)
