import UIKit
import Combine

public struct ScrollView: ComponentViewModelProtocol {
    public typealias ViewType = ScrollViewView
        
    public var model: ViewableViewModelProtocol? {
        get { _model.value }
        nonmutating set { _model.send(newValue) }
    }
    
    public var scrollViewAppearance: Appearance? {
        get { _appearance.value }
        nonmutating set { if let newValue { _appearance.send(newValue) } }
    }
    
    public var refreshControl: UIRefreshControl? {
        get { _refreshControl.value }
        nonmutating set { _refreshControl.send(newValue) }
    }
    
    fileprivate let _model: CurrentValueSubject<ViewableViewModelProtocol?, Never>
    fileprivate let _appearance: CurrentValueSubject<Appearance, Never>
    fileprivate let _refreshControl: CurrentValueSubject<UIRefreshControl?, Never>
    
    public init(
        _ contentView: () -> ViewableViewModelProtocol,
        appearance: Appearance = .init(),
        refreshControl: UIRefreshControl? = nil
    ) {
        self._model = .init(contentView())
        self._appearance = .init(appearance)
        self._refreshControl = .init(refreshControl)
    }
    
    public init(
        model: ViewableViewModelProtocol?,
        appearance: Appearance = .init(),
        refreshControl: UIRefreshControl? = nil
    ) {
        self._model = .init(model)
        self._appearance = .init(appearance)
        self._refreshControl = .init(refreshControl)
    }
}

public final class ScrollViewView: ControlsFrendlyScrollView {
    private var contentView: UIView?
    private var appearance: ScrollView.Appearance?
    private var cancellables = Set<AnyCancellable>()
}

extension ScrollViewView: ReusableView {
    public func configure(with data: ScrollView) {
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
private extension ScrollViewView {
    private func rebuildView(contentView: UIView, appearance: ScrollView.Appearance) {
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
    
    private func updateAppearance(appearance: ScrollView.Appearance) {
        guard appearance != self.appearance else { return }
        
        contentInset = appearance.contentInsets
        showsVerticalScrollIndicator = appearance.showsVerticalScrollIndicator
        showsHorizontalScrollIndicator = appearance.showsHorizontalScrollIndicator
        
        self.appearance = appearance
    }
}

extension ScrollView {
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
        
        public init(
            axis: NSLayoutConstraint.Axis = .vertical,
            distribution: Distribution = .fill(insets: .zero),
            contentInsets: UIEdgeInsets = .zero,
            showsVerticalScrollIndicator: Bool = false,
            showsHorizontalScrollIndicator: Bool = false
        ) {
            self.axis = axis
            self.distribution = distribution
            self.contentInsets = contentInsets
            self.showsVerticalScrollIndicator = showsVerticalScrollIndicator
            self.showsHorizontalScrollIndicator = showsHorizontalScrollIndicator
        }
    }
}

/// This protocol helps other components that want to use ScrollView's declarative behavior to implement Text apperance. To do this, you need to define the ScrollView appearance in your components.
public protocol DeclaratableScrollViewAppearance {
    var scrollViewAppearance: ScrollView.Appearance? { get nonmutating set }
    
    func axis(_ axis: NSLayoutConstraint.Axis) -> Self
    func distribution(_ distribution: ScrollView.Appearance.Distribution) -> Self
    func contentInsets(_ contentInsets: UIEdgeInsets) -> Self
    func showsVerticalScrollIndicator(_ showsVerticalScrollIndicator: Bool) -> Self
    func showsHorizontalScrollIndicator(_ showsHorizontalScrollIndicator: Bool) -> Self
}

extension ScrollView: DeclaratableScrollViewAppearance {
    public func axis(_ axis: NSLayoutConstraint.Axis) -> ScrollView {
        scrollViewAppearance?.axis = axis
        return self
    }
    
    public func distribution(_ distribution: Appearance.Distribution) -> ScrollView {
        scrollViewAppearance?.distribution = distribution
        return self
    }
    
    public func contentInsets(_ contentInsets: UIEdgeInsets) -> ScrollView {
        scrollViewAppearance?.contentInsets = contentInsets
        return self
    }
    
    public func showsVerticalScrollIndicator(_ showsVerticalScrollIndicator: Bool) -> ScrollView {
        scrollViewAppearance?.showsVerticalScrollIndicator = showsVerticalScrollIndicator
        return self
    }
    
    public func showsHorizontalScrollIndicator(
        _ showsHorizontalScrollIndicator: Bool
    ) -> ScrollView {
        scrollViewAppearance?.showsVerticalScrollIndicator = showsHorizontalScrollIndicator
        return self
    }
    
    public func showsScrollIndicators(
        _ showsScrollIndicators: Bool
    ) -> ScrollView {
        scrollViewAppearance?.showsVerticalScrollIndicator = showsScrollIndicators
        scrollViewAppearance?.showsHorizontalScrollIndicator = showsScrollIndicators
        return self
    }
    
    public func refreshControl(
        _ refreshControl: UIRefreshControl
    ) -> ScrollView {
        self.refreshControl = refreshControl
        return self
    }
}

extension ScrollView: Stylable {
    public func style(_ appearance: ScrollView.Appearance) -> Self {
        scrollViewAppearance = appearance
        return self
    }
}
