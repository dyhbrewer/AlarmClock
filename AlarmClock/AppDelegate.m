//
//  AppDelegate.m
//  AlarmClock
//
//  Created by Xu on 15/12/16.
//  Copyright © 2015年 Xu. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    _NaozhongView=[[ViewController alloc]init];
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:_NaozhongView];
    self.window.rootViewController=nav;
    [self.window makeKeyAndVisible];
    
    //注册本地推送
    [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];//注册本地推送
    
    
    return YES;
}
//推送提醒
//#pragma mark 调用过用户注册通知方法之后执行（即调用完registerUser...方法后执行）
//- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
//{
//    NSLog(@"recive");
//}

//
//只有程序运行时才执行此
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
//    NSLog(@"%@",notification.alertBody);
//    UILabel*label = [[UILabel alloc]init];
//    label.frame = CGRectMake(0, 0, 160, 20);
//    label.layer.cornerRadius = 10;
//    label.backgroundColor = [UIColor blackColor];
//    label.text = notification.alertBody;
//    label.textColor = [UIColor whiteColor];
//    label.font = [UIFont systemFontOfSize:12];
//    label.textAlignment = NSTextAlignmentCenter;
//    
//    [self.window addSubview:label];
    
    //程序右上角提示
    NSLog(@"recive");
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
