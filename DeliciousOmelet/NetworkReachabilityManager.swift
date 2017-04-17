//
//  NetworkReachabilityManager.swift
//  DeliciousOmelet
//
//  Created by Oleg on 3/26/17.
//  Copyright © 2017 Oleg. All rights reserved.
//

import Foundation
import Alamofire

private let manager = NetworkReachabilityManager(host: "http://www.recipepuppy.com/api/?i=onions,garlic&q=omelet&p=3")

let reachabilityManager = NetworkReachabilityManager(host: "http://www.recipepuppy.com/api/?i=onions,garlic&q=omelet&p=3")

func listenForReachability() {
    reachabilityManager?.listener = { status in
        print("Network Status Changed: \(status)")
        switch status {
        case .reachable:
            //Hide error state
            print("Internet connection")
        default: print ("")
        }
        
    }
    
    reachabilityManager?.startListening()
}

func isNetworkReachable() -> Bool {
    return manager?.isReachable ?? false
}
