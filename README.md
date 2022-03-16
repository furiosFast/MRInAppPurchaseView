# MRFilteredLocations

[![SPM ready](https://img.shields.io/badge/SPM-ready-orange.svg)](https://swift.org/package-manager/)
![Platform](https://img.shields.io/badge/platforms-iOS%2013.0-F28D00.svg)
[![Swift](https://img.shields.io/badge/Swift-5.0-orange.svg)](https://swift.org)
[![Xcode](https://img.shields.io/badge/Xcode-12.5-blue.svg)](https://developer.apple.com/xcode)
[![License](https://img.shields.io/cocoapods/l/Pastel.svg?style=flat)](https://github.com/furiosFast/MRFilteredLocations/blob/master/LICENSE)
[![Twitter](https://img.shields.io/badge/twitter-@FastDevsProject-blue.svg?style=flat)](https://twitter.com/FastDevsProject)

Easy way to search a location (offline DB) in a simple UITableViewController

<p align="center" width="100%">
    <img src="https://github.com/furiosFast/MRFilteredLocations/blob/master/Assets/screen.gif?raw=true">
</p>
    
## Requirements

- iOS 13.0+
- Xcode 12.5+
- Swift 5+

## Installation

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. It is in early development, but MRFilteredLocations does support its use on supported platforms.

Once you have your Swift package set up, adding MRFilteredLocations as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/furiosFast/MRFilteredLocations.git", from: "1.0.0")
]
```

### Manually

If you prefer not to use any of the aforementioned dependency managers, you can integrate MRFilteredLocations into your project manually.

## Usage

### Initialization

```swift
import MRFilteredLocations

class ViewController: UIViewController, MRFilteredLocationsDelegate {

    //MARK: - Delegates
    func didSelectRowAt(tableView: UITableView, indexPath: IndexPath, filteredLocation: [Location]) {
        let sl = filteredLocation[indexPath.row]
        ...
    }

    func swipeDownDismiss(controller: MRFilteredLocations) {
        controller.navigationController?.popViewController()
    }
    
    
    //MARK: - IBActions
    @IBAction func searchLocationForecast(_ sender: Any) {
        let searchVC = MRFilteredLocations()
        searchVC.delegate = self
        self.navigationController?.pushViewController(searchVC, animated: true)
    }

}
```

## Requirements

MRFilteredLocations has different dependencies and therefore needs the following libraries (also available via SPM):
- [SQLite.swift](https://github.com/stephencelis/SQLite.swift.git) 0.13.0+

It isn't necessary to add the dependencies of MRFilteredLocations, becose with SPM all is do automatically!

## License

MRFilteredLocations is released under the MIT license. See [LICENSE](https://github.com/furiosFast/MRFilteredLocations/blob/master/LICENSE) for more information.
