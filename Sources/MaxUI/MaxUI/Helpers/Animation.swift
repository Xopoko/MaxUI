import UIKit

enum Animation {
    enum Duration {
        /// `0.0`
        case none
        /// `0.1`
        case quick
        /// `0.25`
        case `default`
        /// `0.4`
        case medium
        /// `1.0`
        case long
        case custom(_ duration: TimeInterval)

        /// Convenient way to run or ignore animation withing one line of code.
        subscript(_ enabled: Bool) -> Duration {
            return enabled ? self : .none
        }

        var value: TimeInterval {
            switch self {
            case .none: return 0
            case .quick: return 0.1
            case .default: return 0.25
            case .medium: return 0.4
            case .long: return 1.0
            case .custom(let duration): return duration
            }
        }
    }

    enum Action {
        case `default`
        case start
        case end
        case linear
    }

    case `default`
    case physical
    case transition(_ view: UIView)
}

// MARK: - Public Functions
extension Animation {

    func run(
        _ duration: Duration = .default,
        delay: TimeInterval = 0,
        action: Action = .default,
        animations: @escaping () -> Void,
        completion: (() -> Void)? = nil
    ) {
        let options = action.options(forAnimation: self)

        switch self {
        case .default:
            UIView.animate(
                withDuration: duration.value,
                delay: delay,
                options: options,
                animations: animations,
                completion: { _ in completion?() })
        case .physical:
            UIView.animate(
                withDuration: duration.value,
                delay: delay,
                usingSpringWithDamping: 0.5,
                initialSpringVelocity: 3,
                options: options,
                animations: animations,
                completion: { _ in completion?() })
        case .transition(let view):
            let action = {
                UIView.transition(
                    with: view,
                    duration: duration.value,
                    options: options,
                    animations: animations,
                    completion: { _ in completion?() })
            }
            if delay.isZero {
                action()
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: action)
            }
        }
    }
}

// MARK: - Animation.Action Extension
extension Animation.Action {
    func options(forAnimation animation: Animation) -> UIView.AnimationOptions {
        var options: UIView.AnimationOptions = {
            switch self {
            case .default: return [.allowUserInteraction, .curveEaseInOut]
            case .start: return [.allowUserInteraction, .curveEaseOut]
            case .end: return [.allowUserInteraction, .curveEaseIn]
            case .linear: return [.allowUserInteraction, .curveLinear]
            }
        }()

        switch animation {
        case .transition:
            options.insert(.transitionCrossDissolve)
        default:
            break
        }

        return options
    }
}
