//
//  TripleItemGroup.swift
//  AppStoreLikeLayout
//
//  Created by rihitenLab on 2019/09/29.
//  Copyright © 2019 rihitenLab. All rights reserved.
//

import UIKit

struct TripleItemGroup {
    static func create() -> NSCollectionLayoutGroup {
        let itemLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.3))
        let item = NSCollectionLayoutItem(layoutSize: itemLayoutSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 10.0, bottom: 5.0, trailing: 10.0)
        
        let containerGroupLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.85), heightDimension: .fractionalWidth(0.85 / 16 * 9))
        let containerGroup = NSCollectionLayoutGroup.vertical(layoutSize: containerGroupLayoutSize, subitem: item, count: 3)

        return containerGroup
    }
}
