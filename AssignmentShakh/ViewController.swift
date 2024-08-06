//
//  ViewController.swift
//  AssignmentShakh
//
//  Created by Sameer Jain on 06/08/24.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var reels: [[Video]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0 // No spacing between pages
        layout.minimumInteritemSpacing = 0 // No spacing between items in a row
        collectionView.collectionViewLayout = layout
        
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let nib = UINib(nibName: "MyCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "MyCell")
        
        fetchReelsData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return reels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! MyCell
        cell.configureWithVideos(reels[indexPath.section])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Set cell size to match the collection view's height
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageHeight = collectionView.bounds.height
        let targetYContentOffset = targetContentOffset.pointee.y
        let pageIndex = round(targetYContentOffset / pageHeight)
        
        targetContentOffset.pointee = CGPoint(x: 0, y: pageIndex * pageHeight)
    }
    
    func scrollToPage(at index: Int) {
        let indexPath = IndexPath(item: 0, section: index)
        collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
    }
    
}
