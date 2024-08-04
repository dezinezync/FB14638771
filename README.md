# FB14638771

## NSCollectionViewCompositionalLayout with orthogonalScrollingBehavior causes the NSScrollView to report incorrect documentVisibleRect

For a programatically configured NSCollectionView, the `NSScrollView.contentView` which hosts the collection view reports incorrect values in `documentVisibleRect`. 

The attached sample code demonstrates the bug. 

Running the app, scrolling the sections will present the horizontal paging behaviour. Upon right-clicking to show the context menu, you’ll observe the `documentVisibleRect.origin` and `documentVisibleRect.size` are reported incorrectly. 

In the sample code, another layout instance of `NSCollectionViewGridLayout` is implemented. Once uncommented, the grid layout will report the correct `documentVisibleRect`. 

Additionally, if the `NSCollectionLayoutSection.orthogonalScrollingBehavior` is set to `none`, the view will scroll vertically and report the correct `documentVisibleRect.origin`. 

Code being compiled using:
- Version 16.0 beta 4 (16A5211f)
- swift-driver version: 1.112.3 Apple Swift version 6.0 (swiftlang-6.0.0.6.8 clang-1600.0.23.1) 

**OpenRadar**: http://openradar.appspot.com/radar?id=5525942088761344
