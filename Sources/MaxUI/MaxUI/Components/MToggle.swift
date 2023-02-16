import UIKit
import Combine

/// The `MToggle` its a UISwitch in SwiftUI-like style.
/// It serves as a toggle switch model and is used to control.
public struct MToggle: Componentable {
    public typealias ViewType = MToggleView

    /// Property that determines whether the toggle is currently turned on or off.
    public var isOn: Bool {
        get { _isOn.value }
        nonmutating set { _isOn.send(newValue) }
    }

    /// Property that determines whether the toggle is currently enabled or disabled.
    public var isEnabled: Bool {
        get { _isEnabled.value }
        nonmutating set { _isEnabled.send(newValue) }
    }

    /// Property that defines the action to be taken when the toggle's state changes.
    public var onSwitch: ((Bool) -> Void) {
        get { _onSwitch.value }
        nonmutating set { _onSwitch.send(newValue) }
    }

    /// Property that defines the appearance of the toggle.
    public var appearance: MToggleView.Appearance {
        get { _appearance.value }
        nonmutating set { _appearance.send(newValue) }
    }

    fileprivate let _onSwitch: CurrentValueSubject<((Bool) -> Void), Never>
    fileprivate let _isOn: CurrentValueSubject<Bool, Never>
    fileprivate let _appearance: CurrentValueSubject<MToggleView.Appearance, Never>
    fileprivate let _isEnabled: CurrentValueSubject<Bool, Never>

    /// Initializes a new `MToggle` instance.
    ///
    /// - Parameters:
    ///     - isOn: The initial state of the toggle. Default is `false`.
    ///     - isEnabled: The initial enabled state of the toggle. Default is `true`.
    ///     - appearance: The initial appearance of the toggle. Default is `MToggleView.Appearance()`.
    ///     - onSwitch: The action to be taken when the toggle's state changes.
    public init(
        isOn: Bool,
        isEnabled: Bool = true,
        appearance: MToggleView.Appearance = MToggleView.Appearance(),
        onSwitch: @escaping ((Bool) -> Void)
    ) {
        self._isOn = .init(isOn)
        self._isEnabled = .init(isEnabled)
        self._appearance = .init(appearance)
        self._onSwitch = .init(onSwitch)
    }
}

public final class MToggleView: UIView {
    private let switcher = UISwitch()

    private var switchHandler: ((Bool) -> Void)?
    private var appearance: Appearance?
    private var cancellables = Set<AnyCancellable>()

    init() {
        super.init(frame: .zero)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - ReusableView
extension MToggleView: ReusableView {
    public func configure(with data: MToggle) {
        data._isOn
            .assign(to: \.isOn, on: switcher)
            .store(in: &cancellables)

        data._isEnabled
            .assign(to: \.isEnabled, on: switcher)
            .store(in: &cancellables)

        data._onSwitch
            .sink { [weak self] onSwitch in
                self?.switchHandler = onSwitch
            }
            .store(in: &cancellables)

        data._appearance
            .sink { [weak self] appearance in
                self?.updateAppearance(appearance: appearance)
            }
            .store(in: &cancellables)
    }

    public func prepareForReuse() {
        cancellables.removeAll()
    }
}

// MARK: - Private methods
extension MToggleView {
    private func setupLayout() {
        let action = UIAction(
            identifier: ActionConstants.switchActionId
        ) { [weak self] _ in
            self?.handleSwitch()
        }
        switcher.addAction(action, for: ActionConstants.switchEvent)

        switcher.fill(in: self)
    }

    private func handleSwitch() {
        switchHandler?(switcher.isOn)
    }

    private func updateAppearance(appearance: Appearance) {
        guard appearance != self.appearance else { return }

        switcher.set(height: appearance.height)
        self.appearance = appearance
    }
}

// MARK: - Constants
extension MToggleView {
    private enum ActionConstants {
        static let switchEvent = UIControl.Event.valueChanged
        static let switchActionId = UIAction.Identifier("\(switchEvent)")
    }

    public enum Metrics {
        public static let defaultWidth: CGFloat = 51
        public static let defaultHeight: CGFloat = 31
    }
}

// MARK: - Appearance
extension MToggleView {
    public struct Appearance: Equatable, Withable {
        public var height: CGFloat

        public init(height: CGFloat = MToggleView.Metrics.defaultHeight) {
            self.height = height
        }
    }
}

extension UISwitch {
    fileprivate func set(height: CGFloat) {
        let heightRatio = height / MToggleView.Metrics.defaultHeight
        transform = CGAffineTransform(scaleX: heightRatio, y: heightRatio)
    }
}

extension MToggle {
    /// Sets the height of the toggle to the given height value.
    ///
    /// - Parameter height: The new height to set.
    /// - Returns: The updated instance of `MToggle`.
    @discardableResult
    public func toggleHeight(_ height: CGFloat) -> Self {
        appearance.height = height
        return self
    }
}
