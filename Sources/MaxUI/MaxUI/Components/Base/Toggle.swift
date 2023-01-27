import UIKit
import Combine

public struct Toggle: ComponentViewModelProtocol, DeclaratableToggleAppearance {
    public typealias ViewType = ToggleView
    
    public var isOn: Bool {
        get { _isOn.value }
        nonmutating set { _isOn.send(newValue) }
    }
    
    public var isEnabled: Bool {
        get { _isEnabled.value }
        nonmutating set { _isEnabled.send(newValue) }
    }
    
    public var onSwitch: ((Bool) -> Void) {
        get { _onSwitch.value }
        nonmutating set { _onSwitch.send(newValue) }
    }
    
    public var appearance: ToggleView.Appearance {
        get { _appearance.value }
        nonmutating set { _appearance.send(newValue) }
    }
    
    fileprivate let _onSwitch: CurrentValueSubject<((Bool) -> Void), Never>
    fileprivate let _isOn: CurrentValueSubject<Bool, Never>
    fileprivate let _appearance: CurrentValueSubject<ToggleView.Appearance, Never>
    fileprivate let _isEnabled: CurrentValueSubject<Bool, Never>
    
    public init(
        isOn: Bool,
        isEnabled: Bool = true,
        appearance: ToggleView.Appearance = ToggleView.Appearance(),
        onSwitch: @escaping ((Bool) -> Void)
    ) {
        self._isOn = .init(isOn)
        self._isEnabled = .init(isEnabled)
        self._appearance = .init(appearance)
        self._onSwitch = .init(onSwitch)
    }
}

public final class ToggleView: UIView {
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
extension ToggleView: ReusableView {
    public func configure(with data: Toggle) {
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
private extension ToggleView {
    func setupLayout() {
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
extension ToggleView {
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
extension ToggleView {
    public struct Appearance: Equatable, Withable {
        public var height: CGFloat
        
        public init(height: CGFloat = ToggleView.Metrics.defaultHeight) {
            self.height = height
        }
    }
}

private extension UISwitch {
    func set(height: CGFloat) {
        let heightRatio = height / ToggleView.Metrics.defaultHeight
        transform = CGAffineTransform(scaleX: heightRatio, y: heightRatio)
    }
}

public protocol DeclaratableToggleAppearance {
    var appearance: ToggleView.Appearance { get nonmutating set }
    
    func toggleHeight(_ height: CGFloat) -> Self
}

extension DeclaratableToggleAppearance {
    @discardableResult
    public func toggleHeight(_ height: CGFloat) -> Self {
        appearance.height = height
        return self
    }
}
