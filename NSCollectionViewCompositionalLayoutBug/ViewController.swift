//
//  ViewController.swift
//  NSCollectionViewCompositionalLayoutBug
//
//  Created by Nikhil Nigade on 03/08/24.
//

import Foundation
import AppKit

// MARK: - ViewController
final class ViewController: NSViewController {
  fileprivate let scrollView = NSScrollView()
  fileprivate let collectionView = NSCollectionView()
  fileprivate let cvmenu = NSMenu()
  
  override func loadView() {
    view = NSView()
    view.frame = CGRectMake(0, 0, 640, 480)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView.allowsEmptySelection = true
    collectionView.allowsMultipleSelection = false
    collectionView.collectionViewLayout = collectionViewLayout()
    collectionView.register(ViewCellItem.self, forItemWithIdentifier: ViewCellItem.identifier)
    
    collectionView.dataSource = self
    
    scrollView.documentView = collectionView
    scrollView.hasVerticalScroller = false
    scrollView.hasHorizontalScroller = true
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(scrollView)
    
    NSLayoutConstraint.activate([
      scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      scrollView.topAnchor.constraint(equalTo: view.topAnchor),
      scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
      scrollView.heightAnchor.constraint(equalTo: view.heightAnchor)
    ])
    
    cvmenu.delegate = self
    collectionView.menu = cvmenu
  }
  
  func collectionViewLayout() -> NSCollectionViewLayout {
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .absolute(480)
    )
    
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: itemSize,
      subitems: [item]
    )
    
    let section = NSCollectionLayoutSection(group: group)
    // Changing this to `none` also reports the correct content offset
    section.orthogonalScrollingBehavior = .groupPagingCentered

    let config = NSCollectionViewCompositionalLayoutConfiguration()
    config.scrollDirection = .horizontal
    config.interSectionSpacing = 10
    
    let layout = NSCollectionViewCompositionalLayout(section: section)
    
    return layout
    /*
     * Uncomment the following after commenting out the above section.
     * Observation: correct content offset is reported.
     */
//    let layout = NSCollectionViewGridLayout()
//    layout.maximumNumberOfRows = 1
//    layout.maximumNumberOfColumns = .max
//    layout.minimumInteritemSpacing = 10
//    layout.minimumItemSize = CGSize(width: view.bounds.width, height: 480)
//    layout.maximumItemSize = CGSize(width: view.bounds.width, height: 480)
//    
//    return layout
  }
}

// MARK: - NSCollectionViewDataSource
extension ViewController: NSCollectionViewDataSource {
  func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
    let item: ViewCellItem! = collectionView.makeItem(withIdentifier: ViewCellItem.identifier, for: indexPath) as? ViewCellItem
    
    item.view.wantsLayer = true
    item.view.layer?.backgroundColor = NSColor.red.withAlphaComponent(CGFloat((indexPath.item + 1)) * 0.1).cgColor
    
    return item
  }
  
  func numberOfSections(in collectionView: NSCollectionView) -> Int {
    1
  }
  
  func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
    10
  }
}

// MARK: - NSMenuDelegate
extension ViewController: NSMenuDelegate {
  func menuNeedsUpdate(_ menu: NSMenu) {
    menu.removeAllItems()
    
    let offset = scrollView.documentVisibleRect.origin
    let size = scrollView.documentVisibleRect.size
    
    menu.addItem(NSMenuItem(title: "offset: \(offset)", action: nil, keyEquivalent: ""))
    menu.addItem(NSMenuItem(title: "size: \(size)", action: nil, keyEquivalent: ""))
  }
}

// MARK: - ViewCell
final class ViewCellItem: NSCollectionViewItem {
  static let identifier = NSUserInterfaceItemIdentifier("ViewCellItem")
}
