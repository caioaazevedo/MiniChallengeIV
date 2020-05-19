//
//  CollectionViewFlowLayout.swift
//  MiniChallengeIV
//
//  Created by Caio Azevedo on 19/05/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import Foundation

import UIKit

class CollectionViewFlowLayout: UICollectionViewFlowLayout {

    required override init() {
        super.init()
        sectionInsetReference = .fromSafeArea
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributes = super.layoutAttributesForElements(in: rect)!.map { $0.copy() as! UICollectionViewLayoutAttributes }
        guard scrollDirection == .vertical else { return layoutAttributes }

        // Filter attributes to compute only cell attributes
        let cellAttributes = layoutAttributes.filter({ $0.representedElementCategory == .cell })

        // Group cell attributes by row (cells with same vertical center) and loop on those groups
        for (_, attributes) in Dictionary(grouping: cellAttributes, by: { ($0.center.y / 10).rounded(.up) * 10 }) {
            // Set the initial left inset
            var leftInset = sectionInset.left

            // Loop on cells to adjust each cell's origin and prepare leftInset for the next cell
            for attribute in attributes {
                attribute.frame.origin.x = leftInset
                leftInset = attribute.frame.maxX + minimumInteritemSpacing
            }
        }

        return layoutAttributes
    }

}
