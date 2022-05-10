import SwiftUI
import Introspect

public struct NavPush {
    let navigation: UINavigationController?
    let uiViewController: UIViewController

    init(_ uiViewController: UIViewController) {
        self.uiViewController = uiViewController
        navigation = uiViewController.navigationController
    }

    public func push<Content: View>(content: () -> (Content)) {
        navigation?.pushViewController(UIHostingController(rootView: content()), animated: true)
    }

    public func isLastView() -> Bool {
        return navigation?.viewControllers.last == uiViewController
    }
}

public extension View {
    func navPush(callBack: @escaping (NavPush) -> ()) -> some View {
        self.modifier(NavPushModifier(callBack: callBack))
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
