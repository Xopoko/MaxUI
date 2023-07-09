import UIKit
import Combine

/// This custom button provides a convenient way to create UIButtons with a SwiftUI-like interface
/// - Examples:
///
/// `Most common use`:
///
///     Button("some text") {
///         print("tap")
///     }
///     .insets(top: 24)
///     .configure(in: self)
///
/// `Initialization with custom 'label'`:
///
///     Button {
///         print("tap")
///     } label: {
///         Text("some text")
///     }
///     .insets(top: 24)
///     .configure(in: self)
public struct MButton: Componentable, Withable {
    public typealias ViewType = MButtonView

    /// The title of the button.
    public var title: String? {
        get { _title.value }
        nonmutating set { _title.send(newValue) }
    }

    /// The custom component that using instead of Text.
    public var label: MView? {
        get { _label.value }
        nonmutating set { if let newValue { _label.send(newValue) } }
    }

    /// The action to be performed when the button is tapped.
    public var action: (() -> Void)? {
        get { _action.value }
        nonmutating set { _action.send(newValue) }
    }
    
    /// The action to be performed when the button is tapped.
    public var animations: ((MButtonView) -> Void)? {
        get { _animations.value }
        nonmutating set { _animations.send(newValue) }
    }

    /// The appearance of the button.
    public var appearance: MButtonView.Appearance {
        get { _appearance.value }
        nonmutating set { _appearance.send(newValue) }
    }
    
    /// Enables or disables the `MButton`.
    @MBinding
    fileprivate var isEnabled = true

    fileprivate let _title: CurrentValueSubject<String?, Never>
    fileprivate let _action: CurrentValueSubject<(() -> Void)?, Never>
    fileprivate let _animations: CurrentValueSubject<((MButtonView) -> Void)?, Never>
    fileprivate let _appearance: CurrentValueSubject<MButtonView.Appearance, Never>
    fileprivate let _label: CurrentValueSubject<MView?, Never>

    /// Initialise a new button component with a title and an action.
    ///
    /// - Parameters:
    ///     - title: The title of the button.
    ///     - action: The action to be performed when the button is tapped.
    public init(
        _ title: String?,
        _ action: (() -> Void)?
    ) {
        self._title = .init(title)
        self._label = .init(nil)
        self._appearance = .init(MButtonView.Appearance())
        self._action = .init(action)
        self._animations = .init(nil)
    }

    /// Initialise a new button component with an action and a label.
    ///
    /// - Parameters:
    ///     - action: The action to be performed when the button is tapped.
    ///     - label: The label associated with the button.
    public init(
        _ action: (() -> Void)?,
        label: () -> MView
    ) {
        self._title = .init(nil)
        self._label = .init(label())
        self._appearance = .init(MButtonView.Appearance())
        self._action = .init(action)
        self._animations = .init(nil)
    }
}

public final class MButtonView: TapableView {
    private var text: MText?
    private var container: Container?
    private var appearance: Appearance?
    private var cancellables = Set<AnyCancellable>()
    private var animations: ((MButtonView) -> Void)?
    
    override public var tapAreaInset: UIEdgeInsets {
        appearance?.tapAreaInset ?? .zero
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        animations?(self)
    }
}

extension MButtonView: ReusableView {
    public func configure(with data: MButton) {
        CancellableStorage(in: &cancellables) { [weak self] in
            data._title
                .compactMap { $0 }
                .sink(receiveValue: { text in
                    let textModel = MText(text)
                    if let textAppearance = self?.appearance?.textAppearance {
                        textModel.textAppearance = textAppearance
                    }
                    
                    let container = Container(
                        model: textModel,
                        appearance: data.appearance.containerAppearance
                    )
                    self?.text = textModel
                    self?.container = container
                    self?.configure(withViewModel: container)
                })
            
            data._label
                .compactMap { $0 }
                .sink(receiveValue: { component in
                    let container = Container(
                        model: MHStack {
                            component
                        }.alignment(.center),
                        appearance: data.appearance.containerAppearance
                    )
                    self?.container = container
                    self?.configure(withViewModel: container)
                })
            
            data._animations
                .sink { animations in
                    guard let self else { return }
                    
                    self.animations = animations
                    
                    animations?(self)
                }
            
            data._action.weakAssign(to: \.didSelect, on: self)
            data._appearance.sink { self?.updateAppearance(appearance: $0) }
            data.$isEnabled.publisher.weakAssign(to: \.isEnabled, on: self)
        }

        self.didSelect = data.action

        updateAppearance(appearance: data.appearance)
    }

    public func prepareForReuse() {
        cancellables.removeAll()
    }
}

// MARK: - Private methods
extension MButtonView {
    private func updateAppearance(appearance: Appearance) {
        guard appearance != self.appearance else { return }

        if let highlightBehavior = appearance.highlightBehavior {
            self.highlightBehavior = highlightBehavior
        }
        text?.textAppearance = appearance.textAppearance
        container?.containerAppearance = appearance.containerAppearance
        isUserInteractionEnabled = appearance.isUserInteractionEnabled
        self.appearance = appearance
    }
}

// MARK: - Appearance
extension MButtonView {
    public struct Appearance: Equatable, Withable {
        public var textAppearance: MTextView.Appearance
        public var containerAppearance: ContainerView.Appearance
        public var highlightBehavior: TapableView.HighlightBehavior?
        public var tapAreaInset: UIEdgeInsets
        public var isUserInteractionEnabled: Bool
        
        public init(
            textAppearance: MTextView.Appearance = MTextView.Appearance(textAlignment: .center),
            containerAppearance: ContainerView.Appearance = ContainerView.Appearance(
                common: .init(isUserInteractionEnabled: .constant(false))
            ),
            highlightBehavior: TapableView.HighlightBehavior? = .alpha,
            tapAreaInset: UIEdgeInsets = .zero,
            isUserInteractionEnabled: Bool = true
        ) {
            self.textAppearance = textAppearance
            self.containerAppearance = containerAppearance
            self.highlightBehavior = highlightBehavior
            self.tapAreaInset = tapAreaInset
            self.isUserInteractionEnabled = isUserInteractionEnabled
        }
    }
}

/// Conforms to the `Textable` protocol and the `Containerable` protocol.
/// Defines behaviour for customizing the text appearance and container appearance of an `MButton`.
extension MButton: Textable, Containerable {
    /// Gets the text appearance of the `MButton`.
    public var textAppearance: MTextView.Appearance {
        get { appearance.textAppearance }
        nonmutating set { appearance.textAppearance = newValue }
    }

    /// Gets and sets the container appearance of the `MButton`.
    public var containerAppearance: ContainerView.Appearance? {
        get { appearance.containerAppearance }
        nonmutating set { if let newValue { appearance.containerAppearance = newValue } }
    }

    /// Enables or disables the `MButton`.
    ///
    /// - Parameter isEnabled: A Boolean binding value indicating whether the button is enabled.
    /// - Returns: The updated `MButton` instance.
    @discardableResult
    public func isEnabled(_ isEnabled: MBinding<Bool>) -> MButton {
        with(\._isEnabled, setTo: isEnabled)
    }
    
    /// Enables or disables the `MButton`.
    ///
    /// - Parameter isEnabled: A Boolean  value indicating whether the button is enabled.
    /// - Returns: The updated `MButton` instance.
    @discardableResult
    public func isEnabled(_ isEnabled: Bool) -> MButton {
        with(\.isEnabled, setTo: isEnabled)
    }

    /// Sets the highlight behaviour for the `MButton`.
    ///
    /// - Parameter highlightBehavior: The highlight behaviour to set.
    /// - Returns: The updated `MButton` instance.
    @discardableResult
    public func highlightBehavior(
        _ highlightBehavior: TapableView.HighlightBehavior
    ) -> MButton {
        self.appearance.highlightBehavior = highlightBehavior
        return self
    }

    /// Sets the tap area inset for the `MButton`.
    ///
    /// - Parameter tapAreaInset: The tap area inset to set.
    /// - Returns: The updated `MButton` instance.
    @discardableResult
    public func tapAreaInset(_ tapAreaInset: UIEdgeInsets) -> MButton {
        self.appearance.tapAreaInset = tapAreaInset
        return self
    }
}

extension MButton: Stylable {
    @discardableResult
    public func style(_ appearance: MButtonView.Appearance) -> Self {
        self.appearance = appearance
        return self
    }
}

#if DEBUG
import SwiftUI
struct Button_Previews: PreviewProvider {
    static var previews: some View {
        ComponentPreview(distribution: .center) {
            MHStack {
                MHStack {
                    MButton("Button") {}
                        .tapAreaInset(.init(top: 40, left: 40, bottom: 40, right: 40))
                        .textColor(.white)
                        .textAlignment(.center)
                        .backgroundColor(.systemGreen)
                        .cornerRadius(12)
                        .height(44)
                        .toContainer()
                        .insets(12)
                }
            }
        }
    }
}
#endif
