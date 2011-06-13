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
#import "SimpleAudioEngine_objc.h"

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
        
        
        
        MenuItem *start = [MenuItemFont itemFromString:@"StartGame" target:self  selector:@selector(onStartGame:)];
		MenuItemToggle *sound; 
        
        Sprite* bgImage = [Sprite spriteWithFile:@"Default.png"];
        [bgImage setPosition:ccp(160,240)];
        [self addChild:bgImage];
        
        MahjonggAppDelegate* appDel = (MahjonggAppDelegate*)[UIApplication sharedApplication];
        
		if (appDel->soundOn)
		{
			sound = [MenuItemToggle itemWithTarget:self selector:@selector(onSound:) items:[MenuItemFont itemFromString: @"Sound: ON"],[MenuItemFont itemFromString: @"Sound: OFF"],nil];
		}
		else 
		{
			sound = [MenuItemToggle itemWithTarget:self selector:@selector(onSound:) items:[MenuItemFont itemFromString: @"Sound: OFF"],[MenuItemFont itemFromString: @"Sound: ON"],nil];
		}
		MenuItem *highScore = [MenuItemFont itemFromString:@"HighScore"  target:self selector:@selector(onHighScore:)];
        MenuItem *instructions = [MenuItemFont itemFromString:@"Instructions"  target:self selector:@selector(onInstructions:)];
        
        Menu *menu;
        if([ScoreManager _isGameCenterAvailable])
            menu = [Menu menuWithItems:start, instructions,highScore, sound,nil];
        else
            menu = [Menu menuWithItems:start, instructions, sound,nil];
        [menu setPosition:ccp(160,210)];
		[menu alignItemsVerticallyWithPadding:10];
        [self addChild:menu z:1];
        [menu setColor:ccc3(0, 0, 0)];
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
    MahjonggAppDelegate* appDel = (MahjonggAppDelegate*)[UIApplication sharedApplication];
	appDel->soundOn = !(appDel->soundOn);
    [[SimpleAudioEngine sharedEngine] setMute:!appDel->soundOn];
}
-(void)onHighScore: (id)sender
{
	[(MahjonggAppDelegate*)[[UIApplication sharedApplication] delegate] showLeaderboard];
}

-(void)onInstructions: (id)sender
{
	InstructionsLayer* l = [[[InstructionsLayer alloc] initWithColor:ccc4(0,120,0,255)] autorelease];
    [[self parent] addChild:l];
    [[self parent] removeChild:self cleanup:YES];
}

@end

@implementation InstructionsLayer

-(id)initWithColor:(ccColor4B)color
{
    if ((self == [super initWithColor:color]))
    {
        Sprite* bgImage = [Sprite spriteWithFile:@"instructions1.png"];
        [bgImage setPosition:ccp(160,320)];
        [bgImage setScale:0.8f];
        [self addChild:bgImage];
        
        Label* l1 = [Label labelWithString:@"1. Match same tiles to clear them." dimensions:CGSizeMake(320, 30) alignment:UITextAlignmentLeft fontName:[MenuItemFont fontName] fontSize:15];
        Label* l2 = [Label labelWithString:@"2. Only tiles on top which are not covered on left and right sides are selectable." dimensions:CGSizeMake(320, 50) alignment:UITextAlignmentLeft fontName:[MenuItemFont fontName] fontSize:15];
        
        Label* l3 = [Label labelWithString:@"3. Clear all the tiles as fast as you can. Compare scores on Game Center." dimensions:CGSizeMake(320, 50) alignment:UITextAlignmentLeft fontName:[MenuItemFont fontName] fontSize:15];
        
        [l1 setPosition:ccp(170,155)];
        [l2 setPosition:ccp(170,125)];
        [l3 setPosition:ccp(170,90)];
        
        [self addChild:l1];
        [self addChild:l2];
        [self addChild:l3];
        
        MenuItemFont* back = [MenuItemFont itemFromString:@"Back" target:self selector:@selector(Back:)];
        Menu* menu = [Menu menuWithItems:back, nil];
        [menu setPosition:ccp(160,65)];
        [menu setColor:ccc3(0, 0, 0)];
        [self addChild:menu];
        
    }
    return self;
}

-(void)Back:(id)sender
{
    MenuLayer* n = [[[MenuLayer alloc] initWithColor:ccc4(0,120,0,255)] autorelease];
    [[self parent] addChild:n];
    [[self parent] removeChild:self cleanup:YES];
}


@end












