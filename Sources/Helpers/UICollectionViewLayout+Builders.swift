import UIKit

extension UICollectionViewLayout {
    /// Creates a `UICollectionViewLayout` with a `UICollectionLayoutListConfiguration` layout.
    ///
    /// - Parameters:
    ///   - style: The appearance style for the list. The default is `.plain`.
    ///   - customInsets: The custom content insets for the list. The default is `nil`.
    ///   - groupSpacing: The inter-group spacing between sections. The default is `0`.
    /// - Returns: A newly created `UICollectionViewLayout`.
    public static func list(
        style: UICollectionLayoutListConfiguration.Appearance = .plain,
        customInsets: UIEdgeInsets? = nil,
        groupSpacing: CGFloat = 0
    ) -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { _, layoutEnvironment in
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
    }

    /// Creates a `UICollectionViewLayout` with a `.insetGrouped` layout.
    ///
    /// - Parameters:
    ///   - separatorColor: The separator color. The default is `nil`.
    ///   - sectionsInsets: The insets receiver for each section.
    /// - Returns: A newly created `UICollectionViewLayout`.
    public static func insetGroupedList(
        separatorColor: UIColor,
        sectionsInsets: @escaping ((Int) -> UIEdgeInsets)
    ) -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { index, layoutEnvironment in
            let customInsets = sectionsInsets(index)
            var listConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
            listConfig.backgroundColor = .clear
            listConfig.showsSeparators = true
            listConfig.separatorConfiguration.color = separatorColor
            let section = NSCollectionLayoutSection.list(
                using: listConfig,
                layoutEnvironment: layoutEnvironment
            )
            section.interGroupSpacing = 0
            section.contentInsets = NSDirectionalEdgeInsets(
                top: customInsets.top,
                leading: customInsets.left,
                bottom: customInsets.bottom,
                trailing: customInsets.right
            )
            return section
        }
    }
}
