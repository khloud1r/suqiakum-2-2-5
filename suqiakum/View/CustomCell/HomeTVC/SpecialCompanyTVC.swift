//
//  SpecialCompanyTVC.swift
//  suqiakum
//
//  Created by Hady Hammad on 3/22/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import UIKit

class SpecialCompanyTVC: UITableViewCell {

    @IBOutlet weak var specialCompaniesCV: UICollectionView!
    
    var specialCompanyArray = [Company]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.specialCompaniesCV.delegate = self
        self.specialCompaniesCV.dataSource = self
    }
    
}

extension SpecialCompanyTVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return specialCompanyArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = specialCompaniesCV.dequeue(indexPath: indexPath) as CompanyCVC
        cell.deliveryPriceLbl.isHidden = true
        cell.configure(company: self.specialCompanyArray[indexPath.row])
        return cell
    }
}

extension SpecialCompanyTVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       return CGSize(width: (collectionView.frame.size.width - 36)/3, height: 140)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

