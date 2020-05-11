//
//  BackgroundBeacon.swift
//
//  Created by David G. Young on 5/9/20.
//  Copyright © 2020 David G. Young, all rights reserved.
//  Licensed under Apache 2
//

import Foundation
import CoreBluetooth

class BackgroundBeaconManager {
    public static let shared = BackgroundBeaconManager()
    public var matchingByte: UInt8 = 0xaa
    private var _peripheralManager: CBPeripheralManager?
    public var peripheralManager: CBPeripheralManager {
        get {
            if let manager = _peripheralManager {
                return manager
            }
            else {
                let manager = CBPeripheralManager.init(delegate: nil, queue: nil)
                _peripheralManager = manager
                return manager
            }
        }
        set {
            _peripheralManager = newValue
        }
        
    }
    private var rotationState = 0
    private var beaconBytes: [UInt8]? = nil
    private var rotate = false
    private var rotationStopRequested = false    
    public let CollisionAvoider = OverflowAreaCollisionAvoider.shared
    public var rotationPeriodSecs = 5.0

    private init() {
    }

    public func extractBeaconBytes(peripheral: CBPeripheral, advertisementData: [String : Any], countToExtract: Int) -> [UInt8]? {
        let start = Date().timeIntervalSince1970
        var payload: [UInt8]? = nil
        if let overflowAreaBytes = OverflowAreaUtils.extractOverflowAreaBytes(advertisementData: advertisementData) {
            payload = CollisionAvoider.extractPayload(overflowAreaBytes: overflowAreaBytes, matchingByte: matchingByte, payloadSize: countToExtract, deviceId: peripheral.identifier.uuidString)
        }
        print("extraction took \(Date().timeIntervalSince1970-start) secs")
        return payload
    }

    
    public func startAdvertising(beaconBytes: [UInt8], rotate: Bool = true) {
        self.beaconBytes = beaconBytes
        if rotate {
            self.rotationState = 0
            let alreadyRotating = self.rotate
            if !alreadyRotating {
                self.rotate = true
                Timer.scheduledTimer(withTimeInterval: rotationPeriodSecs, repeats: true) { timer in
                    if self.rotationStopRequested {
                        timer.invalidate()
                        self.rotationStopRequested = false
                        self.rotate = false
                        return
                    }
                    self.rotationState = (self.rotationState+1) % self.CollisionAvoider.numberOfPositions
                    DispatchQueue.main.async {
                        self.peripheralManager.stopAdvertising()
                        self.startAdvertisingWithoutRotation(beaconBytes: beaconBytes)
                    }
                }
            }
        }
        else {
            rotationState = 0
            if rotate {
                rotationStopRequested = true
            }
        }
        startAdvertisingWithoutRotation(beaconBytes: beaconBytes)
    }

    public func stopAdvertising() {
        if rotate {
            self.rotationStopRequested = true
        }
        peripheralManager.stopAdvertising()
    }

    // rotation should be 0 or 1
    func startAdvertisingWithoutRotation(beaconBytes: [UInt8]) {
        // Convert major and minor to a four byte array
        let payload = beaconBytes
        let overflowAreaBytes = CollisionAvoider.shiftAdvertisement(matchingByte: matchingByte, payloadToAdvertise: payload, position: rotationState)
        let hexString = String(format: "%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X", overflowAreaBytes[0],overflowAreaBytes[1],overflowAreaBytes[2],overflowAreaBytes[3],overflowAreaBytes[4],overflowAreaBytes[5],overflowAreaBytes[6],overflowAreaBytes[7],overflowAreaBytes[8],overflowAreaBytes[9],overflowAreaBytes[10],overflowAreaBytes[11],overflowAreaBytes[12],overflowAreaBytes[13],overflowAreaBytes[14],overflowAreaBytes[15])
        NSLog("emitting overflow area advertisement \(hexString)")

        let adData = [CBAdvertisementDataServiceUUIDsKey : OverflowAreaUtils.bytesToOverflowServiceUuids(bytes: overflowAreaBytes)]
        peripheralManager.startAdvertising(adData)
    }


}
