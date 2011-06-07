//
//  MehuScene.m
//  Mahjongg
//
//  Created by GamePipe Iphone Dev on 7/28/09.
//  Copyright 2009 USC. All rights reserved.
//


#import "MenuScene.h"
#import "PlayScene.h"
#import "MahjonggAppDelegate.h"

@implementation MenuScene
-(id) init
{
	if (self == [super init])
	{
		MenuLayer* m = [[[MenuLayer alloc] initWithColor:ccc4(0, 120, 0, 255)] autorelease] ;
        [self addChild:m];
	}
	return self;
}



@end

@implementation MenuLayer 

-(id)initWithColor:(ccColor4B)color
{
    if ((self ==  [super initWithColor:color]))
    {
        [MenuItemFont setFontSize:25];
        [MenuItemFont setFontName:@"American Typewriter"];
		soundOn = TRUE;
        MenuItem *start = [MenuItemFont itemFromString:@"StartGame" target:self  selector:@selector(onStartGame:)];
		MenuItemToggle *sound; 
        
		if (soundOn)
		{
			sound = [MenuItemToggle itemWithTarget:self selector:@selector(onSound:) items:[MenuItemFont itemFromString: @"SoundOn"],[MenuItemFont itemFromString: @"SoundOff"],nil];
		}
		else 
		{
			sound = [MenuItemToggle itemWithTarget:self selector:@selector(onSound:) items:[MenuItemFont itemFromString: @"SoundOff"],[MenuItemFont itemFromString: @"SoundOn"],nil];
		}
		MenuItem *highScore = [MenuItemFont itemFromString:@"HighScore"  target:self selector:@selector(onHighScore:)];
		Menu *menu = [Menu menuWithItems:start, highScore, sound,nil];
		[menu alignItemsVerticallyWithPadding:10];
        [self addChild:menu z:1];
    }
    return self;
}

-(void)onStartGame: (id)sender
{
    [[self parent] removeChild:self cleanup:YES];
    [[Director sharedDirector] replaceScene:[PlayScene node]];
}

-(void)onSound: (id)sender
{
	soundOn = !soundOn;
}
-(void)onHighScore: (id)sender
{
	[(MahjonggAppDelegate*)[[UIApplication sharedApplication] delegate] showLeaderboard];
}

@end



