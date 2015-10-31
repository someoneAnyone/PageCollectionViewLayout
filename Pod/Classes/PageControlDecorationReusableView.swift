//
//  PageControlDecorationReusableView.swift
//  PageCollectionViewLayout
//
//  Created by Peter Ina on 10/30/15.
//  Copyright © 2015 Peter Ina. All rights reserved.
//

import UIKit

public protocol PageControlDecorationReusableViewDelegate {
    func pageControlReusableViewDidSelect(view: PageControlDecorationReusableView, index: Int)
}

@IBDesignable
public class PageControlDecorationReusableView: UICollectionReusableView {
    
    public static var kind: String = "PageControlDecorationReusableView"
    
    public var delegate: PageControlDecorationReusableViewDelegate?
    
    @IBInspectable public var numberOfPages: Int {
        set{
            pageControl.numberOfPages = newValue
        }
        get{
            return pageControl.numberOfPages
        }
    }
    
    @IBInspectable public var currentPage: Int {
        set {
            pageControl.currentPage = newValue
        }
        get {
            return pageControl.currentPage
        }
    }
    
    @IBInspectable public var showBlur: Bool = true {
        didSet{
            setupPageControl(showBlur)
        }
    }
    
    private var pageControl: UIPageControl = UIPageControl()
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clearColor()
        
        setupPageControl(showBlur)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        super.applyLayoutAttributes(layoutAttributes)
        
        guard let layoutAttributes = layoutAttributes as? PageCollectionViewLayoutAttributes else {
            return
        }
        
        currentPage = layoutAttributes.currentPage
        numberOfPages = layoutAttributes.numberOfPages
    }
    
    internal func pageControlChanged(pageControl: UIPageControl) {
        delegate?.pageControlReusableViewDidSelect(self, index: pageControl.currentPage)
    }
    
    private func setupPageControl(withBlur: Bool) {
        
        subviews.forEach { $0.removeFromSuperview() }
        
        constraints.forEach { $0.active = false }
        
        print("self: \(self)")
        pageControl.addTarget(self, action: Selector("pageControlChanged:"), forControlEvents: .ValueChanged)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.defersCurrentPageDisplay = true
        
        let blurEffect = UIBlurEffect(style: .Dark)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.translatesAutoresizingMaskIntoConstraints = false
        
        let vibrancyEffect = UIVibrancyEffect(forBlurEffect: blurEffect)
        let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyEffectView.translatesAutoresizingMaskIntoConstraints = false
        vibrancyEffectView.contentView.addSubview(pageControl)
        
        if withBlur {
            addSubview(blurredEffectView)
            addConstraints(setupEffectViewConstraints(blurredEffectView))
        }
        
        pageControl.superview!.addConstraints(setupPageControllConstraints(pageControl))
        
        self.addSubview(vibrancyEffectView)
        self.addConstraints(setupEffectViewConstraints(vibrancyEffectView))
        
    }
    
    private func setupPageControllConstraints(pageControlView: UIPageControl) -> [NSLayoutConstraint] {
        let bottomConstraint = NSLayoutConstraint(item: pageControlView, attribute: .Bottom, relatedBy: .Equal, toItem: pageControlView.superview, attribute: .Bottom, multiplier: 1, constant: 0)
        let centerBottomConstraint = NSLayoutConstraint(item: pageControlView, attribute: .CenterX, relatedBy: .Equal, toItem: pageControlView.superview, attribute: .CenterX, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: pageControlView, attribute: .Width , relatedBy: .Equal, toItem: pageControlView.superview, attribute: .Width ,  multiplier: 1, constant: 0)
        
        
        return [bottomConstraint, centerBottomConstraint, widthConstraint]
    }
    
    private func setupEffectViewConstraints(effectView: UIView) -> [NSLayoutConstraint] {
        
        // Set up the page control
        let bottomConstraint = NSLayoutConstraint(item: effectView, attribute: .Bottom, relatedBy: .Equal, toItem: effectView.superview, attribute: .Bottom, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: effectView, attribute: .Height , relatedBy: .Equal, toItem: nil, attribute: .Height ,  multiplier: 1, constant: 40)
        let widthConstraint = NSLayoutConstraint(item: effectView, attribute: .Width , relatedBy: .Equal, toItem: effectView.superview, attribute: .Width ,  multiplier: 1, constant: 0)
        
        return [bottomConstraint, heightConstraint, widthConstraint]
    }
    
}

