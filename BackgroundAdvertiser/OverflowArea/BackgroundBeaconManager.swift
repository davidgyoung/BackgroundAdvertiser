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
    public var debugLoggingEnabled = false
    public var bytePosition = 8
    public var matchingByte: UInt8 = 0xaa
    public var hammingBitsToDecode = 47 // 7 bits are added for a 40 bit message (4 byte major minor + matching byte = 5 bytes or 40 bits)
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
    private var beaconBytes: [UInt8]? = nil

    private init() {
    }

    public func extractBeaconBytes(peripheral: CBPeripheral, advertisementData: [String : Any], countToExtract: Int) -> [UInt8]? {
        let start = Date().timeIntervalSince1970
        var payload: [UInt8]? = nil
        if let overflowAreaBytes = OverflowAreaUtils.extractOverflowAreaBytes(advertisementData: advertisementData) {
            var buffer = overflowAreaBytes
            buffer.removeFirst(bytePosition)
            var bitBuffer = HammingEcc().bytesToBits(buffer)
            bitBuffer.removeLast(bitBuffer.count-hammingBitsToDecode)
            if let goodBits = HammingEcc().decodeBits(bitBuffer) {
                let bytes = HammingEcc().bitsToBytes(goodBits)
                if (bytes[0] == matchingByte) {
                    payload = bytes
                    payload?.removeFirst()
                }
                else {
                    if debugLoggingEnabled {
                        NSLog("This is not our overflow area advert")
                    }
                }
            }
            else {
                if debugLoggingEnabled {
                    NSLog("Overflow area advert does not have our beacon data, or it is corrupted")
                }
            }
        }
        if debugLoggingEnabled {
            print("extraction took \(Date().timeIntervalSince1970-start) secs")
        }
        return payload
    }

    public func stopAdvertising() {
        peripheralManager.stopAdvertising()
    }

    public func startAdvertising(beaconBytes: [UInt8]) {
        self.beaconBytes = beaconBytes
        // we set the first bit to make it stlll work in the foreground when that bit comes out as a regular service advert
        let overflowAreaBytes: [UInt8] = [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
        var overflowAreaBits = HammingEcc().bytesToBits(overflowAreaBytes)
        
        var bytesToEncode: [UInt8] = []
        bytesToEncode.append(matchingByte)
        bytesToEncode.append(contentsOf: beaconBytes)
        let encodedBits = HammingEcc().encodeBits(HammingEcc().bytesToBits(bytesToEncode))
        self.hammingBitsToDecode = encodedBits.count
        var index = 0
        for bit in encodedBits {
            overflowAreaBits[bytePosition*8+index] = bit
            index += 1
        }
        if debugLoggingEnabled {
            var bitString = ""
            for i in 0...127 {
                bitString.append("\(overflowAreaBits[i])")
            }
            NSLog("emitting overflow area advertisement \(bitString)")
        }

        let adData = [CBAdvertisementDataServiceUUIDsKey : OverflowAreaUtils.bitsToOverflowServiceUuids(bits: overflowAreaBits)]
        peripheralManager.stopAdvertising()
        peripheralManager.startAdvertising(adData)
    }


}
