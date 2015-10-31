//
//  PageCollectionViewLayout.swift
//  PageCollectionViewLayout
//
//  Created by Peter Ina on 10/30/15.
//  Copyright © 2015 Peter Ina. All rights reserved.
//

import UIKit

/// Limitations
//  - only supports 1 section at the moment.
//  - only supports .Horizontal scrolling at the moment.
//  - at certain sizes, the first item isn't positioned correctly.

public class PageCollectionViewLayout: UICollectionViewFlowLayout {
    
    private var safeCollectionView: UICollectionView {
        guard let collectionView = collectionView else {
            fatalError("no collection view found")
        }
        
        return collectionView
    }
    
    // How much is the view scaled down for a given screen. 1.0 == 100% of the bounds - any section insets
    public let scaleFactor: CGFloat = 1.0
    
    private var pageWidth: CGFloat {
        return floor(safeCollectionView.bounds.size.width * scaleFactor) - sectionInset.totalHorizontalEdgeInset
    }
    
    private var pageHeight: CGFloat {
        return floor(safeCollectionView.bounds.size.height * scaleFactor) - sectionInset.totalVerticalEdgeInset
    }
    
    public override init() {
        super.init()
        
        scrollDirection = .Horizontal
        minimumInteritemSpacing = 10
        registerClass(PageControlDecorationReusableView.self, forDecorationViewOfKind: PageControlDecorationReusableView.kind)


    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareLayout() {
        // super.prepareLayout() //causes loop in viewDidLayoutSubviews.
        itemSize = CGSizeMake(pageWidth, pageHeight)

        setupLayout()
    }
    
    public override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var attributesArray: [UICollectionViewLayoutAttributes] = super.layoutAttributesForElementsInRect(rect)!.map { ($0.copy() as! UICollectionViewLayoutAttributes) } // Resolves runtime warning from CollectionView regarding cache and copying orginal attributes.
        
        // Add decoration to the view. In this case its a UIPageControl
        let pageControlDecorationIndexPath = NSIndexPath(forItem: 0, inSection: 0)
        let pageControlDecorationAttributes =  PageCollectionViewLayoutAttributes(forDecorationViewOfKind: PageControlDecorationReusableView.kind, withIndexPath: pageControlDecorationIndexPath)
        updatePageControlAttributes(pageControlDecorationAttributes)
        attributesArray.append(pageControlDecorationAttributes) // Add to the attributes array
        
        for attributes: UICollectionViewLayoutAttributes in attributesArray {
            if attributes.representedElementCategory != .Cell {
                continue
            }
            let frame = attributes.frame
            let distance = abs(safeCollectionView.contentOffset.x + safeCollectionView.contentInset.left - frame.origin.x)
            let scale = scaleFactor * min(max(1 - distance / (collectionView!.bounds.width), 0.75), 1)
            attributes.transform = CGAffineTransformMakeScale(scale, scale)
            
        }
        
        return attributesArray
        
    }
    
    public override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    public override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        let rectBounds: CGRect = safeCollectionView.bounds
        let halfWidth: CGFloat = rectBounds.size.width * CGFloat(0.50)
        let proposedContentOffsetCenterX: CGFloat = proposedContentOffset.x + halfWidth
        
        let proposedRect: CGRect = safeCollectionView.bounds
        
        let attributesArray: [UICollectionViewLayoutAttributes] = layoutAttributesForElementsInRect(proposedRect)!.map { ($0.copy() as! UICollectionViewLayoutAttributes) }
        
        var candidateAttributes:UICollectionViewLayoutAttributes?
        
        for layoutAttributes in attributesArray {
            
            if layoutAttributes.representedElementCategory != .Cell {
                continue
            }
            
            if candidateAttributes == nil {
                candidateAttributes = layoutAttributes
                continue
            }
            
            if fabsf(Float(layoutAttributes.center.x) - Float(proposedContentOffsetCenterX)) < fabsf(Float(candidateAttributes!.center.x) - Float(proposedContentOffsetCenterX)) {
                candidateAttributes = layoutAttributes
            }
        }
        
        if attributesArray.count == 0 {
            return CGPoint(x: proposedContentOffset.x - halfWidth * 2,y: proposedContentOffset.y)
        }
        
        return CGPoint(x: candidateAttributes!.center.x - halfWidth, y: proposedContentOffset.y)
        
    }
    
    public override func layoutAttributesForDecorationViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        
        if let decAttributes = layoutAttributesForDecorationViewOfKind(PageControlDecorationReusableView.kind, atIndexPath: indexPath) {
            updatePageControlAttributes(decAttributes as! PageCollectionViewLayoutAttributes)
            return decAttributes
        }
        
        return nil
    }
    
    private func setupLayout() {
        
        itemSize = CGSizeMake(pageWidth, pageHeight)
        
        safeCollectionView.showsHorizontalScrollIndicator = false
        safeCollectionView.decelerationRate = UIScrollViewDecelerationRateFast
        safeCollectionView.contentInset = UIEdgeInsets(top: 0, left: collectionView!.bounds.width / 2 - (pageWidth / 2), bottom: 0, right: safeCollectionView.bounds.width / 2 - (pageWidth / 2))
        
    }
    
    private func updatePageControlAttributes(attributes: PageCollectionViewLayoutAttributes) {
        
        let indexPathsForVisibleItems = safeCollectionView.indexPathsForVisibleItems()
        let numberOfPages =  safeCollectionView.numberOfItemsInSection(0)
        
        if let index = indexPathsForVisibleItems.first {
            attributes.currentPage = index.item
        }
        
        let currentBounds = collectionView!.bounds
        let contentOffset = collectionView!.contentOffset
        
        let frame = CGRect(x:0, y: currentBounds.maxY - 40, width: (collectionView?.bounds.width)!, height: 40)
        
        attributes.frame = frame
        attributes.zIndex = Int.max
        attributes.hidden = false
        attributes.center = CGPointMake((collectionView?.center.x)! + contentOffset.x, frame.midY)
        attributes.numberOfPages = numberOfPages
        
    }
    
}

// MARK: Extensions for common tasks that help.
public extension UICollectionViewFlowLayout {
    
    public func isValidOffset(offset: CGFloat) -> Bool {
        return (offset >= CGFloat(minContentOffset) && offset <= CGFloat(maxContentOffset))
    }
    
    public var minContentOffset: CGFloat {
        return -CGFloat(collectionView!.contentInset.left)
    }
    
    public var maxContentOffset: CGFloat {
        return CGFloat(minContentOffset + collectionView!.contentSize.width - itemSize.width)
    }
    
    public var snapStep: CGFloat {
        return itemSize.width + minimumLineSpacing;
    }
}

public extension UIEdgeInsets {
    public var totalHorizontalEdgeInset: CGFloat {
        return left + right
    }
    
    public var totalVerticalEdgeInset: CGFloat {
        return top + bottom
    }
}

