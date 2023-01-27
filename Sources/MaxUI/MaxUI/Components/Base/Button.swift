import UIKit
import Combine

public struct Button: ComponentViewModelProtocol {
    
    public typealias ViewType = ButtonView
    
    public var title: String? {
        get { _title.value }
        nonmutating set { _title.send(newValue) }
    }
                          
    public var label: ViewableViewModelProtocol? {
        get { _label.value }
        nonmutating set { if let newValue { _label.send(newValue) } }
    }
                          
    public var action: (() -> Void)? {
        get { _action.value }
        nonmutating set { _action.send(newValue) }
    }
    
    public var appearance: ButtonView.Appearance {
        get { _appearance.value }
        nonmutating set { _appearance.send(newValue) }
    }
        
    fileprivate let _title: CurrentValueSubject<String?, Never>
    fileprivate let _action: CurrentValueSubject<(() -> Void)?, Never>
    fileprivate let _appearance: CurrentValueSubject<ButtonView.Appearance, Never>
    fileprivate let _label: CurrentValueSubject<ViewableViewModelProtocol?, Never>
    
    public init(
        _ title: String?,
        _ action: (() -> Void)?
    ) {
        self._title = .init(title)
        self._label = .init(nil)
        self._appearance = .init(ButtonView.Appearance())
        self._action = .init(action)
    }
    
    public init(
        _ action: (() -> Void)?,
        label: () -> ViewableViewModelProtocol
    ) {
        self._title = .init(nil)
        self._label = .init(label())
        self._appearance = .init(ButtonView.Appearance())
        self._action = .init(action)
    }
}

public final class ButtonView: TapableView {
    private var text: Text?
    private var container: Container?
    private var appearance: Appearance?
    private var cancellables = Set<AnyCancellable>()
    
    override public var tapAreaInset: UIEdgeInsets {
        appearance?.tapAreaInset ?? .zero
    }
}

extension ButtonView: ReusableView {
    
    public func configure(with data: Button) {
        data._title
            .compactMap { $0 }
            .sink(receiveValue: { [weak self] text in
                let textModel = Text(text)
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
                    model: VStack {
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
private extension ButtonView {
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
extension ButtonView {
    public struct Appearance: Equatable, Withable {
        public var textAppearance: TextView.Appearance
        public var containerAppearance: ContainerView.Appearance
        public var isEnabled: Bool
        public var highlightBehavior: TapableView.HighlightBehavior
        public var tapAreaInset: UIEdgeInsets
        
        public init(
            textAppearance: TextView.Appearance = TextView.Appearance(textAligment: .center),
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

extension Button: DeclaratableTextAppearance, DeclaratableContainerViewAppearance {
    public var textAppearance: TextView.Appearance {
        get { appearance.textAppearance }
        nonmutating set { appearance.textAppearance = newValue }
    }

    public var containerAppearance: ContainerView.Appearance? {
        get { appearance.containerAppearance }
        nonmutating set { if let newValue { appearance.containerAppearance = newValue } }
    }
    
    @discardableResult
    public func isEnabled(_ isEnabled: Bool) -> Button {
        self.appearance.isEnabled = isEnabled
        return self
    }
    
    @discardableResult
    public func highlightBehavior(
        _ highlightBehavior: TapableView.HighlightBehavior
    ) -> Button {
        self.appearance.highlightBehavior = highlightBehavior
        return self
    }
    
    @discardableResult
    public func tapAreaInset(_ tapAreaInset: UIEdgeInsets) -> Button {
        self.appearance.tapAreaInset = tapAreaInset
        return self
    }
}

extension Button: Stylable {
    public func style(_ appearance: ButtonView.Appearance) -> Self {
        self.appearance = appearance
        return self
    }
}

#if DEBUG
import SwiftUI
struct Button_Previews: PreviewProvider {
    static var previews: some View {
        ComponentPreview(distribution: .center) {
            VStack {
                VStack {
                    Button("Button") {}
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
