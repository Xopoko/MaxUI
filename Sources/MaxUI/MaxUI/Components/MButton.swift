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
public struct MButton: Componentable {
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

    /// The appearance of the button.
    public var appearance: MButtonView.Appearance {
        get { _appearance.value }
        nonmutating set { _appearance.send(newValue) }
    }

    fileprivate let _title: CurrentValueSubject<String?, Never>
    fileprivate let _action: CurrentValueSubject<(() -> Void)?, Never>
    fileprivate let _appearance: CurrentValueSubject<MButtonView.Appearance, Never>
    fileprivate let _label: CurrentValueSubject<MView?, Never>

    /// Initializes a new button component with a title and an action.
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
    }

    /// Initializes a new button component with an action and a label.
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
    }
}

public final class MButtonView: TapableView {
    private var text: MText?
    private var container: Container?
    private var appearance: Appearance?
    private var cancellables = Set<AnyCancellable>()

    override public var tapAreaInset: UIEdgeInsets {
        appearance?.tapAreaInset ?? .zero
    }
}

extension MButtonView: ReusableView {
    public func configure(with data: MButton) {
        data._title
            .compactMap { $0 }
            .sink(receiveValue: { [weak self] text in
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
            .store(in: &cancellables)

        data._label
            .compactMap { $0 }
            .sink(receiveValue: { [weak self] component in
                let container = Container(
                    model: MHStack {
                     component
                    }.alignment(.center),
                    appearance: data.appearance.containerAppearance
                )
                self?.container = container
                self?.configure(withViewModel: container)
            })
            .store(in: &cancellables)

        data._action
            .assign(to: \.didSelect, on: self)
            .store(in: &cancellables)

        data._appearance
            .sink { [weak self] appearance in
                self?.updateAppearance(appearance: appearance)
            }
            .store(in: &cancellables)

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

        highlightBehavior = appearance.highlightBehavior
        isEnabled = appearance.isEnabled
        text?.textAppearance = appearance.textAppearance
        container?.containerAppearance = appearance.containerAppearance
        self.appearance = appearance
    }
}

// MARK: - Appearance
extension MButtonView {
    public struct Appearance: Equatable, Withable {
        public var textAppearance: MTextView.Appearance
        public var containerAppearance: ContainerView.Appearance
        public var isEnabled: Bool
        public var highlightBehavior: TapableView.HighlightBehavior
        public var tapAreaInset: UIEdgeInsets

        public init(
            textAppearance: MTextView.Appearance = MTextView.Appearance(textAligment: .center),
            containerAppearance: ContainerView.Appearance = ContainerView.Appearance(
                common: .init(isUserInteractionEnabled: false)
            ),
            isEnabled: Bool = true,
            highlightBehavior: TapableView.HighlightBehavior = .scale,
            tapAreaInset: UIEdgeInsets = .zero
        ) {
            self.textAppearance = textAppearance
            self.containerAppearance = containerAppearance
            self.isEnabled = isEnabled
            self.highlightBehavior = highlightBehavior
            self.tapAreaInset = tapAreaInset
        }
    }
}

/// Conforms to the `Textable` protocol and the `Containerable` protocol.
/// Defines behavior for customizing the text appearance and container appearance of an `MButton`.
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
    /// - Parameter isEnabled: A Boolean value indicating whether the button is enabled.
    /// - Returns: The updated `MButton` instance.
    @discardableResult
    public func isEnabled(_ isEnabled: Bool) -> MButton {
        self.appearance.isEnabled = isEnabled
        return self
    }

    /// Sets the highlight behavior for the `MButton`.
    ///
    /// - Parameter highlightBehavior: The highlight behavior to set.
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
                        .textAligment(.center)
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
