import ApiClient
import ConfirmationAlert
import Models
import MyRidesFeature
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else {
      return
    }
    window = UIWindow(windowScene: windowScene)
    let viewController = RidesTableViewController(viewModel: .init(apiClient: LiveApiClient()))
    let navigation = UINavigationController(rootViewController: viewController)
    window?.rootViewController = navigation
    window?.makeKeyAndVisible()
  }
}
