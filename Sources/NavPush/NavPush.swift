import SwiftUI
import Introspect

public struct NavPush {
    let navigation: UINavigationController?
    let uiViewController: UIViewController

    init(_ uiViewController: UIViewController) {
        self.uiViewController = uiViewController
        navigation = uiViewController.navigationController
    }
    public func isLastView() -> Bool {
        return navigation?.viewControllers.last == uiViewController
    }

    public func dissmissAll() {
        while navigation?.viewControllers.count ?? 0 > 1 {
            navigation?.viewControllers.removeLast()
        }
    }

    public func push<Content: View>(animated: Bool = true, _ view: () -> Content) {
        let vc = UIHostingController(rootView: view())
        navigation?.pushViewController(vc, animated: animated)
    }

    public func add<Content: View>(_ view: () -> Content) {
        let vc = UIHostingController(rootView: view())
        navigation?.viewControllers.append(vc)
    }

    public var count: Int {
        navigation?.viewControllers.count ?? 0
    }

    static var navigations = [String : NavPush]()

    public static subscript(_ name: String) -> NavPush? {
        navigations[name]
    }
}

public extension View {
    func navPush(callBack: @escaping (NavPush) -> ()) -> some View {
        self.modifier(NavPushModifier(callBack: callBack))
    }

    func navPush(_ name: String) -> some View {
        self.modifier(NavPushModifier {
            NavPush.navigations[name] = $0
        })
    }
}

struct NavPushModifier: ViewModifier {
    let callBack: (NavPush) -> ()

    func body(content: Content) -> some View {
        content
            .introspectViewController { view in
                callBack(NavPush(view))
            }
    }
}
