//
//  AppDelegate.m
//  are you down
//
//  Created by Robert Crosby on 5/18/17.
//  Copyright © 2017 Robert Crosby. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[NSUserDefaults standardUserDefaults] setObject:@" " forKey:@"updateFriends"];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    //[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"name"];
    //[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"phone"];
    //NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"phone"]);
    [[NSUserDefaults standardUserDefaults] synchronize];
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
        if( !error ){
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        } else {
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"token"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"phone"]) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPhone4" bundle:nil];
            UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"homeView"];
            self.window.rootViewController = viewController;
            [self.window makeKeyAndVisible];
        } else {
        UIStoryboard *iPhone4Storyboard = [UIStoryboard storyboardWithName:@"iPhone4" bundle:nil];
        UIViewController *initialViewController = [iPhone4Storyboard instantiateInitialViewController];
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.rootViewController  = initialViewController;
        [self.window makeKeyAndVisible];
        }
    // Override point for customization after application launch.
    return YES;
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken {
    const unsigned *tokenBytes = [deviceToken bytes];
    NSString *hexToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    NSLog(@"%@",hexToken);
    [[NSUserDefaults standardUserDefaults] setObject:hexToken forKey:@"token"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

-(void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(nonnull NSError *)error {
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    
    //Called when a notification is delivered to a foreground app.
    [[NSUserDefaults standardUserDefaults] setObject:@"Message Recieved" forKey:@"refreshMessages"];
    NSLog(@"Userinfo %@",notification.request.content.userInfo);
    
    completionHandler(UNNotificationPresentationOptionAlert);
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    NSInteger badgeCount = [[NSUserDefaults standardUserDefaults] integerForKey:@"updateFriends"];
    badgeCount++;
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: badgeCount];
    //Called to let your app know which action was selected by the user for a given notification.
    
    NSLog(@"Userinfo %@",response.notification.request.content.userInfo);
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}



- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
