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
        Self.init(
            frame: .zero,
            collectionViewLayout: .list(
                style: style,
                customInsets: customInsets,
                groupSpacing: groupSpacing
            )
        )
    }

    /// Creates a `UICollectionView` with a `.insetGrouped` layout.
    ///
    /// - Parameters:
    ///   - separatorColor: The separator color. The default is `nil`.
    ///   - sectionsInsets: The insets receiver for each section.
    /// - Returns: A newly created `UICollectionView`.
    public static func insetGroupedList(
        separatorColor: UIColor,
        sectionsInsets: @escaping ((Int) -> UIEdgeInsets)
    ) -> Self {
        Self.init(
            frame: .zero,
            collectionViewLayout: .insetGroupedList(
                separatorColor: separatorColor,
                sectionsInsets: sectionsInsets
            )
        )
    }

    /// Creates a `UICollectionView` with a `UICollectionViewFlowLayout` layout with only one
    /// section and header/footer ability.
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
