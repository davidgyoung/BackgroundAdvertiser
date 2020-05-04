# Background Advertiser iOS

This is a bare bones iOS app to demonstrate how BLE service advertising works in backgrounded apps.

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

