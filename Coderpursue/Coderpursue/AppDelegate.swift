//
//  AppDelegate.swift
//  Coderpursue
//
//  Created by wenghengcong on 15/12/22.
//  Copyright © 2015年 JungleSong. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,WXApiDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.sharedManager().enable = true
        
        //bug 
//        CrashReporter.sharedInstance().enableLog(true)
        Bugly.startWithAppId(TencentBuglyAppID)
        
        //Umeng Social
        ShareHelper.sharedInstance.configUMSocailPlatforms()
        
        //Umeng 
        MobClick.startWithAppkey(UMengAppSecret, reportPolicy: BATCH, channelId: nil)
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        UMSocialSnsService.applicationDidBecomeActive()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        return UMSocialSnsService.handleOpenURL(url)
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        
        return UMSocialSnsService.handleOpenURL(url, wxApiDelegate: nil)
    }

    var authCodeDelegate: ((String)->Void)?

    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        guard let components = NSURLComponents(URL: url, resolvingAgainstBaseURL: false) else {
            return true
        }
        if components.scheme == "coderpursue" {
            if let code = components.queryItems?.filter({$0.name.lowercaseString == "code"}).first?.value {
                authCodeDelegate?(code)
            }
        }
        return true
    }

}

