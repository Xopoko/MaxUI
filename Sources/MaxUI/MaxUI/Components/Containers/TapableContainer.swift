import UIKit
import Combine

/// A container that can handle tap events and animate tapping with custom animations
/// - Examples:
///
/// `Most common use`:
///
///     Text("some text")
///         .insets(top: 24)
///         .onSelect {
///             print("didTap")
///         }
///         .configure(in: self)
///
/// `Direct creation (not preferred)`:
///
///     TapableContainer {
///         print("didTap")
///     } model: {
///         Text("some text")
///     }
///     .insets(top: 24)
///     .configure(in: self)
///
public struct TapableContainer: Componentable {
    public typealias ViewType = TapableContainerView

    /// The model that provides the content for the scroll view.
    public var model: MView? {
        get { _model.value }
        nonmutating set { _model.send(newValue) }
    }

    /// Appearance of tapable container
    public var appearance: TapableContainerView.Appearance {
        get { _appearance.value }
        nonmutating set { _appearance.send(newValue) }
    }

    /// Handles the tap event
    public var action: (() -> Void)? {
        get { _action.value }
        nonmutating set { _action.send(newValue) }
    }

    fileprivate let _model: CurrentValueSubject<MView?, Never>
    fileprivate let _appearance: CurrentValueSubject<TapableContainerView.Appearance, Never>
    fileprivate let _action: CurrentValueSubject<(() -> Void)?, Never>

    /// Initializes the component with a closure that returns a `MView`.
    ///
    /// - Parameters:
    ///     - action: Tap handler closure
    ///     - model: The closure that returns a `MView`.
    public init(_ action: (() -> Void)?, model: () -> MView) {
        self._model = .init(model())
        self._appearance = .init(TapableContainerView.Appearance())
        self._action = .init(action)
     }

    /// Initializes the component with a `MView` and Appearance.
    ///
    /// - Parameters:
    ///     - model: Model representing the view that this container contains.
    ///     - appearance: Appearance that contains the tapable container's appearance properties
    ///     - action: Tap handler closure
    public init(
        model: MView?,
        appearance: TapableContainerView.Appearance = TapableContainerView.Appearance(),
        _ action: (() -> Void)?
    ) {
        self._model = .init(model)
        self._appearance = .init(appearance)
        self._action = .init(action)
     }
}

public final class TapableContainerView: TapableView {
    private var appearance: Appearance?
    private var cancellables = Set<AnyCancellable>()
}

extension TapableContainerView: ReusableView {
    public func configure(with data: TapableContainer) {
        data._model
            .sink { [weak self] model in
                guard let self, let model else { return }

                self.subviews.forEach { $0.removeFromSuperview() }
                let contentView = model.createAssociatedViewInstance()
                contentView.isUserInteractionEnabled = false
                self.addSubview(contentView)
                contentView.fill()
            }
            .store(in: &cancellables)

        data._appearance
            .removeDuplicates()
            .sink { [weak self] appearance in
                self?.updateAppearance(appearance: appearance)
            }
            .store(in: &cancellables)

        data._action
            .assign(to: \.didSelect, on: self)
            .store(in: &cancellables)
    }

    public func prepareForReuse() {
        cancellables.removeAll()
    }
}

extension TapableContainerView {
    private func updateAppearance(appearance: Appearance) {
        guard appearance != self.appearance else { return }

        self.highlightBehavior = appearance.highlightBehavior

        self.appearance = appearance
    }
}

extension TapableContainerView {
    public struct Appearance: Equatable, Withable {
        public var highlightBehavior: TapableView.HighlightBehavior

        public init(highlightBehavior: TapableView.HighlightBehavior = .scale) {
            self.highlightBehavior = highlightBehavior
        }
    }
}

extension TapableContainer: Stylable {
    @discardableResult
    public func highlightBehavior(_ highlightBehavior: TapableView.HighlightBehavior) -> Self {
        self.appearance.highlightBehavior = highlightBehavior
        return self
    }
    
    @discardableResult
    public func style(_ appearance: TapableContainerView.Appearance) -> Self {
        self.appearance = appearance
        return self
    }

    @discardableResult
    public func onSelect(_ action: @escaping () -> Void) -> Self {
        self.action = action
        return self
    }
}
