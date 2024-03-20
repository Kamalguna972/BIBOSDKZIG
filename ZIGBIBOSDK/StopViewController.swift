//
//  StopViewController.swift
//  ZIGBIBOSDK
//
//  Created by apple on 18/03/24.
//

import UIKit
import CoreLocation
import UserNotifications
//import MQTTClient
struct beaconLogData{
    static var rssi = ""
    static var uuid = ""
    static var minor = ""
    static var major = ""
    static var proximity = ""
    static var range = ""
    static var bleValue = ""
    static var locationValue = ""
    static var macaddress = ""
    static var latLong = ""
    static var bg_location_permission = ""
}

class StopViewController: UIViewController,CLLocationManagerDelegate,UNUserNotificationCenterDelegate {
    @IBOutlet weak var Title_name: UILabel!
    
    @IBOutlet weak var Current_location: UILabel!
    @IBOutlet weak var Current_location_img: UIImageView!
    @IBOutlet weak var SubTitle_name: UILabel!
    @IBOutlet weak var Stop_img: UIImageView!
    static var title = ""
    static var subtitle = ""
    static var mainImage = ""
    static var beaconfound : Bool = false
//    fileprivate var session = MQTTSession()
//    private var transport = MQTTCFSocketTransport()
//    let sessionglobal = MQTTSession()
    var MQTT_HOST = "mqtt.zig-web.com" // or IP address e.g. "192.168.0.194"
    let MQTT_PORT: UInt32 = 1883
    var completion: (()->())?
    var locationManager: CLLocationManager = CLLocationManager()
    
    var startColorHex = "#E00F12" // Green
    var endColorHex = "#ed4c4e"
    var blePermissionValue = "false"
    var locationPermissionValue = "false"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       //ui setup
        Title_name.text = StopViewController.title
        SubTitle_name.text = StopViewController.subtitle
      
        //beacon values
        let clientIdentifiler = "Validationbeacon"
        let uuid = UUID(uuidString:"88b78a0c-34ae-44d0-b30c-84153fec0f9a")!
        let beaconRegion = CLBeaconRegion(uuid: uuid, identifier: clientIdentifiler)
        
        //location permissions
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startMonitoring(for: beaconRegion)  // start scanning
        locationManager.startRangingBeacons(in: beaconRegion) // beacon rangion scanning
        
        configuration()
    }
    override func viewWillAppear(_ animated: Bool) {
        if StopViewController.beaconfound{
            print("beacon founded---->")
        }
        else{
            print("not founded------>")
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Reverse geocoding failed with error: \(error.localizedDescription)")
                return
            }
            
            if let placemark = placemarks?.first {
                // Access the address components from the placemark
                let formattedAddress = "\(placemark.thoroughfare ?? ""), \(placemark.locality ?? ""), \(placemark.administrativeArea ?? "") \(placemark.postalCode ?? ""), \(placemark.country ?? "")"
                print("Current Location Address: \(formattedAddress)")
                self.Current_location.text = formattedAddress
            } else {
                print("No placemarks found for the location.")
            }
        }
    }

    // beacon range:
    internal func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        let loc = manager.location?.coordinate
        _ = loc?.latitude
        _ = loc?.longitude
        print("Beacon Data:",beacons)
        if beacons.count > 0 {
            StopViewController.beaconfound = true
            for beacon in beacons {
                let rssiValue = beacon.rssi
                let major = beacon.major
                let minor = beacon.minor
                let uuid = beacon.uuid
                _ = beacon.proximity
                let intProximity = beacon.proximity.rawValue
                _ = "unknown"
                let meterInt = beacon.accuracy
                updateDistance(beacon.proximity, locationCo: loc!, RssiValue: rssiValue, Meterint: meterInt, major: Int(truncating: major), Minor: Int(truncating: minor), proximityVle: intProximity, uuid: "\(uuid)")
                beaconLogData.rssi = "\(rssiValue)"
                beaconLogData.uuid = "\(uuid)"
                beaconLogData.minor = "\(Int(truncating: minor))"
                beaconLogData.major = "\(Int(truncating: major))"
                beaconLogData.proximity = "\(intProximity)"
                beaconLogData.range = "far"
                beaconLogData.bleValue = "\(blePermissionValue)"
                beaconLogData.locationValue = "\(locationPermissionValue)"
                beaconLogData.macaddress = ""
                //   loggapii.beaconLog()
            }
        } else {
            StopViewController.beaconfound = false
            print(beacons)
        }
        
        
    }
    //update distance for scanning
   private func updateDistance(_ distance: CLProximity,locationCo:CLLocationCoordinate2D,RssiValue:Int,Meterint:Double,major:Int,Minor:Int,proximityVle : Int,uuid : String) {
        beaconLogData.rssi = "\(RssiValue)"
        beaconLogData.proximity = "\(proximityVle)"
        beaconLogData.bleValue = blePermissionValue
        beaconLogData.locationValue = locationPermissionValue
        
        switch distance {
        case .unknown:
            break
        case .far:
            if major == 100 || major == 102 || major == 103{
                print("Beacon Major is \(major)")
                print("Beacon Mainor is \(Minor)")
                if major == 100 && Minor == 1139{
                    StopAndSOSFeature()
                    stopscanning()
                    
                }
            }
        case .near: break
        @unknown default:
            print("_________>default")
            break
        }
    }
    func configuration() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound, .providesAppNotificationSettings]){
            (granted, error) in
            if granted{
                self.scheduleNotification()
            }
            else{
                DispatchQueue.main.async {
                    print("error")
                }
            }
        }
    }
    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Notification Title"
        content.body = "Notification Body"
        content.sound = UNNotificationSound.default

        // Create a trigger for the notification (e.g., after 5 seconds)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        // Create a unique identifier for the notification request
        let requestIdentifier = "NotificationIdentifier"

        // Create the notification request
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)

        // Add the notification request to the notification center
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully.")
            }
        }
    }
    func stopscanning()
    {
        let clientIdentifiler = "Validationbeacon"
        let uuid = UUID(uuidString:"88b78a0c-34ae-44d0-b30c-84153fec0f9a")!
        let beaconRegion = CLBeaconRegion(uuid: uuid, identifier: clientIdentifiler)
        locationManager.stopRangingBeacons(in: beaconRegion)
    }
    func StopAndSOSFeature(){
        let present = Presenter()
       // self.triggerNotificationWith("Stop Request", message: "Your stop request has been delivered to the driver")
        self.scheduleNotification()
    }
//    func mqttfunc()
//    {
//        print(self.MQTT_HOST)
//        self.MQTT_HOST = "mqtt.zig-web.com"
//        print(self.MQTT_HOST)
//        self.session?.delegate = self
//        self.transport.host = self.MQTT_HOST
//        self.transport.port = self.MQTT_PORT
//        self.session?.userName = "iPhone"
//        self.session?.password = "Polgara12ZED2122"
//        self.session!.transport = self.transport
//
//        self.updateUI(for: self.session?.status ?? .created)
//        self.session!.connect() { error in
//            print("connection completed with status \(String(describing: error))")
//
//            if error != nil {
//                self.updateUI(for: self.session?.status ?? .created)
//            } else {
//                self.updateUI(for: self.session?.status ?? .error)
//            }
//        }
//    }
//    private func updateUI(for clientStatus: MQTTSessionStatus) {
//        DispatchQueue.main.async {
//            switch clientStatus {
//            case .connected:
//                    self.publishMessage("STOP", onTopic: "04:e9:e5:16:f6:3d/nfc",topicBool: false)
//            case .connecting,
//                    .created:
//                print("MQTT Failed")
//                break
//            default:
//                print("no")
//                print("MQTT Failed")
//                break
//            }
//        }
//    }
//    private func publishMessage(_ message: String, onTopic topic: String,topicBool: Bool) {
//        session?.publishData(message.data(using: .utf8, allowLossyConversion: false), onTopic: topic, retain: false, qos: .atLeastOnce)
//        if topicBool == true
//        {
//            self.session?.disconnect()
//        }
//        else
//        {
//            var useid =  Int()
//            if UserDefaults.standard.value(forKey: "userIdString") == nil
//            {
//                useid = 0
//            }
//            else
//            {
//                useid = UserDefaults.standard.integer(forKey: "userIdString")
//            }
//            var usernameString = String()
//
//            let userDefaults1 = UserDefaults.standard
//            if userDefaults1.value(forKey: "userName") == nil
//            {
//                usernameString = ""
//            }
//            else
//            {
//                usernameString = userDefaults1.value(forKey: "userName") as! String
//            }
//            let PendingCountint = 0
//            print(PendingCountint)
//            let body: [String: Any] = [
//                "userid": useid,
//                "username": usernameString,
//                "ticketCount": 0,
//                "pending": PendingCountint,
//                "verified": 0
//            ]
//            let jsonData = try! JSONSerialization.data(withJSONObject: body )
//            print("JSONDatavalue------>",jsonData)
//
//           // sudharsn
//           // SendClientPublishMessage("\(String(describing: newjson!))", onTopic: "\(comVar.Bus_serialno)/verify")
//        }
//        //self.session?.disconnect()
//        print("MQTT==>\(message) and topic:\(topic)")
//    }
    func triggerNotificationWith(_ title : String, message : String){
        print("Firing the notification")
        let content = UNMutableNotificationContent()
        // content.title = title;
        content.subtitle = title
        content.body = message
        content.sound = UNNotificationSound.default
        // Deliver the notification in five seconds.
        let requestIdentifier = "SampleRequest"
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 3.0, repeats: false)
        let request = UNNotificationRequest(identifier:requestIdentifier, content: content, trigger: trigger)
        print("Request data---->",request)
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().add(request){(error) in
            
            if (error != nil){
                print(error?.localizedDescription ?? "")
            }
        }
    }
    
}
