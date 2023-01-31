import UIKit

extension UICollectionView {
    /// Creates a `UICollectionView` with a `UICollectionLayoutListConfiguration` layout.
    ///
    /// - Parameters:
    ///   - style: The appearance style for the list. The default is `.plain`.
    ///   - customInsets: The custom content insets for the list. The default is `nil`.
    ///   - groupSpacing: The inter-group spacing between sections. The default is `0`.
    /// - Returns: A newly created `UICollectionView`.
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
    
    /// Creates a `UICollectionView` with a `UICollectionViewFlowLayout` layout.
    ///
    /// - Parameters:
    ///   - sectionInset: The section insets for the layout. The default is `.zero`.
    ///   - itemSize: The size of each item in the layout.
    ///   - headerHeight: The height of the header in the layout. The default is `.zero`.
    ///   - footerHeight: The height of the footer in the layout. The default is `.zero`.
    ///   - minimumLineSpacing: The minimum line spacing between items. The default is `.zero`.
    ///   - contentInsets: The content insets for the layout. The default is `.zero`.
    /// - Returns: A newly created `UICollectionView`.
    public static func singleSectionCollection(
        sectionInset: UIEdgeInsets = .zero,
        itemSize: CGSize,
        headerHeight: CGFloat = .zero,
        footerHeight: CGFloat = .zero,
        minimumLineSpacing: CGFloat = .zero,
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
