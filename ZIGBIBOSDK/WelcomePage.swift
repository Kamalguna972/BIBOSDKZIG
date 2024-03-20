// CustomDialogBox.swift

import UIKit

public protocol PresenterDelegate {
    func showAlert()
}
public protocol OnboardingDelegate {
    func startOnboarding(title: String, subtitle: String, number: Int) -> UIViewController
}
public protocol StopRequestDelegate {
    func StopRequest(title: String, subtitle: String, number: Int) -> UIViewController
}
public protocol SosRequestDelegate {
    func SosRequest(title: String, subtitle: String, number: Int) -> UIViewController
}
