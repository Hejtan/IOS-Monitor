import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        // Map Tab
        let mapVC = MapViewController()
        mapVC.view.backgroundColor = .systemBlue
        mapVC.tabBarItem = UITabBarItem(title: "Map", image: UIImage(systemName: "map"), tag: 0)
        let mapNavVC = UINavigationController(rootViewController: mapVC)

        // Home Tab
        let homeVC = HomeViewController()
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
        let homeNavVC = UINavigationController(rootViewController: homeVC)

        // Settings Tab
        let settingsVC = UIViewController()
        settingsVC.view.backgroundColor = .systemGray
        settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gearshape"), tag: 2)
        let settingsNavVC = UINavigationController(rootViewController: settingsVC)

        // Tab Bar Controller
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [homeNavVC, mapNavVC, settingsNavVC]
        tabBarController.selectedIndex = 0 // Start with Home

        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()

        return true
    }
}
