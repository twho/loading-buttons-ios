# Loading Buttons
A collection of loading buttons and their styling written in Swift.

[![Generic badge](https://img.shields.io/badge/Swift-5.0-orange.svg)](https://shields.io/) [![Generic badge](https://img.shields.io/badge/iOS-11.0+-blue.svg)](https://shields.io/)  [![Generic badge](https://img.shields.io/badge/Version-0.1.3-orange.svg)](https://shields.io/)  [![Generic badge](https://img.shields.io/badge/platform-ios-green.svg)](https://shields.io/) 

You may see the following [Medium](https://medium.com/) article for detailed explanation of creating loading buttons.

- [Create Loading Buttons in iOS using Swift](https://medium.com/@twho/create-loading-buttons-in-ios-using-swift-63ec77eebda?sk=8f69e9a7760cabacde096c34cc416f95)

| Light mode |  Dark mode |
|:--:| :--:|
| <img src="gif/overview-light.gif" alt="Overview" width="240"/> | <img src="gif/overview-dark.gif" alt="Overview Dark" width="240"/>  | 

## Key Features
- The example gives you **9** choices of loading indicators with the loading button. 
- The **IndicatorProtocol** clearly defines the functions and properties. You can refer to it and customize your own.
- The **LoadingButton** class is made to be **open**, from which you can easily inherit and create your own.

## Requirements
- Swift 5.0
- iOS 11.0+

## Installation
### CocoaPods
LoadingButtons project is available via [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

```
$ pod 'MHLoadingButton'
```

### Swift Package Manager
Add LoadingButtons as dependency in your `Package.swift`

```swift
import PackageDescription

let package = Package(
    name: "YourPackage",
    dependencies: [
        .Package(url: "https://github.com/twho/loading-buttons-ios.git", majorVersion: 0),
    ]
)
```

If you don't use CocoaPods or Swift Package Manager, you can download the entire project then import all the source files and use them in your project.

## Usage
### Declaration
```swift
// The frame is default to zero. You need to use AutoLayout to resize it. 
// Otherwise, you can specify the frame in initializer.
if #available(iOS 13.0, *) {
    // This is the new initializer for iOS 13 dark/light mode. 
    // The syste colors will be used.
    btnLoading = LoadingButton(text: "Button", buttonStyle: .outline) // Outlined button
    btnLoading = LoadingButton(text: "Button", buttonStyle: .fill)    // Filled button
} else {
    // Custom color initializer
    btnLoading = LoadingButton(text: "Button", textColor: .black, bgColor: .white)
}

```
### System Default 
```swift
btnLoading.indicator = UIActivityIndicatorView()
```
| Light mode |  Dark mode |
|:--:| :--:|
| <img src="gif/sysdefault-light.gif" alt="System Default" width="350"/> | <img src="gif/sysdefault-dark.gif" alt="System Default Dark" width="350"/> | 

### Material Design
```swift
btnLoading.indicator = MaterialLoadingIndicator(color: .gray)
```
| Light mode |  Dark mode |
|:--:| :--:|
| <img src="gif/materialdesign-light.gif" alt="Material Design" width="350"/> | <img src="gif/materialdesign-dark.gif" alt="Material Design Dark" width="350"/> | 

### Ball Pulse
```swift
btnLoading.indicator = BallPulseSyncIndicator(color: .gray)
```
| Light mode |  Dark mode |
|:--:| :--:|
| <img src="gif/ballpulse-light.gif" alt="Ball Pulse" width="350"/> | <img src="gif/ballpulse-dark.gif" alt="Ball Pulse Dark" width="350"/> | 

### Ball Pulse Sync
```swift
btnLoading.indicator = BallSpinFadeIndicator(color: .gray)
```
| Light mode |  Dark mode |
|:--:| :--:|
| <img src="gif/ballpulsesync-light.gif" alt="Ball Pulse Sync" width="350"/> | <img src="gif/ballpulsesync-dark.gif" alt="Ball Pulse Sync Dark" width="350"/> | 

### Ball Spin
```swift
btnLoading.indicator = LineScalePulseIndicator(color: .gray)
```
| Light mode |  Dark mode |
|:--:| :--:|
| <img src="gif/ballspin-light.gif" alt="Ball Spin" width="350"/> | <img src="gif/ballspin-dark.gif" alt="Ball Spin Dark" width="350"/> | 

### Line Scale
```swift
btnLoading.indicator = LineScaleIndicator(color: .gray)
```
| Light mode |  Dark mode |
|:--:| :--:|
| <img src="gif/linescale-light.gif" alt="Line Scale" width="350"/> | <img src="gif/linescale-dark.gif" alt="Line Scale Dark" width="350"/> | 

### Line Scale Pulse
```swift
btnLoading.indicator = BallPulseIndicator(color: .gray)
```
| Light mode |  Dark mode |
|:--:| :--:|
| <img src="gif/linescalepulse-light.gif" alt="Line Scale Pulse" width="350"/> | <img src="gif/linescalepulse-dark.gif" alt="Line Scale Pulse Dark" width="350"/> | 

### Ball Beat
```swift
btnLoading.indicator = BallBeatIndicator(color: .gray)
```
| Light mode |  Dark mode |
|:--:| :--:|
| <img src="gif/ballbeat-light.gif" alt="Ball Beat" width="350"/> | <img src="gif/ballbeat-dark.gif" alt="Ball Beat Dark" width="350"/> | 

### Line Spin
```swift
btnLoading.indicator = LineSpinFadeLoader(color: .gray)
```
| Light mode |  Dark mode |
|:--:| :--:|
| <img src="gif/linespin-light.gif" alt="Line Spin" width="350"/> | <img src="gif/linespin-dark.gif" alt="Line Spin Dark" width="350"/> | 

## Credits
* [Material Design](https://material.io/design/)
* [Material Design Widgets Lite](https://github.com/twho/material-design-widgets-lite-ios)
* [Le Van Nghia](https://github.com/sharad-paghadal/MaterialKit/tree/master/Source)
* [ninjaprox](https://github.com/ninjaprox/NVActivityIndicatorView)
