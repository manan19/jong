//
//  MahjonggAppDelegate.m
//  Mahjongg
//
//  Created by GamePipe Iphone Dev on 7/28/09.
//  Copyright USC 2009. All rights reserved.
//

#import "MahjonggAppDelegate.h"
#import "MenuScene.h"

void uncaughtExceptionHandler(NSException *exception) {
    [FlurryAPI logError:@"Uncaught" message:@"Crash!" exception:exception];
}

@implementation MahjonggAppDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application {
        // Analytics
	NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
	[FlurryAPI setAppVersion:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
    [FlurryAPI startSession:@"Z5QYWFGYXY6B2ZTANRZV"];
    
        // View heirarchy setup
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [window setUserInteractionEnabled:YES];
    [window setMultipleTouchEnabled:YES];
    [window makeKeyAndVisible];
    
    placeHolderViewController = [[UIViewController alloc] init];
    [window addSubview:placeHolderViewController.view];

    gameView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [placeHolderViewController.view addSubview:gameView];

        // Setup Ads if NOT Ad Free
    adManager = [[AdManager alloc] init:placeHolderViewController];
    [adManager setParentView:placeHolderViewController.view andPosition:FALSE];
    
        //[[Director sharedDirector] setLandscape:YES];
	[[Director sharedDirector] setDeviceOrientation:CCDeviceOrientationPortrait];
    [[Director sharedDirector] attachInView:gameView];
	
	MenuScene *scene = [MenuScene node];
	[[Director sharedDirector] runWithScene:scene];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)dealloc {
    [adManager release];
    [gameView release];
    [placeHolderViewController release];
	[window release];
    [super dealloc];
}


@end
