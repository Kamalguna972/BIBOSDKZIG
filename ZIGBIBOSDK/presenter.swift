import Foundation
import UIKit

public class Presenter {
    private let presenterImpl: PresenterDelegate
    private let onboardingImpl: OnboardingDelegate
    private let stopRequestImpl: StopRequestDelegate
    
    // Change initializer access level to internal
    public init() {
        self.presenterImpl = PresenterImpl()
        self.onboardingImpl = OnboardingPresenterImpl()
        self.stopRequestImpl = StopRequestpresenter()
    }
    
    // Exposing a method to trigger the alert
    public func triggerAlert() {
        presenterImpl.showAlert()
    }
    
    public func startOnboarding(title: String, subtitle: String, number: Int) -> UIViewController {
        return onboardingImpl.startOnboarding(title: title, subtitle: subtitle, number: number)
    }
    
    public func stopRequest(title: String, subtitle: String, number: Int) -> UIViewController {
        return stopRequestImpl.StopRequest(title: title, subtitle: subtitle, number: number)
    }
    public func SosRequest(title: String, subtitle: String, number: Int) -> UIViewController {
        return stopRequestImpl.StopRequest(title: title, subtitle: subtitle, number: number)
    }
}

