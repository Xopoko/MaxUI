import UIKit
import Combine

/// The MScrollView is a Componentable struct that provides a customizable scrolling view.
public struct MScrollView: Componentable {
    public typealias ViewType = MScrollViewView

    /// The model that provides the content for the scroll view.
    public var model: MView? {
        get { _model.value }
        nonmutating set { _model.send(newValue) }
    }

    /// The appearance for the scroll view.
    public var scrollViewAppearance: Appearance? {
        get { _appearance.value }
        nonmutating set { if let newValue { _appearance.send(newValue) } }
    }

    /// The refresh control for the scroll view.
    public var refreshControl: UIRefreshControl? {
        get { _refreshControl.value }
        nonmutating set { _refreshControl.send(newValue) }
    }

    fileprivate let _model: CurrentValueSubject<MView?, Never>
    fileprivate let _appearance: CurrentValueSubject<Appearance, Never>
    fileprivate let _refreshControl: CurrentValueSubject<UIRefreshControl?, Never>

    /// Initializes an `MScrollView` with the content view and appearance.
    ///
    /// - Parameters:
    ///   - contentView: A closure that returns the model to use as the content view.
    ///   - appearance: The appearance for the scroll view. Default is an empty `Appearance` struct.
    ///   - refreshControl: The refresh control for the scroll view. Default is `nil`.
    public init(
        _ contentView: () -> MView,
        appearance: Appearance = .init(),
        refreshControl: UIRefreshControl? = nil
    ) {
        self._model = .init(contentView())
        self._appearance = .init(appearance)
        self._refreshControl = .init(refreshControl)
    }

    /// Initializes an `MScrollView` with the model, appearance, and refresh control.
    ///
    /// - Parameters:
    ///   - model: The model that provides the content for the scroll view.
    ///   - appearance: The appearance for the scroll view. Default is an empty `Appearance` struct.
    ///   - refreshControl: The refresh control for the scroll view. Default is `nil`.
    public init(
        model: MView?,
        appearance: Appearance = .init(),
        refreshControl: UIRefreshControl? = nil
    ) {
        self._model = .init(model)
        self._appearance = .init(appearance)
        self._refreshControl = .init(refreshControl)
    }
}

// View which will be created from the MScrollView. Usually you don't have to use it directly.
public final class MScrollViewView: ControlsFriendlyScrollView {
    private var contentView: UIView?
    private var appearance: MScrollView.Appearance?
    private var cancellables = Set<AnyCancellable>()
}

extension MScrollViewView: ReusableView {
    public func configure(with data: MScrollView) {
        data._model
            .compactMap { $0 }
            .sink { [weak self] model in
                let contentView = model.createAssociatedViewInstance()
                self?.contentView = contentView
                if let appearance = self?.appearance {
                    self?.rebuildView(contentView: contentView, appearance: appearance)
                }
            }
            .store(in: &cancellables)

        data._appearance
            .sink { [weak self] appearance in
                self?.updateAppearance(appearance: appearance)
                if let contentView = self?.contentView {
                    self?.rebuildView(contentView: contentView, appearance: appearance)
                }
            }
            .store(in: &cancellables)

        data._refreshControl
            .sink { [weak self] refreshControl in
                self?.refreshControl = refreshControl
            }
            .store(in: &cancellables)
    }

    public func prepareForReuse() {
        cancellables.removeAll()
    }
}

// MARK: - Private methods
extension MScrollViewView {
    private func rebuildView(contentView: UIView, appearance: MScrollView.Appearance) {
        subviews.forEach { $0.removeFromSuperview() }
        addSubview(contentView)

        translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        var constraints: [NSLayoutConstraint] = []
        switch appearance.distribution {
        case .fill(let insets):
            contentView.fill(with: SharedAppearance.Layout(insets: insets), on: self)
        case .center(let offset):
            switch appearance.axis {
            case .vertical:
                constraints = [
                    contentView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: offset)
                ]
            case .horizontal:
                constraints = [
                    contentView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: offset)
                ]
            @unknown default:
                break
            }
        }

        switch appearance.axis {
        case .vertical:
            constraints.append(contentView.widthAnchor.constraint(equalTo: widthAnchor))
        case .horizontal:
            constraints.append(contentView.heightAnchor.constraint(equalTo: heightAnchor))
        @unknown default:
            break
        }

        NSLayoutConstraint.activate(constraints)
    }

    private func updateAppearance(appearance: MScrollView.Appearance) {
        guard appearance != self.appearance else { return }

        contentInset = appearance.contentInsets
        showsVerticalScrollIndicator = appearance.showsVerticalScrollIndicator
        showsHorizontalScrollIndicator = appearance.showsHorizontalScrollIndicator
        alwaysBounceVertical = appearance.alwaysBounceVertical
        alwaysBounceHorizontal = appearance.alwaysBounceHorizontal

        self.appearance = appearance
    }
}

extension MScrollView {
    public struct Appearance: Equatable, Withable {
        public enum Distribution: Equatable {
            case fill(insets: UIEdgeInsets)
            case center(offset: CGFloat)
        }

        public var axis: NSLayoutConstraint.Axis
        public var distribution: Distribution
        public var contentInsets: UIEdgeInsets
        public var showsVerticalScrollIndicator: Bool
        public var showsHorizontalScrollIndicator: Bool
        public var alwaysBounceVertical: Bool
        public var alwaysBounceHorizontal: Bool

        public init(
            axis: NSLayoutConstraint.Axis = .vertical,
            distribution: Distribution = .fill(insets: .zero),
            contentInsets: UIEdgeInsets = .zero,
            showsVerticalScrollIndicator: Bool = false,
            showsHorizontalScrollIndicator: Bool = false,
            alwaysBounceVertical: Bool = false,
            alwaysBounceHorizontal: Bool = false
        ) {
            self.axis = axis
            self.distribution = distribution
            self.contentInsets = contentInsets
            self.showsVerticalScrollIndicator = showsVerticalScrollIndicator
            self.showsHorizontalScrollIndicator = showsHorizontalScrollIndicator
            self.alwaysBounceVertical = alwaysBounceVertical
            self.alwaysBounceHorizontal = alwaysBounceHorizontal
        }
    }
}

/// This protocol helps other components that want to use MScrollView's declarative
/// behavior to implement MText apperance. To do this, you need to define the MScrollView
/// appearance in your components.
public protocol Scrollable {
    var scrollViewAppearance: MScrollView.Appearance? { get nonmutating set }
}

extension MScrollView: Scrollable {
    /// Sets the axis of the scroll view.
    ///
    /// - Parameter axis: The new axis to set.
    /// - Returns: The updated scrollable instance.
    @discardableResult
    public func axis(_ axis: NSLayoutConstraint.Axis) -> MScrollView {
        scrollViewAppearance?.axis = axis
        return self
    }

    /// Sets the distribution of the scroll view.
    ///
    /// - Parameter distribution: The new distribution to set.
    /// - Returns: The updated scrollable instance.
    @discardableResult
    public func distribution(_ distribution: Appearance.Distribution) -> MScrollView {
        scrollViewAppearance?.distribution = distribution
        return self
    }

    /// Sets the content insets of the scroll view.
    ///
    /// - Parameter contentInsets: The new content insets to set.
    /// - Returns: The updated scrollable instance.
    @discardableResult
    public func contentInsets(_ contentInsets: UIEdgeInsets) -> MScrollView {
        scrollViewAppearance?.contentInsets = contentInsets
        return self
    }

    /// Shows or hides the vertical scroll indicator of the scroll view.
    ///
    /// - Parameter showsVerticalScrollIndicator: A boolean value indicating whether to show the vertical scroll indicator.
    /// - Returns: The updated scrollable instance.
    @discardableResult
    public func showsVerticalScrollIndicator(_ showsVerticalScrollIndicator: Bool) -> MScrollView {
        scrollViewAppearance?.showsVerticalScrollIndicator = showsVerticalScrollIndicator
        return self
    }

    /// Shows or hides the horizontal scroll indicator of the scroll view.
    ///
    /// - Parameter showsHorizontalScrollIndicator: A boolean value indicating whether to show the horizontal scroll indicator.
    /// - Returns: The updated scrollable instance.
    @discardableResult
    public func showsHorizontalScrollIndicator(
        _ showsHorizontalScrollIndicator: Bool
    ) -> MScrollView {
        scrollViewAppearance?.showsVerticalScrollIndicator = showsHorizontalScrollIndicator
        return self
    }

    /// Shows or hides the scroll indicators of the scroll view.
    ///
    /// - Parameter showsScrollIndicators: A boolean value indicating whether to show the scroll indicators.
    /// - Returns: The updated scrollable instance.
    @discardableResult
    public func showsScrollIndicators(
        _ showsScrollIndicators: Bool
    ) -> MScrollView {
        scrollViewAppearance?.showsVerticalScrollIndicator = showsScrollIndicators
        scrollViewAppearance?.showsHorizontalScrollIndicator = showsScrollIndicators
        return self
    }

    /// Enables the scroll vertical bouncing.
    ///
    /// - Parameter alwaysBounceVertical: A boolean value indicating whether to enable the scroll vertical bouncing.
    /// - Returns: The updated scrollable instance.
    @discardableResult
    public func alwaysBounceVertical(
        _ alwaysBounceVertical: Bool
    ) -> MScrollView {
        scrollViewAppearance?.alwaysBounceVertical = alwaysBounceVertical
        return self
    }

    /// Enables the scroll horizontal bouncing.
    ///
    /// - Parameter alwaysBounceHorizontal: A boolean value indicating whether to enable the scroll horizontal bouncing.
    /// - Returns: The updated scrollable instance.
    @discardableResult
    public func alwaysBounceHorizontal(
        _ alwaysBounceHorizontal: Bool
    ) -> MScrollView {
        scrollViewAppearance?.alwaysBounceHorizontal = alwaysBounceHorizontal
        return self
    }

    /// Adds a refresh control to the scroll view.
    ///
    /// - Parameter refreshControl: The refresh control to add.
    /// - Returns: The updated scroll view instance.
    @discardableResult
    public func refreshControl(
        _ refreshControl: UIRefreshControl
    ) -> MScrollView {
        self.refreshControl = refreshControl
        return self
    }
}

extension MScrollView: Stylable {
    @discardableResult
    public func style(_ appearance: MScrollView.Appearance) -> Self {
        scrollViewAppearance = appearance
        return self
    }
}
