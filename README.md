[![Swift 5](https://img.shields.io/badge/Swift-5-orange.svg?style=flat)](https://docs.swift.org/swift-book/)
[![License](https://img.shields.io/cocoapods/l/BadgeSwift.svg?style=flat)](/LICENSE.md)
[![Platform](https://img.shields.io/cocoapods/p/LFAlertController.svg?style=flat)](https://www.apple.com/la/ios/ios-15/)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)

# iAlbum
iAlbum is a Universal iOS (iPad & iPhone) application that shows photos in a collection view. Also, open a detailed screen with a smaller picture when you select a photo from the collection. The app connects to [Jsonplaceholder](http://jsonplaceholder.typicode.com/photos) to retrieve the photo information.

## Screenshots

### iPhone
<div align="center">

| Collection | Details |
| ------------- | ------------- |
|   <img src="https://github.com/cosejo/iAlbum/blob/main/iPhone%20Photos%20Collection.png" width="300">  | <img src="https://github.com/cosejo/iAlbum/blob/main/iPhone%20Photo%20Detail.png" width="300">  |

</div>

### iPad

<div align="center">

| Collection | Details |
| ------------- | ------------- |
|     <img src="https://github.com/cosejo/iAlbum/blob/main/iPad%20Photos%20Collection.png" width="400">   |   <img src="https://github.com/cosejo/iAlbum/blob/main/iPad%20Photo%20Detail.png" width="400">  |

</div>

## Technical Details
As this is a showcase project, it does not have any dependencies or third parties. This means all features such as network requests, image downloading, and refresh collection use only Swift Native frameworks.

This app uses MVP as an architectural pattern and has Unit testing for all the presenters in the project and the network manager. The code coverage is at least 97% in the non-UI files.

## Features

- Show Photos Collection
  - Load image from URL
  - Infinite scroll
  - Pull to refresh
- Show Photo Detail

## Requirements
- iOS 14.0+
- Xcode 12.5.1
- Swift 5

## Installation

### Github

```python

#Clone the project
git clone https://github.com/cosejo/iAlbum.git

#Look for the root folder
cd iAlbum/iAlbum

#open the Xcode project
open iAlbum.xcodeproj
```

### Manual
1. Download the project as a zip
2. Go to iAlbum folder
3. Open iAlbum.xcodeproj file

### Testing
1. Go to Test navigator
3. Run the iAlbumTest

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
Distributed under the MIT license. See [MIT](https://choosealicense.com/licenses/mit/) for more information.

## Meta
Carlos Osejo – caosejo@gmail.com

https://github.com/cosejo
