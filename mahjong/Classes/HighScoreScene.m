//
//  HighScoreScene.m
//  Mahjongg
//
//  Created by GamePipe iPhone Dev on 9/21/09.
//  Copyright 2009 USC. All rights reserved.
//

#import "HighScoreScene.h"
#import "MenuScene.h"


@implementation HighScoreScene

-(id) init
{
	if (self == [super init])
	{
		NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
		int score = [prefs integerForKey:@"highscore"];
		
		Label* scoreLabel = [Label labelWithString:[NSString stringWithFormat:@"%d",score] fontName:@"Arial" fontSize:25];
		[scoreLabel setPosition:ccp(160,240)];
		[self addChild:scoreLabel z:2];
		
		Sprite* backGround = [Sprite spriteWithFile:@"Bub.png"];
		[backGround setPosition:ccp(160,240)];
		[self addChild:backGround z:1];
		[MenuItemFont setFontSize:25]; 
		MenuItem *back = [MenuItemFont itemFromString:@"Back"  target:self selector:@selector(onBack:)];
		Menu *menu = [Menu menuWithItems:back,nil];
        [menu setPosition:ccp(280,30)];
        [self addChild:menu z:2];
		
	}
	return self;
}

-(void)onBack: (id)sender
{
	[[Director sharedDirector] replaceScene:[FadeTransition transitionWithDuration:.5 scene:[MenuScene node]]];
}

@end
