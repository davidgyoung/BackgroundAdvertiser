//
//  HammingEcc.swift
//  OverflowAreaBeaconRef
//
//  Based on implementation by Isuru Pamuditha https://medium.com/swlh/hamming-code-generation-correction-with-explanations-using-c-codes-38e700493280
//  Created by David G. Young on 9/9/20.
//  Copyright © 2020 davidgyoungtech. All rights reserved.
//

import Foundation

class HammingEcc {
    func bitsToBytes(_ bits: [UInt8]) -> [UInt8] {
        var bytes: [UInt8] = []
        let byteCount = (bits.count+7)/8
        for byteNum in 0...byteCount-1 {
            var byteValue: UInt8 = 0
            for bit in 0...7 {
                let bitNum = byteNum * 8 + bit
                if (bits[bitNum] == 1) {
                    byteValue |= 1 << bit
                }
            }
            bytes.append(byteValue)
        }
        return bytes
    }
    func bytesToBits(_ bytes: [UInt8]) -> [UInt8] {
        var bits: [UInt8] = []
        for byte in bytes {
            for bit in 0...7 {
                let bitVal =  (byte & (1<<bit) > 0) ? UInt8(1) : UInt8(0)
                bits.append(bitVal)
            }
        }
        return bits
    }
    func encodeBits(_ inputBits: [UInt8]) -> [UInt8] {
        var outputBits = Array<UInt8>()
        var partyBitCount = 0

        var pos = 0
        var position = 0
        while(inputBits.count > (1 << pos - (pos + 1))) {
            partyBitCount += 1
            pos += 1
        }

        var parityPos = 0
        var nonPartyPos = 0
        var i = 0
        while (i < partyBitCount + inputBits.count)
        {
            if (i==(1 << parityPos-1)) {
                outputBits.append(0)
                parityPos += 1
            }
            else
            {
                outputBits.append(inputBits[nonPartyPos])
                nonPartyPos += 1
            }
            i += 1
        }
        
        i = 0;
        while (i < partyBitCount) {
            position = 1 << i
            var s = 0
            var count = 0
            s = position-1;
            while(s < partyBitCount + inputBits.count)
            {
                var j = s
                while (j < s+position) {
                    if (outputBits.count > j && outputBits[j] == 1) {
                        count += 1
                    }
                    j += 1
                }
                s = s + 2*position;
            }
            if (count % 2 == 0) {
                outputBits[position-1] = 0
            }
            else {
                outputBits[position-1] = 1
            }
            i += 1
        }
        var extraParity: UInt8 = 0
        for bit in outputBits {
            extraParity |= bit
        }
        outputBits.append(extraParity)
        return outputBits
    }

    
    func decodeBits(_ inputBits: [UInt8]) -> [UInt8]? {
        var outputBits: [UInt8] = []
        var ss = 0
        var error = 0
        var parityBitsRemoved = 0
        var workBits = inputBits
        let extraParity = workBits.last
        workBits.removeLast()
        let length = workBits.count
        var parityCount = 0
        
        var pos = 0
        while((inputBits.count - parityCount) > (1 << pos - (pos + 1))) {
            parityCount += 1
            pos += 1
        }
        
       // checking whether there are any errors
        var i = 0
        while (i < parityCount)
        {
            var count = 0
            let position = 1 << i
            ss=position-1
            while(ss < length)
            {
                var sss = ss
                while(sss < ss+position)
                {
                    if(sss < workBits.count && workBits[sss] == 1) {
                        count += 1
                    }
                    sss += 1
                }
                ss = ss + 2*position
            }
            if(count % 2 != 0) {
                error+=position;
            }
            i += 1
        }

        // Correct errors
        if (error != 0) {
            if (workBits[error - 1] == 1) {
                workBits[error - 1] = 0
            }
            else  {
                workBits[error - 1] = 1;
            }
            var i = 0
            while (i < length) {
                if (i==(1 << parityBitsRemoved)-1) {
                    parityBitsRemoved += 1
                }
                else {
                    if workBits.count > i {
                        outputBits.append(workBits[i])
                    }
                    else {
                        outputBits.append(0)
                    }
                }
                i += 1
            }
        }
        else {
            var i = 0
            while (i < length) {
                if(i==(1 << parityBitsRemoved)-1) {
                    parityBitsRemoved += 1
                }
                else {
                    outputBits.append(workBits[i])
                }
                i += 1
            }
            
        }
        
        // Finally one more parity check against the corrected bits.  If it doesn't match
        // we know there was more than one error and we cannot correct
        var parity: UInt8 = 0
        for bit in outputBits {
            parity |= bit
        }
        if parity != extraParity {
            print("There were more than two errors.  Cannot decode")
            return nil
        }
        return outputBits
    }    
}

