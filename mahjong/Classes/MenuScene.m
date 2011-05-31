//
//  MehuScene.m
//  Mahjongg
//
//  Created by GamePipe Iphone Dev on 7/28/09.
//  Copyright 2009 USC. All rights reserved.
//


#import "MenuScene.h"
#import "PlayScene.h"
#import "HighScoreScene.h"

@implementation MenuScene
-(id) init
{
	if (self == [super init])
	{
		
		[MenuItemFont setFontSize:25];
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
		//Sprite* backGround = [Sprite spriteWithFile:@"Bub.png"];
        //[backGround setPosition:ccp(160,240)];
		[menu alignItemsVerticallyWithPadding:10];
        [self addChild:menu z:1];
		//[self addChild:backGround z:0];
		
	}
	return self;
}

-(void)onStartGame: (id)sender
{
    [[Director sharedDirector] replaceScene:[FadeTransition transitionWithDuration:.5 scene:[PlayScene node]]];
}

-(void)onSound: (id)sender
{
	soundOn = !soundOn;
}
-(void)onHighScore: (id)sender
{
	[[Director sharedDirector] replaceScene:[FadeTransition transitionWithDuration:.5 scene:[HighScoreScene node]]];
		
}

@end
