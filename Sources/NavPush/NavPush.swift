import SwiftUI
import Introspect

public struct NavPush {
    let navigation: UINavigationController?

    init(_ uiViewController: UIViewController) {
        navigation = uiViewController.navigationController
    }

    public func push<Content: View>(content: () -> (Content)) {
        navigation?.pushViewController(UIHostingController(rootView: content()), animated: true)
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
