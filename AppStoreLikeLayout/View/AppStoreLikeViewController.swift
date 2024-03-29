//
//  ViewController.swift
//  AppStoreLikeLayout
//
//  Created by rihitenLab on 2019/09/24.
//  Copyright © 2019 rihitenLab. All rights reserved.
//

import UIKit

struct Section: Hashable {
    let identifier = UUID()
    let title: String
    let pagingGruop: NSCollectionLayoutGroup
    let items: [Item]

    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }

    static func == (lhs: Section, rhs: Section) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

struct Item: Hashable {
    let number: Int
    let identifier = UUID()
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    static func == (lhs: Item, rhs: Item) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

class AppStoreLikeViewController: UIViewController {
    
    static let headerElementKind = "header-element-kind"

    @IBOutlet private var collectionView: UICollectionView!

    let data = [Section(title: "section-1", pagingGruop: SingleItemGroup.create(),
                        items: (1...18).map{ Item(number: $0) }),
                Section(title: "section-2", pagingGruop: TripleItemGroup.create(),
                        items: (1...18).map{ Item(number: $0) }),
                Section(title: "section-3", pagingGruop: SingleItemGroup.create(),
                        items: (1...18).map{ Item(number: $0) }),
                Section(title: "section-4", pagingGruop: TripleItemGroup.create(),
                        items: (1...18).map{ Item(number: $0) }),
                Section(title: "section-5", pagingGruop: SingleItemGroup.create(),
                        items: (1...18).map{ Item(number: $0) }),
                Section(title: "section-6", pagingGruop: TripleItemGroup.create(),
                        items: (1...18).map{ Item(number: $0) })
    ]

    var dataSource: UICollectionViewDiffableDataSource<Section, Item>! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureDataSource()
    }
}

extension AppStoreLikeViewController {
    func createLayout() -> UICollectionViewLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: {
            (sectionIndex:Int, layoutEnvironment:NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let snapshot = self.dataSource.snapshot()
            let section = snapshot.sectionIdentifier(containingItem: self.dataSource.itemIdentifier(for: IndexPath(item: 0, section: sectionIndex)) ?? Item(number: 1))
            
            guard let layoutGroup = section?.pagingGruop else { fatalError("Cannot get Section") }
            
            let sectionLayout = NSCollectionLayoutSection(group: layoutGroup)
            sectionLayout.orthogonalScrollingBehavior = .groupPagingCentered
            
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(0.2)),
            elementKind: AppStoreLikeViewController.headerElementKind,
            alignment: .top)
            
            sectionLayout.boundarySupplementaryItems = [sectionHeader]
            
            return sectionLayout
        }, configuration: config)
        
        return layout
    }
}

extension AppStoreLikeViewController {
    func configureHierarchy() {
        collectionView.collectionViewLayout = createLayout()
        
        collectionView.register(TextCell.self, forCellWithReuseIdentifier: TextCell.reuseIdentifier)
        collectionView.register(TitleSupplementaryView.self,
                                forSupplementaryViewOfKind: AppStoreLikeViewController.headerElementKind,
                                withReuseIdentifier: TitleSupplementaryView.reuseIdentifier)
        view.addSubview(collectionView)
        collectionView.delegate = self
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) {
                (collectionView: UICollectionView, indexPath: IndexPath, item: Item) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextCell.reuseIdentifier, for: indexPath) as? TextCell
            else { fatalError("Cannot create new cell") }

            cell.backgroundColor = .systemBlue
            cell.layer.cornerRadius = 20
            cell.contentView.layer.borderColor = UIColor.black.cgColor
            cell.contentView.layer.borderWidth = 1
            cell.contentView.layer.cornerRadius = 20
            cell.label.textAlignment = .center
            cell.label.font = UIFont.preferredFont(forTextStyle: .title1)

            cell.label.text = item.number.description
            return cell
        }

        dataSource.supplementaryViewProvider = { [weak self]
            (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            guard let self = self, let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: TitleSupplementaryView.reuseIdentifier,
                for: indexPath) as? TitleSupplementaryView else { fatalError("Cannot create new header") }
            let snapshot = self.dataSource.snapshot()
            let section = snapshot.sectionIdentifier(containingItem: self.dataSource.itemIdentifier(for: indexPath) ?? Item(number: 1))
            header.label.text = section?.title
            return header
        }

        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        data.forEach{
            snapshot.appendSections([$0])
            snapshot.appendItems($0.items, toSection: $0)
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension AppStoreLikeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
