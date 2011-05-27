//
//  MahjonggAppDelegate.m
//  Mahjongg
//
//  Created by GamePipe Iphone Dev on 7/28/09.
//  Copyright USC 2009. All rights reserved.
//

#import "MahjonggAppDelegate.h"
#import "MenuScene.h"


@implementation MahjonggAppDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [window setUserInteractionEnabled:YES];
    [window setMultipleTouchEnabled:YES];

	
	//[[Director sharedDirector] setLandscape:YES];
	[[Director sharedDirector] setDeviceOrientation:CCDeviceOrientationLandscapeLeft];
    [[Director sharedDirector] attachInWindow:window];
	
    [window makeKeyAndVisible];	
	
	MenuScene *scene = [MenuScene node];
	[[Director sharedDirector] runWithScene:scene];
}


- (void)dealloc {
	[window release];
    [super dealloc];
}


@end
