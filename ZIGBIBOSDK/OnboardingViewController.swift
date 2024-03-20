//
//  OnbordingViewController.swift
//  ZIGBIBOSDK
//
//  Created by apple on 15/03/24.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    @IBOutlet weak var titleLable: UILabel!
    
    @IBOutlet weak var backview: UIView!
    @IBOutlet weak var numlable: UILabel!
    @IBOutlet weak var Sublable: UILabel!
    static var title = ""
    static var subtitle = ""
    static var number = 0
    override func viewDidLoad() {
        super.viewDidLoad()
//        titleLable.text = OnboardingViewController.title
//        Sublable.text = OnboardingViewController.subtitle
//        numlable.text = "\(OnboardingViewController.number)"
        backview.layer.cornerRadius = backview.frame.height/2 - 10
    }
}
