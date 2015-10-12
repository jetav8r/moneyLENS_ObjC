//
//  AppDelegate.m
//  moneyLENS_Obj_C
//
//  Created by Wayne Johnson on 9/6/15.
//  Copyright © 2015 Wayne Johnson. All rights reserved.
//

#import "AppDelegate.h"
#import <Moodstocks/Moodstocks.h>

#define MS_API_KEY @"y3l7tb1jxy6ayq2vm8a7"
#define MS_API_SECRET @"pIr970jUudsFagKK"

@interface AppDelegate ()

@end

@implementation AppDelegate {
	MSScanner *_scanner;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	NSString *path = [MSScanner cachesPathFor:@"scanner.db"];
	_scanner = [[MSScanner alloc] init];
	[_scanner openWithPath:path key:MS_API_KEY secret:MS_API_SECRET error:nil];
	[_scanner openWithPath:path key:MS_API_KEY secret:MS_API_SECRET error:nil];
	//[_scanner syncInBackground]; simple version with no progress code
	// Create the progression and completion blocks:
	void (^completionBlock)(MSSync *, NSError *) = ^(MSSync *op, NSError *error) {
		if (error)
			NSLog(@"Sync failed with error: %@", [error ms_message]);
		else
			NSLog(@"Sync succeeded (%li images(s))", (long)[_scanner count:nil]);
	};
	
	void (^progressionBlock)(NSInteger) = ^(NSInteger percent) {
		NSLog(@"Sync progressing: %li%%", (long)percent);
	};
	
	// Launch the synchronization
	[_scanner syncInBackgroundWithBlock:completionBlock progressBlock:progressionBlock];
	
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	ScannerViewController *scannerVC = [[ScannerViewController alloc] init];
	scannerVC.scanner = _scanner;
	self.window.rootViewController = scannerVC;
	[self.window makeKeyAndVisible];
	

	return YES;
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
	[_scanner close:nil];
}

@end
