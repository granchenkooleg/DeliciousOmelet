//
//  BaseViewController.swift
//  DeliciousOmelet
//
//  Created by Oleg on 3/26/17.
//  Copyright © 2017 Oleg. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    var spiner = UIActivityIndicatorView()
    
    @IBInspectable var statusBarDefault = false
    
    @IBOutlet weak var navigationBar: UIView?
    
    var viewAppeared = false
   
    
    override func loadView() {
        super.loadView()
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    func shouldUsePreferredViewFrame() -> Bool {
        return true
    }
    
    static var lastAppearedScreenName: String?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewAppeared = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewAppeared = false
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return [.portrait, .portraitUpsideDown]
    }
    
}
