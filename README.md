# Background Advertiser iOS

This is a bare bones iOS app to demonstrate how BLE service advertising works in backgrounded apps.

This app runs in two modes, configurable by the `OperationMode` constant in  AppDelegate.swift:

* DEMO - Demonstrates the ability of two iOS apps to communicate via BLE advertisements when both are in the background
* SequentiallyAdvertiseAllUuids - Used to advertise all UUIDs in the Overflow Area as a means of reverse-engineering how it works.


## SequentiallyAdvertiseAllUuids mode:

The app starts advertising a series of 128-bit service UUIDs one at a time starting from 

```
00000000-0000-0000-0000-000000000000
00000000-0000-0000-0000-000000000001
00000000-0000-0000-0000-000000000002
...
```

And continues forever.  It changes to the next Service UUID advertisement every second.

This is designed so a BLE sniffer or companion app (e.g. on Android) can look for the patterns in its advertisements and see how they change
based on the service UUID advertised.

Here is that companion [Android App](https://github.com/davidgyoung/AdvetiserAnalyzer)

## DEMO mode:

In demo mode, two iOS devices can run the app at the same time and logs will show them each detecting the payload 01 02 03 04 from the other.  This payload
may be changed to transfer data as desired, but the demo app leaves it fixed in this pattern.

The app starts up both a bluetooth central and peripheral.  

The peripheral advertises a 5 byte pattern: AA 01 02 03 04 which is encoded inside the overflow area.  This pattern is shifted into two positions 
within the overflow area to avoid collisions.  The first byte AA is the matching byte.  The remaining bytes are the payload bytes.  Advertising rotates
between two positions every 5 seconds.

The central scans constantly, looking or 128 service UUIDs known to span the whole overflow area.  When a peripheral is detected, the overflow area service 
UUIDs seen are decoded into a 128 bit binary number.  The matching bytes are searched inside the overflow area, and if found, the payload is printed to the screen.

The central side features a collision avoidance system.  The overflow area bits are divided into two banks of 64 bits.  When the pattern is not detected, the bits
in each bank are expected to be 0.  If they are not, this indicates that the remote peripheral is using one of the bits for another purpose, making the bank where it
is found "polluted" and unusable for the purpose of this system.  If the matching pattern is ever found, it is only used if the bank where it is found has been
previously determined to be unpolluted.

The central side also features a periodic local notification (every 60 seconds) to illuminate the screen to allow delivery of overflow area advertisements to a 
backgrounded app.  A future revision may optimize the local notification to only go out if a peripheral scan result has not been receivd in a certain time period.
This would avoid unnecessary notifications if the screen had been illuminated by the user recently for other purposes.


## License

This software is licensed under Apache 2.  See the LICENSE and NOTICE files in this repo for more details.

© 2020 David G. Young https://davidgyoungtech.com

