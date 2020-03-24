//
//  CompanyTVC.swift
//  suqiakum
//
//  Created by Hady Hammad on 3/23/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import UIKit

class CompanyTVC: UITableViewCell {

    @IBOutlet weak var companiesCV: UICollectionView!
    
    // MARK :- Instance Variables
    var companyArray = [Company]()
    var delegate:ProductDetailDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.companiesCV.delegate = self
        self.companiesCV.dataSource = self
    }

}

extension CompanyTVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return companyArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = companiesCV.dequeue(indexPath: indexPath) as CompanyCVC
        cell.configure(company: self.companyArray[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate.goToDetails(company: self.companyArray[indexPath.row])
    }
    
}

extension CompanyTVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width - 20)/3, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
}
