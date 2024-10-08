//
//  USAppDelegate.m
//  USReader
//
//  Created by nongyun.cao on 12/03/2023.
//  Copyright (c) 2023 nongyun.cao. All rights reserved.
//

#import "USAppDelegate.h"

@implementation USAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // 在App启动后开启远程控制事件, 接收来自锁屏界面和上拉菜单的控制
    [application beginReceivingRemoteControlEvents];
    self.window.backgroundColor = [UIColor whiteColor];
    [UINavigationBar appearance].backgroundColor = [UIColor whiteColor];
    [UINavigationBar appearance].barTintColor = [UIColor whiteColor];

    if (@available(iOS 13.0, *)) {
        UITabBarAppearance *appearance = [[UITabBarAppearance alloc] init];
        [appearance configureWithDefaultBackground];
        [UITabBar appearance].standardAppearance = appearance;
        if (@available(iOS 15.0, *)) {
            [UITabBar appearance].scrollEdgeAppearance = appearance;
        } else {
            // Fallback on earlier versions
        }
    } else {
        // Fallback on earlier versions
    }


    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        [appearance configureWithOpaqueBackground];
        appearance.backgroundColor = [UIColor whiteColor];
        [UINavigationBar appearance].standardAppearance = appearance;
        [UINavigationBar appearance].scrollEdgeAppearance = appearance;
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // 在App要终止前结束接收远程控制事件, 也可以在需要终止时调用该方法终止
    [application endReceivingRemoteControlEvents];
}

@end
