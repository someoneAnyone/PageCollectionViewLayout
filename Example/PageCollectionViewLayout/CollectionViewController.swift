//
//  CollectionViewController.swift
//  PageCollectionViewLayout
//
//  Created by Peter Ina on 10/30/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import UIKit
import PageCollectionViewLayout

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController, PageControlDecorationReusableViewDelegate {

    var dataArray: [UIColor] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes

        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        
        let colors = (1...10).map { _ in return UIColor.randomColor() }
        
        
        dataArray = colors

        self.collectionView!.setCollectionViewLayout(PageCollectionViewLayout(), animated: false)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return dataArray.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
    
        // Configure the cell
        
        let color = dataArray[indexPath.item]
        
        cell.contentView.backgroundColor = color
    
        return cell
    }

    // MARK: PageControlDecorationReusableViewDelegate

    override func collectionView(collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, atIndexPath indexPath: NSIndexPath) {
        
        if elementKind == PageControlDecorationReusableView.kind {
            let pageViewDecor = view as! PageControlDecorationReusableView
            pageViewDecor.delegate = self
        }
        print(elementKind)
    }

    // MARK: UICollectionViewDelegate

    func pageControlReusableViewDidSelect(view: PageControlDecorationReusableView, index: Int) {
        collectionView?.selectItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0), animated: true, scrollPosition: .CenteredHorizontally)
    }
}

extension UIColor {
    class func  randomColor() -> UIColor {
        let randomRed:CGFloat = CGFloat(drand48())
        
        let randomGreen:CGFloat = CGFloat(drand48())
        
        let randomBlue:CGFloat = CGFloat(drand48())
        
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
}

