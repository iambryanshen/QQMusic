//
//  AppDelegate.swift
//  QQMusic
//
//  Created by brian on 2018/4/2.
//  Copyright © 2018年 Brian Inc. All rights reserved.
//

/*
 锁屏信息实现：
 
 在程序失去焦点时，在CADisplayLink定时器事件中执行以下步骤
 1. 获取锁屏信息中心
 2. 设置锁屏信息
 3. 接收远程事件
 
在程序获得焦点时，移除定时器
 */

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var displayLink: CADisplayLink?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        addDisplayLink()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        removeDisplayLink()
    }
}

extension AppDelegate {
    
    func addDisplayLink() {
        displayLink = CADisplayLink(target: self, selector: #selector(updateLockMessage))
        displayLink?.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
    }
    
    func removeDisplayLink() {
        displayLink?.invalidate()
        displayLink = nil
    }
    
    @objc
    func updateLockMessage() {
        QQDetailVM.share.setupLockScreen()
    }
}
