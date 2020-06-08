//
//  AppDelegate.swift
//  Advertiser
//
//  Created by David G. Young on 5/2/20.
//  Copyright © 2020 David G. Young, all rights reserved.
//  Licensed under Apache 2
//

import UIKit
import CoreBluetooth
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CBPeripheralManagerDelegate, CBCentralManagerDelegate, CBPeripheralDelegate, CLLocationManagerDelegate {
    
    let OperationMode = "Demo" // used to do two-way communications of background beaconing using the overflow area
    //let OperationMode = "SequentiallyAdvertiseAllUuids" // used to advertise all service uuids starting with below
    var serviceUuidString = "00000000-0000-0000-0000-000000000000"

    var locationManager: CLLocationManager!
    var service:CBMutableService? = nil
    var peripheralInitialzed = false
    
    var peripheralManager: CBPeripheralManager? = nil
    var centralManager: CBCentralManager? = nil
    let centralQueue = DispatchQueue.global(qos: .userInitiated)
    let peripheralQueue = DispatchQueue.global(qos: .userInitiated)
    var scanStartTime = 0.0
    
    
    
     
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        self.centralManager = CBCentralManager(delegate: self, queue: centralQueue)

        self.peripheralManager = CBPeripheralManager(delegate: self, queue: peripheralQueue, options: [:])
                
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.distanceFilter = 3000.0
        if #available(iOS 9.0, *) {
          locationManager.allowsBackgroundLocationUpdates = true
        } else {
          // not needed on earlier versions
        }
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            
            if let error = error {
                NSLog("error: \(error)")
            }
            
        }
        // start updating location at beginning just to give us unlimited background running time
        self.locationManager.startUpdatingLocation()
        // start ranging beacons to force BLE scans.  If this is not done, delivery of overflow area advertisements will not be made when the
        // app is not in the foreground.  Enabling beacon ranging appears to unlock this background delivery, at least when the screen is on.
        self.locationManager.startRangingBeacons(in: CLBeaconRegion(proximityUUID: UUID(uuidString: "2F234454-CF6D-4A0F-ADF2-F4911BA9FFA6")!, identifier: "dummy-beacon-region"))
        
        extendBackgroundRunningTime()

        if self.OperationMode == "Demo" {
            // You must supply 16 bytes, but you can leave any ones you don't use as 0x00
            startOverflowAdvertising(overflowAreaBytes: [0x01, 0x02, 0x03, 0x04, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])
        }
        return true
    }

    func startOverflowAdvertising(overflowAreaBytes: [UInt8]) {
        let hexString = String(format: "%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X", overflowAreaBytes[0],overflowAreaBytes[1],overflowAreaBytes[2],overflowAreaBytes[3],overflowAreaBytes[4],overflowAreaBytes[5],overflowAreaBytes[6],overflowAreaBytes[7],overflowAreaBytes[8],overflowAreaBytes[9],overflowAreaBytes[10],overflowAreaBytes[11],overflowAreaBytes[12],overflowAreaBytes[13],overflowAreaBytes[14],overflowAreaBytes[15])
        NSLog("emitting overflow area advertisement \(hexString)")

        let adData = [CBAdvertisementDataServiceUUIDsKey : OverflowAreaUtils.bytesToOverflowServiceUuids(bytes: overflowAreaBytes)]
        peripheralManager?.startAdvertising(adData)
    }
    
    func startScanning() {
        scanStartTime = Date().timeIntervalSince1970
        centralManager?.scanForPeripherals(withServices: OverflowAreaUtils.allOverflowServiceUuids(), options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+30.0) {
            NSLog("Restarting scanning")
            self.restartScanning()
        }
    }
    func restartScanning() {
        centralManager?.stopScan()
        DispatchQueue.main.async {
            self.sendNotification()
        }

        
        NSLog("Stopping scanning briefly to reset")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1.0) {
            NSLog("Resuming scanning ")
            self.startScanning()
        }
    }

    func sendNotification() {
            let center = UNUserNotificationCenter.current()
            center.removeAllDeliveredNotifications()
            let content = UNMutableNotificationContent()
            content.title = "Advertiser active"
            content.body = ""
            content.categoryIdentifier = "low-priority"
            //let soundName = UNNotificationSoundName("silence.mp3")
            //content.sound = UNNotificationSound(named: soundName)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
            center.add(request)
    
    }

    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
    }
    func peripheralManager(_ peripheral: CBPeripheralManager, willRestoreState dict: [String : Any]) {
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == CBManagerState.poweredOn {
            if OperationMode == "Demo"  {
                startScanning()
                
            }
        }
    }
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if let overflowAreaBytes = OverflowAreaUtils.extractOverflowAreaBytes(advertisementData: advertisementData) {
            let hexString = String(format: "%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X", overflowAreaBytes[0],overflowAreaBytes[1],overflowAreaBytes[2],overflowAreaBytes[3],overflowAreaBytes[4],overflowAreaBytes[5],overflowAreaBytes[6],overflowAreaBytes[7],overflowAreaBytes[8],overflowAreaBytes[9],overflowAreaBytes[10],overflowAreaBytes[11],overflowAreaBytes[12],overflowAreaBytes[13],overflowAreaBytes[14],overflowAreaBytes[15])
            NSLog("I just read overflow area bytes: \(hexString)")
        }
    }
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
    }
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
    }
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
    }
    
    func incrementServiceUuidString() {
        var newServiceUuidString = ""
        var index = serviceUuidString.count-2
        var carryTheOne = true
        while index >= 0 {
            let startIndex = serviceUuidString.index(serviceUuidString.startIndex, offsetBy: index)
            let endIndex = serviceUuidString.index(startIndex, offsetBy: 2)
            let twoChars = serviceUuidString[startIndex..<endIndex]
            if twoChars.contains("-") {
              newServiceUuidString = "-\(newServiceUuidString)"
              index -= 1
            }
            else {
                var byteVal = Int(twoChars, radix: 16)
                if carryTheOne {
                    if byteVal == 255 {
                        byteVal = 0
                    }
                    else {
                        byteVal = (byteVal ?? 0) + 1
                        carryTheOne = false
                    }
                }
                newServiceUuidString = "\(String(format: "%02X", byteVal ?? 0))\(newServiceUuidString)"
                index -= 2
            }
        }
        serviceUuidString = newServiceUuidString
    }

    func updateAdvertisement() {
        let serviceUuid = CBUUID(string: serviceUuidString)
        peripheralManager?.stopAdvertising()
        let adData = [CBAdvertisementDataServiceUUIDsKey : [serviceUuid]] as [String : Any]
        peripheralManager?.startAdvertising(adData)
    }

    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == CBManagerState.poweredOn {
        }
        else{
        }
        NSLog("Bluetooth power state changed to \(peripheral.state)")
    }

    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
    }
    
    
    
    // MARK: UISceneSession Lifecycle

    var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
    var threadStarted = false
    var threadShouldExit = false
    func extendBackgroundRunningTime() {
      if (threadStarted) {
        // if we are in here, that means the background task is already running.
        // don't restart it.
        return
      }
      threadStarted = true
      NSLog("Attempting to extend background running time")
      
      self.backgroundTask = UIApplication.shared.beginBackgroundTask(withName: "DummyTask", expirationHandler: {
        NSLog("Background task expired by iOS.")
        UIApplication.shared.endBackgroundTask(self.backgroundTask)
      })

    
      var lastRotationTime = 0.0
      var lastLogTime = 0.0
      var rotationCount = 0
      DispatchQueue.global().async {
        let startedTime = Int(Date().timeIntervalSince1970) % 10000000
        NSLog("*** STARTED BACKGROUND THREAD")
        while(!self.threadShouldExit) {
            DispatchQueue.main.async {
                let now = Date().timeIntervalSince1970
                if now - lastRotationTime > 1.0 {
                    if self.peripheralManager?.state == CBManagerState.poweredOn {
                        let state = UIApplication.shared.applicationState
                        if self.OperationMode == "SequentiallyAdvertiseAllUuids" {
                            if state == .background {
                                print("App in Background")
                                lastRotationTime = now
                                NSLog("Advertising \(self.serviceUuidString)")

                                rotationCount += 1
                                self.updateAdvertisement()
                                // This will set all the bits at the same time in little endian order from the first up to rotationCount
                                //self.updateAdvertisementWithBitsSet(count: rotationCount)
                                self.incrementServiceUuidString()
                            }
                        }
                    }
                }

                let backgroundTimeRemaining = UIApplication.shared.backgroundTimeRemaining
                if abs(now - lastLogTime) >= 2.0 {
                    lastLogTime = now
                    if backgroundTimeRemaining < 10.0 {
                      NSLog("About to suspend based on background thread running out.")
                    }
                    if (backgroundTimeRemaining < 200000.0) {
                     NSLog("Thread \(startedTime) background time remaining: \(backgroundTimeRemaining)")
                    }
                    else {
                      //NSLog("Thread \(startedTime) background time remaining: INFINITE")
                    }
                }
            }

            sleep(1)
        }
        self.threadStarted = false
        NSLog("*** EXITING BACKGROUND THREAD")
      }

    }
    func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
    }

}

