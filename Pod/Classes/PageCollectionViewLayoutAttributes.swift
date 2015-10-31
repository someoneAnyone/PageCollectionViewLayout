//
//  PageCollectionViewLayoutAttributes.swift
//  PageCollectionViewLayout
//
//  Created by Peter Ina on 10/30/15.
//  Copyright © 2015 Peter Ina. All rights reserved.
//

import UIKit

public class PageCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    public var numberOfPages: Int = 0
    public var currentPage: Int = 0
    
    // MARK: NSCopying
    public override func copyWithZone(zone: NSZone) -> AnyObject {
        
        let copy = super.copyWithZone(zone) as! PageCollectionViewLayoutAttributes
        copy.numberOfPages = self.numberOfPages
        copy.currentPage = self.currentPage
        return copy
    }
    
    public override func isEqual(object: AnyObject?) -> Bool {
        
        if let rhs = object as? PageCollectionViewLayoutAttributes {
            if currentPage != rhs.currentPage {
                return false
            }
            return super.isEqual(object)
        } else {
            return false
        }
    }
}
