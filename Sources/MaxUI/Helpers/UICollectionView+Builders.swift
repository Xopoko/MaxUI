import UIKit

extension UICollectionView {
    public static func list(
        style: UICollectionLayoutListConfiguration.Appearance = .plain,
        customInsets: UIEdgeInsets? = nil,
        groupSpacing: CGFloat = 0
    ) -> Self {
        let layout = UICollectionViewCompositionalLayout { _, layoutEnvironment in
            var listConfig = UICollectionLayoutListConfiguration(appearance: style)
            listConfig.backgroundColor = .clear
            listConfig.showsSeparators = false
            let section = NSCollectionLayoutSection.list(
                using: listConfig,
                layoutEnvironment: layoutEnvironment
            )
            section.interGroupSpacing = groupSpacing
            if let customInsets = customInsets {
                section.contentInsets = NSDirectionalEdgeInsets(
                    top: customInsets.top,
                    leading: customInsets.left,
                    bottom: customInsets.bottom,
                    trailing: customInsets.right
                )
            }
            return section
        }
        
        return Self.init(frame: .zero, collectionViewLayout: layout)
    }
    
    public static func singleSectionCollection(
        sectionInset: UIEdgeInsets = .zero,
        itemSize: CGSize,
        headerHeight: CGFloat = 0,
        footerHeight: CGFloat = 0,
        minimumLineSpacing: CGFloat = 0,
        contentInsets: UIEdgeInsets = .zero
    ) -> Self {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionHeadersPinToVisibleBounds = true
        layout.sectionInset = sectionInset
        layout.headerReferenceSize = CGSize(
            width: UIScreen.main.bounds.width,
            height: headerHeight
        )
        layout.footerReferenceSize = CGSize(
            width: UIScreen.main.bounds.width,
            height: footerHeight
        )
        layout.itemSize = itemSize
        layout.minimumLineSpacing = minimumLineSpacing
        
        let collection = Self(
            frame: .zero,
            collectionViewLayout: layout
        )
        collection.backgroundColor = .clear
        collection.contentInsetAdjustmentBehavior = .never
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.contentInset = contentInsets
        return collection
    }
}
