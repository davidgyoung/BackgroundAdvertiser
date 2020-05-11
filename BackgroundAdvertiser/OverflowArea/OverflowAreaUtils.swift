//
//  OverflowAreaUtils.swift
//  Advertiser
//
//  Created by David G. Young on 5/7/20.
//  Copyright © 2020 davidgyoung. All rights reserved.
//

import Foundation
import CoreBluetooth

public class OverflowAreaUtils {
    public static let TableOfOverflowServiceUuidStringsByBitPosition = [
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
    private static var _tableOfOverflowServiceUuidsByBitPosition: [CBUUID]? = nil
    public static var TableOfOverflowServiceUuidsByBitPosition: [CBUUID] {
        if _tableOfOverflowServiceUuidsByBitPosition == nil {
            var table: [CBUUID] = []
            for uuidString in TableOfOverflowServiceUuidStringsByBitPosition {
                table.append(CBUUID(string: uuidString))
            }
            _tableOfOverflowServiceUuidsByBitPosition = table
        }
        return _tableOfOverflowServiceUuidsByBitPosition ?? []
    }
    
    
    private static var _bitPostitionForOverflowServiceUuid: [CBUUID:Int]? = nil
    public static var BitPostitionForOverflowServiceUuid: [CBUUID:Int] {
        if _bitPostitionForOverflowServiceUuid == nil {
            var dict: [CBUUID:Int] = [:]
            var index = 0
            for uuid in TableOfOverflowServiceUuidsByBitPosition {
                dict[uuid] = index
                index += 1
            }
            _bitPostitionForOverflowServiceUuid = dict
        }
        return _bitPostitionForOverflowServiceUuid ?? [:]
    }
    
    public static func allOverflowServiceUuids() -> [CBUUID] {
        return TableOfOverflowServiceUuidsByBitPosition
    }
    
    public static func overflowServiceUuidsToBinaryString(overflowUuids: [CBUUID]) -> String {
        var binaryString = ""
        var bitPositions: [Int] = []
        for uuid in overflowUuids {
            if let index = OverflowAreaUtils.BitPostitionForOverflowServiceUuid[uuid] {
                bitPositions.append(index)
            }
        }
        for index in 0...127 {
            if bitPositions.contains(index) {
                binaryString.append("1")
            }
            else {
                binaryString.append("0")
            }
        }
        return binaryString
    }
    
    // Returns nil if the advertisement is not an overflow area dvertisement.  Otherwise, returns a
    // byte arrray indicating which bits are set
    public static func extractOverflowAreaBytes(advertisementData: [String : Any]) -> [UInt8]? {
        if let overflowUuids = advertisementData[CBAdvertisementDataOverflowServiceUUIDsKey] as? [CBUUID] {
            return overflowServiceUuidsToBytes(overflowUuids: overflowUuids)
        }
        return nil
    }

    public static func overflowServiceUuidsToBytes(overflowUuids: [CBUUID]) -> [UInt8] {
        var bytes: [UInt8] = []
        var bitPositions: [Int] = []
        for uuid in overflowUuids {
            let uuidString = uuid.uuidString
            if let index = OverflowAreaUtils.TableOfOverflowServiceUuidStringsByBitPosition.firstIndex(of: uuidString) {
                bitPositions.append(index)
            }
        }
        for byteNumber in 0...15 {
            var byte: UInt8 = 0
            for bitNumber in 0...7 {
                let bitPosition = byteNumber*8+bitNumber
                if bitPositions.contains(bitPosition) {
                    byte = byte | UInt8(2 << (bitNumber-1))
                }
            }
            bytes.append(byte)
        }
        return bytes
    }
    
    public static func bytesToOverflowServiceUuids(bytes: [UInt8]) -> [CBUUID] {
        var cbUuids: [CBUUID] = []
        for byteNumber in 0...15 {
            for bitNumber in 0...7 {
                let bitPosition = byteNumber*8+bitNumber
                if bytes[byteNumber] & UInt8(2 << (bitNumber-1)) != 0 {
                    cbUuids.append(TableOfOverflowServiceUuidsByBitPosition[bitPosition])
                }
            }
        }
        return cbUuids
    }
    
    public static func binaryStringToOverflowServiceUuids(binaryString: String) -> [CBUUID] {
        let binaryCharArray = Array(binaryString)
        var cbUuids: [CBUUID] = []
        for index in 0...127 {
            if binaryCharArray[index] == "1" {
                cbUuids.append(OverflowAreaUtils.TableOfOverflowServiceUuidsByBitPosition[index])
            }
        }
        return cbUuids
    }
    
    public static func test() {
        let pattern1: [UInt8] = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16]
        let pattern2: [UInt8] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
        let pattern3: [UInt8] = [255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255]
        let pattern4: [UInt8] = [0,1,2,4,8,16,32,64,128,255,127,63,31,15,7,3]
        let patterns = [pattern1, pattern2, pattern3, pattern4]
        for pattern in patterns {
            let uuids = bytesToOverflowServiceUuids(bytes: pattern)
            let bytes = overflowServiceUuidsToBytes(overflowUuids: uuids)
            for i in 0...15 {
                if bytes[i] != pattern[i] {
                    NSLog("Failed on pattern \(pattern)")
                }
            }
        }
        NSLog("Tests complete!")
    }
}
