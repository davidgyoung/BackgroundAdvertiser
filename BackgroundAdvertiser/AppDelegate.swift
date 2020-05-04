//
//  AppDelegate.swift
//  Advertiser
//
//  Created by David G. Young on 5/2/20.
//  Copyright © 2020 davidgyoungtech. All rights reserved.
//

import UIKit
import CoreBluetooth
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CBPeripheralManagerDelegate, CBCentralManagerDelegate, CBPeripheralDelegate, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
    var service:CBMutableService? = nil
    var peripheralInitialzed = false
    
    var peripheralManager: CBPeripheralManager? = nil
    var centralManager: CBCentralManager? = nil
    let centralQueue = DispatchQueue.global(qos: .userInitiated)
    let peripheralQueue = DispatchQueue.global(qos: .userInitiated)
    var serviceUuidString = "00000000-0000-0000-0000-000000000000"
    
    // Table of known service UUIDs by position in Apple's proprietary background service advertisement
    let tableOfServiceUuidStringsByBitPosition = [
        "00000000-0000-0000-0000-00000000007C",
        "00000000-0000-0000-0000-000000000037",
        "00000000-0000-0000-0000-00000000006E",
        "00000000-0000-0000-0000-000000000025",
        "00000000-0000-0000-0000-000000000059",
        "00000000-0000-0000-0000-000000000012",
        "00000000-0000-0000-0000-00000000004B",
        "00000000-0000-0000-0000-000000000000",
        "00000000-0000-0000-0000-000000000036",
        "00000000-0000-0000-0000-00000000007D",
        "00000000-0000-0000-0000-000000000024",
        "00000000-0000-0000-0000-00000000006F",
        "00000000-0000-0000-0000-000000000013",
        "00000000-0000-0000-0000-000000000058",
        "00000000-0000-0000-0000-000000000001",
        "00000000-0000-0000-0000-00000000004A",
        "00000000-0000-0000-0000-00000000006C",
        "00000000-0000-0000-0000-000000000027",
        "00000000-0000-0000-0000-00000000007E",
        "00000000-0000-0000-0000-000000000035",
        "00000000-0000-0000-0000-000000000049",
        "00000000-0000-0000-0000-000000000002",
        "00000000-0000-0000-0000-00000000005B",
        "00000000-0000-0000-0000-000000000010",
        "00000000-0000-0000-0000-000000000026",
        "00000000-0000-0000-0000-00000000006D",
        "00000000-0000-0000-0000-000000000034",
        "00000000-0000-0000-0000-00000000007F",
        "00000000-0000-0000-0000-000000000003",
        "00000000-0000-0000-0000-000000000048",
        "00000000-0000-0000-0000-000000000011",
        "00000000-0000-0000-0000-00000000005A",
        "00000000-0000-0000-0000-00000000005D",
        "00000000-0000-0000-0000-000000000016",
        "00000000-0000-0000-0000-00000000004F",
        "00000000-0000-0000-0000-000000000004",
        "00000000-0000-0000-0000-000000000078",
        "00000000-0000-0000-0000-000000000033",
        "00000000-0000-0000-0000-00000000006A",
        "00000000-0000-0000-0000-000000000021",
        "00000000-0000-0000-0000-000000000017",
        "00000000-0000-0000-0000-00000000005C",
        "00000000-0000-0000-0000-000000000005",
        "00000000-0000-0000-0000-00000000004E",
        "00000000-0000-0000-0000-000000000032",
        "00000000-0000-0000-0000-000000000079",
        "00000000-0000-0000-0000-000000000020",
        "00000000-0000-0000-0000-00000000006B",
        "00000000-0000-0000-0000-00000000004D",
        "00000000-0000-0000-0000-000000000006",
        "00000000-0000-0000-0000-00000000005F",
        "00000000-0000-0000-0000-000000000014",
        "00000000-0000-0000-0000-000000000068",
        "00000000-0000-0000-0000-000000000023",
        "00000000-0000-0000-0000-00000000007A",
        "00000000-0000-0000-0000-000000000031",
        "00000000-0000-0000-0000-000000000007",
        "00000000-0000-0000-0000-00000000004C",
        "00000000-0000-0000-0000-000000000015",
        "00000000-0000-0000-0000-00000000005E",
        "00000000-0000-0000-0000-000000000022",
        "00000000-0000-0000-0000-000000000069",
        "00000000-0000-0000-0000-000000000030",
        "00000000-0000-0000-0000-00000000007B",
        "00000000-0000-0000-0000-00000000003E",
        "00000000-0000-0000-0000-000000000075",
        "00000000-0000-0000-0000-00000000002C",
        "00000000-0000-0000-0000-000000000067",
        "00000000-0000-0000-0000-00000000001B",
        "00000000-0000-0000-0000-000000000050",
        "00000000-0000-0000-0000-000000000009",
        "00000000-0000-0000-0000-000000000042",
        "00000000-0000-0000-0000-000000000074",
        "00000000-0000-0000-0000-00000000003F",
        "00000000-0000-0000-0000-000000000066",
        "00000000-0000-0000-0000-00000000002D",
        "00000000-0000-0000-0000-000000000051",
        "00000000-0000-0000-0000-00000000001A",
        "00000000-0000-0000-0000-000000000043",
        "00000000-0000-0000-0000-000000000008",
        "00000000-0000-0000-0000-00000000002E",
        "00000000-0000-0000-0000-000000000065",
        "00000000-0000-0000-0000-00000000003C",
        "00000000-0000-0000-0000-000000000077",
        "00000000-0000-0000-0000-00000000000B",
        "00000000-0000-0000-0000-000000000040",
        "00000000-0000-0000-0000-000000000019",
        "00000000-0000-0000-0000-000000000052",
        "00000000-0000-0000-0000-000000000064",
        "00000000-0000-0000-0000-00000000002F",
        "00000000-0000-0000-0000-000000000076",
        "00000000-0000-0000-0000-00000000003D",
        "00000000-0000-0000-0000-000000000041",
        "00000000-0000-0000-0000-00000000000A",
        "00000000-0000-0000-0000-000000000053",
        "00000000-0000-0000-0000-000000000018",
        "00000000-0000-0000-0000-00000000001F",
        "00000000-0000-0000-0000-000000000054",
        "00000000-0000-0000-0000-00000000000D",
        "00000000-0000-0000-0000-000000000046",
        "00000000-0000-0000-0000-00000000003A",
        "00000000-0000-0000-0000-000000000071",
        "00000000-0000-0000-0000-000000000028",
        "00000000-0000-0000-0000-000000000063",
        "00000000-0000-0000-0000-000000000055",
        "00000000-0000-0000-0000-00000000001E",
        "00000000-0000-0000-0000-000000000047",
        "00000000-0000-0000-0000-00000000000C",
        "00000000-0000-0000-0000-000000000070",
        "00000000-0000-0000-0000-00000000003B",
        "00000000-0000-0000-0000-000000000062",
        "00000000-0000-0000-0000-000000000029",
        "00000000-0000-0000-0000-00000000000F",
        "00000000-0000-0000-0000-000000000044",
        "00000000-0000-0000-0000-00000000001D",
        "00000000-0000-0000-0000-000000000056",
        "00000000-0000-0000-0000-00000000002A",
        "00000000-0000-0000-0000-000000000061",
        "00000000-0000-0000-0000-000000000038",
        "00000000-0000-0000-0000-000000000073",
        "00000000-0000-0000-0000-000000000045",
        "00000000-0000-0000-0000-00000000000E",
        "00000000-0000-0000-0000-000000000057",
        "00000000-0000-0000-0000-00000000001C",
        "00000000-0000-0000-0000-000000000060",
        "00000000-0000-0000-0000-00000000002B",
        "00000000-0000-0000-0000-000000000072",
        "00000000-0000-0000-0000-000000000039"
    ]
 
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
        // start updating location at beginning just to give us unlimited background running time
        self.locationManager.startUpdatingLocation()
        
        extendBackgroundRunningTime()

        return true
    }
    
    
    
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
    }
    func peripheralManager(_ peripheral: CBPeripheralManager, willRestoreState dict: [String : Any]) {
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == CBManagerState.poweredOn {
            centralManager?.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
        }
    }
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
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
    func updateAdvertisementWithBitsSet(count: Int) {
        var services: [CBUUID] = []
        for index in 0...count {
            services.append(CBUUID(string: tableOfServiceUuidStringsByBitPosition[index]))
        }
        peripheralManager?.stopAdvertising()
        let adData = [CBAdvertisementDataServiceUUIDsKey : services] as [String : Any]
        peripheralManager?.startAdvertising(adData)
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

