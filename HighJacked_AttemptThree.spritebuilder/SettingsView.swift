//
//  SettingsView.swift
//  HighJacked_AttemptThree
//
//  Created by Ikey Benzaken on 8/7/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

var shouldVibrate: Bool!

class SettingsView: CCNode {
    weak var vibrateLabel: CCLabelTTF!
    weak var vibrateButton: CCButton!
    
    
    func didLoadFromCCB(){
        updateLabel()
    }
    
    func updateLabel () {
        if GameStateSingleton.sharedInstance.vibrationEnabled == true {
            vibrateLabel.string = "Vibration: On"
            shouldVibrate = true
        } else if GameStateSingleton.sharedInstance.vibrationEnabled == false {
            vibrateLabel.string = "Vibration: Off"
            shouldVibrate = false
        }
    }
    
    func vibrateSelector() {
//        var vibration = !defaults.boolForKey("VibrationIsSelected")
        
        
        if GameStateSingleton.sharedInstance.vibrationEnabled == true {
            GameStateSingleton.sharedInstance.vibrationEnabled = false
            
        } else if GameStateSingleton.sharedInstance.vibrationEnabled == false {
            GameStateSingleton.sharedInstance.vibrationEnabled = true
        }
        
        updateLabel()
    }
    
    
    
    
    
}