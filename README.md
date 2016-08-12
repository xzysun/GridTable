# GridTable
An Excel-liked grid table for Objective-C

- Drawing view based on ```UICollectionView``` with the benefits of reusing cells
- Support fixed rows and fixed columns
- Support background colors, selected state, borders

## Usage
Create a ```GTTableView``` instance and add it to your view with a proper frame

Implements the ```GTTableViewDelegat``` protocol to  handle custom cell content and selection events

Convert your data into ```GTTableInfo``` object and set it to your table


## Thanks
Inspired from [BidirectionalCollectionViewLayout](https://github.com/akashraje/BidirectionalCollectionViewLayout) for the fixed rows parts

## License

GridTable is released under a MIT License. See LICENSE file for details.