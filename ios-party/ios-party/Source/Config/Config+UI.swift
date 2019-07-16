import UIKit

extension Config.UI {
    static var topSafeArea: CGFloat {
        return UIApplication.shared.windows[0].safeAreaInsets.top
    }
    static var botSafeArea: CGFloat {
        return UIApplication.shared.windows[0].safeAreaInsets.bottom
    }
}
