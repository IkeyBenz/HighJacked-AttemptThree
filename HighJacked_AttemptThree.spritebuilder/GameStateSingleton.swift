//
//  Singleton.swift
//  Seige
//
//  Created by Luke Solomon on 7/16/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import UIKit

class GameStateSingleton: NSObject {
    
//    var score:Int = NSUserDefaults.standardUserDefaults().integerForKey("score") {
//        didSet {
//            NSUserDefaults.standardUserDefaults().setObject(score, forKey:"score")
//        }
//    }
//    
    var adsEnabled: Bool = NSUserDefaults.standardUserDefaults().boolForKey("adsEnabled") {
        didSet {
            NSUserDefaults.standardUserDefaults().setObject(adsEnabled, forKey:"adsEnabled")
        }
    }
    var vibrationEnabled: Bool = NSUserDefaults.standardUserDefaults().boolForKey("VibrationEnabled") {
        didSet {
            NSUserDefaults.standardUserDefaults().setBool(vibrationEnabled, forKey: "VibrationEnabled")
        }
    }
    
    class var sharedInstance : GameStateSingleton {
        struct Static {
            static let instance : GameStateSingleton = GameStateSingleton()
        }
        return Static.instance
    }
    
}