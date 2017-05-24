# ANE-HapticFeedback

Adobe AIR native extension for Haptic feedback API on iOS.

## Prerequisites

When packaging your app for iOS with AIR 24 or older, you need to point to a directory with iOS 10 SDK (available in Xcode 8) using the `-platformsdk` option in `adt` or via corresponding UI of your IDE:

```
-platformsdk /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS10.0.sdk
```

You need to set Xcode 8 command line tools by going to Xcode Preferences > Locations tab > Command line tools.

Also, a minor modification must be done to the installation of AIR SDK, to use updated `ld` tool:

```
cd AIR_SDK_ROOT/lib/aot/bin/ld64
mv ld64 ld64_air.bak
ln -s /usr/bin/ld ld64
```

## Additions to AIR descriptor

The extension has the following ID:

```xml
<extensions>
    <extensionID>com.digitalstrawberry.ane.hapticfeedback</extensionID>
</extensions>
```

No modifications are needed in InfoAdditions, although specifying the min OS version removes warnings during IPA packaging:

```xml
<InfoAdditions>
    <![CDATA[    
    <key>MinimumOSVersion</key>
    <string>8.0</string>
    ]]>
</InfoAdditions>
```

## API overview

### Native logs

Enable native logs (visible in Xcode console):

```as3
HapticFeedback.setLogEnabled(true);
```

### Creating generators

To create a feedback generator, use one of the provided `HapticFeedback.get*Generator` methods to get a reference to new generator.

```as3
private var _impactGenerator:ImpactFeedbackGenerator;
private var _notificationGenerator:NotificationFeedbackGenerator;
private var _selectionGenerator:SelectionFeedbackGenerator;

...

_impactGenerator = HapticFeedback.getImpactGenerator(ImpactFeedbackStyle.LIGHT); // or MEDIUM, or HEAVY

_notificationGenerator = HapticFeedback.getNotificationGenerator();

_selectionGenerator = HapticFeedback.getSelectionGenerator();
```

### Preparing generator

Preparing the generator can reduce latency when triggering feedback. This is particularly important when trying to match feedback to sound or visual cues. Calling the generator’s `prepare` method puts the Taptic Engine in a prepared state. To preserve power, the Taptic Engine stays in this state for only a short period of time (on the order of seconds), or until you next trigger feedback. For more information, see [official documentation](https://developer.apple.com/reference/uikit/uifeedbackgenerator/2369818-prepare).

```as3
_impactGenerator.prepare();

_notificationGenerator.prepare();

_selectionGenerator.prepare();
```

### Triggering feedback

Each feedback generator subclass has a unique triggering method. To trigger feedback, call the appropriate method:

```as3
_impactGenerator.impactOccurred();

_notificationGenerator.notificationOccurred(NotificationFeedbackType.SUCCESS); // or WARNING, or ERROR

_selectionGenerator.selectionChanged();
```

Note that calling these methods does not play haptics directly. Instead, it informs the system of the event. The system then determines whether to play the haptics based on the device, the application’s state, the amount of battery power remaining, and other factors. As a general rule, trust the system to determine whether it should play feedback. Don't check the device type or app state to conditionally trigger feedback. The system ignores any requests that it cannot fulfill.

### Releasing the generator

It is your responsibility to call `release` on the generator instance that is returned to you. Failing to do so will make the extension hold on to the native reference forever. Releasing the generator lets the Taptic Engine return to its idle state.

```as3
_impactGenerator.release();
_impactGenerator = null;

_notificationGenerator.release();
_notificationGenerator = null;

_selectionGenerator.release();
_selectionGenerator = null;
```

## Changelog

### May 24, 2017 (v1.0.0)

* Public release
