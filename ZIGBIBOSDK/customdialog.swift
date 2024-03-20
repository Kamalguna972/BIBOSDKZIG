//
//  customdialog.swift
//  ZIGBIBOSDK
//
//  Created by apple on 15/03/24.
//



import UIKit
class PresenterImpl: PresenterDelegate {
    func showAlert() {
        let alertController = UIAlertController(title: "Welcome", message: "This is a sample alert.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
            rootViewController.present(alertController, animated: true, completion: nil)
        }
    }
}
 class OnboardingPresenterImpl: OnboardingDelegate {
    func startOnboarding(title: String, subtitle: String, number: Int) -> UIViewController {
        let storyboard = UIStoryboard(name: "OnboardingViewController", bundle: Bundle(for: OnboardingPresenterImpl.self))
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "OnboardingViewController") as! OnboardingViewController
        return loginViewController
    }
}
class StopRequestpresenter : StopRequestDelegate {
    func StopRequest(title: String, subtitle: String, number: Int) -> UIViewController {
        StopViewController.title = title
        StopViewController.subtitle = subtitle
        StopViewController.mainImage = "StopRequest"
        let storyboard = UIStoryboard(name: "stopFeature", bundle: Bundle(for: StopRequestpresenter.self))
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "StopViewController") as! StopViewController
        return loginViewController
    }
}
class sosRequest : StopRequestDelegate {
    func StopRequest(title: String, subtitle: String, number: Int) -> UIViewController {
        StopViewController.title = title
        StopViewController.subtitle = subtitle
        StopViewController.mainImage = "sos_images"
        let storyboard = UIStoryboard(name: "stopFeature", bundle: Bundle(for: StopRequestpresenter.self))
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "StopViewController") as! StopViewController
        return loginViewController
    }
}


