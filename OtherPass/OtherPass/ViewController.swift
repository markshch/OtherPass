//
//  ViewController.swift
//  TestApp
//
//  Created by Mark ⠀ on 3/18/22.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let swiftUIview = NavigationTest().environmentObject(MyAppEnvironmentData())
//        let swiftUIview = ItemsView(group: Group())
        
        
        let uiViewController = UIHostingController(rootView: swiftUIview)
        uiViewController.modalPresentationStyle = .fullScreen
        present(uiViewController, animated: true)
    }
    
}
    


