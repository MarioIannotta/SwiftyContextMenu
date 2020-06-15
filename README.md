<img src="https://raw.githubusercontent.com/MarioIannotta/SwiftyContextMenu/main/Resources/logo.png" alt="SwiftyContextMenu: UIContextMenu backporting with Swifter API"/>

[![Version](https://img.shields.io/cocoapods/v/SwiftyContextMenu.svg?style=flat)](https://cocoapods.org/pods/SwiftyContextMenu)
[![License](https://img.shields.io/cocoapods/l/SwiftyContextMenu.svg?style=flat)](https://cocoapods.org/pods/SwiftyContextMenu)
[![Platform](https://img.shields.io/cocoapods/p/SwiftyContextMenu.svg?style=flat)](https://cocoapods.org/pods/SwiftyContextMenu)

<img src="https://raw.githubusercontent.com/MarioIannotta/SwiftyContextMenu/main/Resources/demo.gif" height="500"/>

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

* iOS 10+

## Installation

ContextMenu is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SwiftyContextMenu'
```

## Usage

```swift
let favoriteAction = ContextMenuAction(title: "Looooooooooooong title",
                                       image: UIImage(named: "heart.fill"),
                                       action: { _ in print("favorite") })
let shareAction = ContextMenuAction(title: "Share",
                                    image: UIImage(named: "square.and.arrow.up.fill"),
                                    action: { _ in print("square") })
let deleteAction = ContextMenuAction(title: "Delete",
                                     image: UIImage(named: "trash.fill"),
                                     tintColor: UIColor.red,
                                     action: { _ in print("delete") })
let actions = [favoriteAction, shareAction, deleteAction]
let contextMenu = ContextMenu(title: "Actions", actions: actions)
button.addContextMenu(contextMenu, for: .tap(numberOfTaps: 1), .longPress(duration: 0.3))
```


## Author

Mario Iannotta, info@marioiannotta.com.

If you like this git you can follow me here or on Twitter [@MarioIannotta](http://www.twitter.com/marioiannotta); sometimes I post interesting stuff. 

## License

ContextMenu is available under the MIT license. See the LICENSE file for more info.

## TODOs:

* [ ] Document all the public stuff
* [ ] Support dark mode
* [ ] Improve the Readme Usage section
* [x] Support dynamic type
