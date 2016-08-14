# GridTable
An Excel-liked grid table for Objective-C

- Drawing view based on ```UICollectionView``` with the benefits of reusing cells
- Support fixed rows and fixed columns
- Support background colors, selected state, borders

## Usage
Create a ```GTTableView``` instance and add it to your view with a proper frame 
>If you do not extend the view under navbar/tabbar, please disable auto adjust insets by setting ```self.automaticallyAdjustsScrollViewInsets = NO;``` in your view controller

Implements the ```GTTableViewDelegate``` protocol to  handle custom cell content and selection events

Convert your data into ```GTTableInfo``` object and set it to your table

##Requirements
- Xcode 7+
- iOS 8+

## Thanks
Learned a lot from [BidirectionalCollectionViewLayout](https://github.com/akashraje/BidirectionalCollectionViewLayout) and [TSUIKit](https://github.com/Viacheslav-Radchenko/TSUIKit)

## License

GridTable is released under a MIT License. See LICENSE file for details.