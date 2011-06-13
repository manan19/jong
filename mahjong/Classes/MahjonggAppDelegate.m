//
//  MahjonggAppDelegate.m
//  Mahjongg
//
//  Created by GamePipe Iphone Dev on 7/28/09.
//  Copyright USC 2009. All rights reserved.
//

#import "MahjonggAppDelegate.h"
#import "MenuScene.h"
#include "SimpleAudioEngine_objc.h"


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
    
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"opener.wav"];
    
    gameView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [placeHolderViewController.view addSubview:gameView];

    
    soundOn = true;
        // Setup for high scores
	scoreManager = [[ScoreManager alloc] init];
	[scoreManager readBestTimes];
    if([ScoreManager _isGameCenterAvailable])
    {
        leaderboardController = [[GKLeaderboardViewController alloc] init];
    }
    else
    {
        //[gameCenterButton removeFromSuperview];
    }
    
        //[[Director sharedDirector] setLandscape:YES];
	[[Director sharedDirector] setDeviceOrientation:CCDeviceOrientationPortrait];
    [[Director sharedDirector] attachInView:gameView];
	
	MenuScene *scene = [MenuScene node];
	[[Director sharedDirector] runWithScene:scene];

    // Setup Ads if NOT Ad Free
    adManager = [[AdManager alloc] init:placeHolderViewController];

    [[SimpleAudioEngine sharedEngine] preloadEffect:@"deselect.wav"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"select.wav"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"error.wav"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"opener.wav"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"removeTile.wav"];
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

- (ScoreManager*) getScoreMananger
{
    return scoreManager;
}

- (void) showLeaderboard
{
    if (leaderboardController != nil)
    {
        leaderboardController.leaderboardDelegate = self;
        [placeHolderViewController presentModalViewController: leaderboardController animated: YES];
    }
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
    [placeHolderViewController dismissModalViewControllerAnimated:YES];
}

- (void)dealloc {
    [adManager release];
    [gameView release];
    [placeHolderViewController release];
    [scoreManager release];
    [leaderboardController release];
	[window release];
    [super dealloc];
}


@end
