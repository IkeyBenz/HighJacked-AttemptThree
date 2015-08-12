//
//  StoreKitHandler.swift
//  HighJacked_AttemptThree
//
//  Created by Ikey Benzaken on 8/11/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation
import StoreKit

class StoreKitHandler: NSObject {
    
    var productsRequest: SKProductsRequest!
    var productIdentifiers: NSSet = ["org.cocos2d.Hijacked_AttemptThree.RemoveAds"]
    var purchasedProductionIdentifiers: NSMutableSet!
    
    class var sharedInstance : StoreKitHandler {
        struct Static {
            static let instance : StoreKitHandler = StoreKitHandler()
        }
        return Static.instance
    }
    
    func initWithProductIdentifiers(tempProductIdentifiers: NSSet) {
        
        productIdentifiers = tempProductIdentifiers
        
        // Check for previously purchased products
        for productIdentifier in productIdentifiers {
            var productPurchased: Bool = NSUserDefaults.standardUserDefaults().boolForKey(productIdentifier as! String)
            
            if productPurchased {
                purchasedProductionIdentifiers.addObject(productIdentifier)
                println("Previously purchased \(productIdentifier)")
            }
        }
    }
}

extension StoreKitHandler:  SKProductsRequestDelegate {
    func productsRequest(request: SKProductsRequest!, didReceiveResponse response: SKProductsResponse!) {
        println("Loaded list of products")
        
        productsRequest = nil
        
        var skProducts: Array = response.products
        
        for skProduct in skProducts {
            println("Found product \(skProduct.productIdentifier), \(skProduct.localizedTitle), \(skProduct.price)")
        }
        
        
    }
    
    func request(request: SKRequest!, didFailWithError error: NSError!) {
        println("Failed to load list of products")
        productsRequest = nil
    }
    
    func requestDidFinish(request: SKRequest!) {
        
    }
}