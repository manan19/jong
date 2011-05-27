//
//  PlayScene.m
//  Mahjongg
//
//  Created by GamePipe Iphone Dev on 7/28/09.
//  Copyright 2009 USC. All rights reserved.
//

#import "PlayScene.h"

int mainLayoutArray[10][36] = {
    
{	0,1,1,1,1,0,
    1,1,1,1,1,1,
    1,1,0,0,1,1,
    1,1,0,0,1,1,
    1,1,0,0,1,1,
    0,1,1,1,1,0},
    
{	0,1,1,1,1,0,
    1,1,1,1,1,1,
    1,1,0,0,1,1,
    1,1,2,2,1,1,
    1,1,0,0,1,1,
    0,1,1,1,1,0},
    
{	0,1,1,1,1,0,
    1,1,1,1,1,1,
    0,1,2,2,1,0,
    1,1,2,2,1,1,
    1,1,2,2,1,1,
    0,1,1,1,1,0},

{	0,1,2,2,1,0,
    1,1,1,1,1,1,
    0,2,2,2,2,0,
    1,1,2,2,1,1,
    1,1,2,2,1,1,
    0,2,1,1,2,0},
    
{	0,1,3,3,1,0,
    0,1,2,2,1,0,
    1,1,0,0,1,1,
    1,1,2,2,1,1,
    0,1,1,1,1,0,
    0,0,1,1,0,0},
    
{	0,0,1,1,0,1,
    0,0,1,2,0,0,
    1,1,3,3,1,1,
    1,1,2,1,1,1,
    0,0,1,1,0,0,
    1,0,1,1,0,0},


{	0,1,1,1,1,0,
	0,1,2,2,1,0,
	0,1,3,3,1,0,
	1,1,1,1,1,1,
	0,1,1,1,1,0,
	0,0,1,1,0,0},


{   1,1,1,1,1,1,
	1,2,2,2,2,1,
	1,2,1,1,2,1,
	1,2,2,2,2,1,
	1,1,1,1,1,1,
	0,0,0,0,0,0},


{   1,1,1,1,1,1,
	1,2,2,2,2,1,
	1,2,3,3,2,1,
	1,2,2,2,2,1,
	1,1,1,1,1,1,
	0,0,0,0,0,0},

{   0,1,0,0,1,0,
	0,2,2,2,2,0,
	1,1,2,2,1,1,
	1,1,2,2,1,1,
	1,1,1,1,1,1,
	2,1,0,0,1,2}
};


@implementation tileSprite

-(id)init
{
	self = [super init];
	return self;
}

-(void) setProperties :(int)tileIdentity :(CGPoint)pos :(BOOL)enable :(BOOL)rendered :(int) i :(int) j :(int) k
{
	tileID = tileIdentity;
	corner = pos;
	isEnabled= enable;
	isRendered = rendered;
	indexI = i;
	indexJ = j;
	indexK = k;
}


@end



@implementation PlayScene
-(id) init
{

	if ((self = [super init]))
	{
		Sprite* backGroundImage = [Sprite spriteWithFile:@"Bub.png"];
		[backGroundImage setPosition:ccp(160,240)];
		[self addChild:backGroundImage z:0];
		[self addChild:[BackgroundLayer node] z:0 tag:0];
		
	}
	return self;
}

-(void) finishGame
{
	[[self getChildByTag:0] removeAllChildrenWithCleanup:YES];
	//[self removeAllChildrenWithCleanup:YES];
	[[Director sharedDirector] replaceScene:[FadeTransition transitionWithDuration:.5 scene:[MenuScene node]]];
	
}

@end

@implementation BackgroundLayer

-(id) init
{
	if ((self = [super init]))
	{
		endGame = FALSE;		
		roundScore[0] = 600;
		roundScore[1] = 1200;
		roundScore[2] = 1800;
		timerScheduler = FALSE;
		manager = [AtlasSpriteManager spriteManagerWithFile:@"tiles.png" capacity:144];
		timerSprites = [AtlasSpriteManager spriteManagerWithFile:@"timer.png" capacity:25];
		
		[self addChild: manager z:0];
		[self addChild:timerSprites z:0];
		
		gameScore = 0;
		timeLeftCount = 0;
		tileScale = 1.5f;
		layerOffset = 7.0f;
		
		for (int i=0;i < 10;i++)
		{
			for (int j=0;j<36;j++)
			{
				layoutArray[i][j] = mainLayoutArray[i][j];
			}
		}
		
		[self setIsTouchEnabled:YES];
		enableTouch = FALSE;
		
		bonusLabel = [Sprite spriteWithFile:@"blocks.png"];
		[bonusLabel setPosition:ccp(160,240)];
		[bonusLabel setOpacity:127];
		[bonusLabel setVisible:FALSE];
		[self addChild:bonusLabel z:2];
		
		[MenuItemFont setFontSize:19];
		MenuItem *pauseButton = [MenuItemFont itemFromString:@"Pause Game" target:self  selector:@selector(onPauseGame:)];
		menu = [Menu menuWithItems:pauseButton,nil];
		[menu setPosition:ccp(60,450)];
		[menu setVisible:NO];
		[self addChild:menu];
		
		/*MenuItem *takeScoreButton = [MenuItemFont itemFromString:@"Take Score" target:self  selector:@selector(onTakeScr:)];
		takeScoreMenu = [Menu menuWithItems:takeScoreButton,nil];
		[takeScoreMenu setPosition:ccp(50,290)];
		[takeScoreMenu setVisible:NO];
		[self addChild:takeScoreMenu];*/
		
		
		scoreLabel = [Label labelWithString:[NSString stringWithFormat: @"%d",gameScore] fontName:@"Arial" fontSize:16];
		[scoreLabel setPosition:ccp(20,80)];
		[scoreLabel setVisible:NO];
		[self addChild:scoreLabel z:0];
		
		timerBar = [AtlasSprite spriteWithRect:CGRectMake(0,0, 148, 11) spriteManager:timerSprites];
		[timerBar setPosition:ccp(220,450)];
		[timerBar setScale:1.0f];
		[timerBar setVisible:NO];
		[timerSprites addChild:timerBar z:0];
		
		
		[self readyScreen:0];		
	}
	return self;
}


-(void)onTakeScore
{
	enableTouch = FALSE;
	//[self setIsTouchEnabled:NO];
	int stackCount = 0;
	for (int i=0;i<numRows;i++)
	{
		for (int j=0;j<numCols;j++)
		{
			for (int k=0;k<mainLayoutArray[currentLayoutIndex][stackCount];k++)
			{
				if (tileBoard[i][j][k]->isRendered)
				{
					tileBoard[i][j][k]->isEnabled = FALSE;
					tileBoard[i][j][k]->isRendered = FALSE;
					[manager removeChild:tileBoard[i][j][k]->tileShadow cleanup:YES];
					[manager removeChild:tileBoard[i][j][k] cleanup:YES];
				}
			}
			stackCount++;
		}
	}
	
	currentLayoutIndex++;
	/*[timerSprites removeChild:timerBar cleanup:YES];
	[self removeChild:menu cleanup:YES];
	[self removeChild:scoreLabel cleanup:YES];
	[self removeChild:bonusLabel cleanup:YES];
	[self removeChild:takeScoreMenu cleanup:YES];*/
	
	[timerBar setVisible:NO];
	[menu setVisible:NO];
	[scoreLabel setVisible:NO];
	[bonusLabel setVisible:NO];
	//[takeScoreMenu setVisible:NO];
	
	[self unschedule:@selector(timerFunc)];
	[self unschedule:@selector(flashBonus)];
	
	if (currentLayoutIndex < numberOfGames)
	{
		if (gameScore >= roundScore[(currentLayoutIndex-1)])
		{
			
			[self readyScreen:currentLayoutIndex];
		}
		else 
		{
			[self gameFinished :2];
		}

	}
	else
	{
		[self gameFinished:0];
	}
}


-(void)onPauseGame:(id)sender
{
	[self setIsTouchEnabled:FALSE];
	[[Director sharedDirector] pause];
	[self addChild:[PauseLayer node] z:1 tag:1];
}

-(void)timerFunc
{
	timex+=6;
	
	if (timeLeftCount >= 0);
		timeLeftCount--;
	if (timex <=148)
	{
		[timerBar setTextureRect:CGRectMake(0,0,148-timex,11)];
		[timerBar setPosition:ccp(220-(timex/2),450)];
	}
	else
	{
		readyLabel = [Label labelWithString:@"Time Over" fontName:@"Arial" fontSize:30];
		[readyLabel setPosition:ccp(160,380)];
		[self addChild:readyLabel z:1];
		[timerSprites removeChild:timerBar cleanup:YES];
		/*if(timerScheduler)
		{
			[self unschedule:@selector(timerFunc)];
			timerScheduler = FALSE;
		}*/
		[self gameFinished:1];
	}
}

-(void) readyScreen:(int) roundNumber
{
	NSString* str = [NSString stringWithFormat:@"Ready Round %d",(roundNumber+1)];
	readyLabel = [Label labelWithString:str fontName:@"Arial" fontSize:30];
	[readyLabel setPosition:ccp(160,240)];
	[self addChild:readyLabel z:0];
	currentLayoutIndex = roundNumber;
	[self schedule:@selector(beginRoundFunc) interval:3];
}

-(void)beginRoundFunc
{
	[self removeChild:readyLabel cleanup:YES];
	[self unschedule:@selector(beginRoundFunc)];
	[self initGame];		
}

-(void)flashBonus
{
	if (bonusScheduler)
	{
		bonusFlashCount++;
		if (bonusFlashCount%2 == 1)
		{
			[bonusLabel setVisible:NO];
		}
		else
		{
			[bonusLabel setVisible:YES];
		}
	
		if (bonusFlashCount >= 7)
		{
			bonusFlashCount = 0;
			bonusScheduler = FALSE;
		}
	}

}

-(void) initGame
{	
	[timerBar setVisible:YES];
	[menu setVisible:YES];
	[scoreLabel setVisible:YES];
	//[takeScoreMenu setVisible:YES];
		
	if (soundOn)
	{
		audioFile = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"opener" ofType:@"wav"]]; 
		AudioServicesCreateSystemSoundID((CFURLRef)audioFile, &shortSound); 
		AudioServicesPlaySystemSound(shortSound);
	}
	
	for (int i=0;i<numberOfRows;i++)
	{
		for (int j=0;j <numberOfColumns;j++)
		{
			for (int k=0;k<numberOfLayers;k++)
			{
				tileBoard[i][j][k] = NULL;
			}
		}
	}
	
	timex = 0;
	bonusCounter = 0;
		
	timeLeftCount = 25;
	
	//[self schedule:@selector(timerFunc) interval:1];
	//[self schedule:@selector(flashBonus) interval:.3f];
	bonusScheduler = FALSE;
	timerScheduler = TRUE;
	previousTile = NULL;
	CGPoint firstCenter;
	numRows = numberOfRows;
	numCols = numberOfColumns;
	
	int layers=0,tiles=0;
	
	for (int i=0;i<numberOfTiles;i++)
	{
		tileIDtracker[i] = FALSE;
	}
	
	for (int i = 0; i < 36;i++)
	{
		tiles+= layoutArray[currentLayoutIndex][i];
		if (layers < layoutArray[currentLayoutIndex][i])
		{
			layers = layoutArray[currentLayoutIndex][i];
		}
	}
	
	numLayers = layers;
	numTiles = tiles;
	tileCount = tiles;
	
	for (int i = 0; i < numberOfTiles ;i++)
	{
		if (i < tiles)
		{
			tileIDtracker[i] = FALSE;
		}
		else
		{
			tileIDtracker[i] = TRUE;
		}
	}
	
	
	if (numRows%2 == 1)
	{
		firstCenter = ccp(160 - (numCols/2)*27*tileScale,220+(numRows/2)*30*tileScale);
	}
	else
	{
		firstCenter = ccp(160 - ((numCols/2)-0.5f)*27*tileScale,220 + ((numRows/2)-0.5f)*30*tileScale);
	}
	
	
	
	int zValue = 1;
	int count = 0;   
	int stackCount = 0;
	int trackingNumber = 0;
	BOOL forLoop = TRUE;
	numTrials = numTiles/2;
	for (int i = 0; i < numRows ;i++ )
	{
		for (int j=0;j< numCols;j++)
		{
			for (int k = 1; k <= numLayers;k++)
			{
				if (k <= layoutArray[currentLayoutIndex][stackCount])
				{
					bool enable;
					if (trackingNumber == 0 || j == numCols-1)
					{
						
						if (layoutArray[currentLayoutIndex][stackCount] == k)
						{
							enable = TRUE;
							trackingNumber = layoutArray[currentLayoutIndex][stackCount];
						}
						else 
						{
							enable = FALSE;
						}
					}
					else if(trackingNumber < layoutArray[currentLayoutIndex][stackCount] )
					{
						if (k == layoutArray[currentLayoutIndex][stackCount])
						{
							enable = TRUE;
							trackingNumber = layoutArray[currentLayoutIndex][stackCount];
						}
						else
						{
							enable = FALSE;
						}
					}
					else if(stackCount != (numRows*numCols-1) && layoutArray[currentLayoutIndex][stackCount] > layoutArray[currentLayoutIndex][stackCount+1])
					{
						if (k == layoutArray[currentLayoutIndex][stackCount])
						{
							enable = TRUE;
							trackingNumber = layoutArray[currentLayoutIndex][stackCount+1];
						}
						else
						{
							enable = FALSE;
						}
					}
					else
					{
						trackingNumber = layoutArray[currentLayoutIndex][stackCount];
						enable = FALSE;
					}
					
					int index; 
					int tempcount = 0;
					
					while (tempcount < numTrials)
					{
						int rand = abs(arc4random());
						
						index = rand%numTiles;
						if (!tileIDtracker[index])
						{
							tileIDtracker[index] = TRUE;
							break;
						}
						else tempcount++;
						
						if (tempcount == numTrials)
						{
							tempcount = -1;
							if (forLoop)
							{
								for (int i =0; i < numTiles;i++)
								{
									if (!tileIDtracker[i])
									{
										tileIDtracker[i] = TRUE;
										forLoop = FALSE;
										index = i;
										break;
									}
								}
							}
							else
							{
								for (int i =numTiles-1; i >= 0 ;i--)
								{
									if (!tileIDtracker[i])
									{
										tileIDtracker[i] = TRUE;
										forLoop = TRUE;
										index = i;
										break;
									}
								}
							}
						}
						if (tempcount == -1)
							break;
					}
					
					tileBoard[i][j][k-1] = [tileSprite spriteWithRect:CGRectMake(27*(index%12), (30*(index/12)), 27, 30) spriteManager:manager];
					[manager addChild:tileBoard[i][j][k-1] z:zValue+1];
					CGPoint center = ccp(firstCenter.x + 27.0f*tileScale*j + layerOffset*(k-1),firstCenter.y - 30.0f*tileScale*i + layerOffset*(k-1));
					[tileBoard[i][j][k-1] setPosition:center];
					tileBoard[i][j][k-1]->tileShadow = [[AtlasSprite spriteWithRect:CGRectMake(0,360,27,30) spriteManager:manager] retain];
					[tileBoard[i][j][k-1]->tileShadow setPosition:ccp(center.x+4,center.y+4)];
					[manager addChild:tileBoard[i][j][k-1]->tileShadow z:zValue];
					
					
					[tileBoard[i][j][k-1] setProperties:index/4 :ccp(center.x -13.5f*tileScale,center.y+15*tileScale) :enable :TRUE :i :j :k-1];
					[tileBoard[i][j][k-1] setScale:tileScale];
					[tileBoard[i][j][k-1]->tileShadow setScale:tileScale];
					count++;
					zValue+=2;
				}
				else
				{
					tileBoard[i][j][k-1] = NULL;
					tileBoard[i][j][k-1] = NULL;
				}
			}
			zValue = 0;
			stackCount++;
		}
		trackingNumber = 0;
	}
	
	enableTouch = TRUE;
	
}
- (BOOL)ccTouchesBegan:(NSSet*)touches withEvent:(UIEvent *)event
{
	NSSet* allTouches = [event allTouches];
	UITouch* touch = [allTouches anyObject];
	CGPoint point = [touch locationInView:[touch view]];
	
	previousTouch = ccp(point.y,point.x);
	return kEventHandled;
}

- (BOOL)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (endGame)
	{
		[self removeAllChildrenWithCleanup:YES];
		[parent finishGame];
	}
	
	NSSet *allTouches = [event allTouches];
	
	UITouch* touch = [allTouches anyObject];
	CGPoint currentPoint = [touch locationInView:[touch view]];
	
	currentPoint = ccp(currentPoint.x,480-currentPoint.y);
	
	/*if (abs(currentPoint.x - previousTouch.x) > 40 && abs(currentPoint.y - previousTouch.y) < 20 && enableTouch)
	{
		[self onTakeScore];
		return kEventHandled;
	}*/
	
	if (enableTouch)
	{
		[self checkWhichTileSelected:currentPoint];
	}
	return kEventHandled;

}

-(void) checkWhichTileSelected:(CGPoint)currentPoint
{
	tileSprite* currentTile = NULL;
	int stackCount = 0;
	
	for (int i = 0; i < numRows ;i++ )
	{
		for (int j=0;j< numCols;j++)
		{
			for (int k = 1; k <= layoutArray[currentLayoutIndex][stackCount];k++)
			{
				if (currentPoint.x > tileBoard[i][j][k-1]->corner.x && currentPoint.x < tileBoard[i][j][k-1]->corner.x + 27*tileScale && currentPoint.y < tileBoard[i][j][k-1]->corner.y && currentPoint.y > tileBoard[i][j][k-1]->corner.y -30*tileScale)
				{
					if (k == layoutArray[currentLayoutIndex][stackCount])
					{
						if (tileBoard[i][j][k-1]->isEnabled)
						{
							currentTile = tileBoard[i][j][k-1];
							[self checkIfMatch:currentTile];
							return;
						}
						else
						{
							if (soundOn)
							{
								audioFile = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"error" ofType:@"wav"]]; 
								AudioServicesCreateSystemSoundID((CFURLRef)audioFile, &shortSound); 
								AudioServicesPlaySystemSound(shortSound);
							}
							return;
						}
					}
				}
			}
			stackCount++;
		}
	}
	[currentTile release];
}

-(void) checkIfMatch:(tileSprite*)currentTile 
{
	if (previousTile == NULL)
	{
		if (soundOn)
		{
			audioFile = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"select" ofType:@"wav"]]; 
			AudioServicesCreateSystemSoundID((CFURLRef)audioFile, &shortSound); 
			AudioServicesPlaySystemSound(shortSound);
		}
		
		previousTile = currentTile;
		ccColor3B Col = [previousTile color];
		[previousTile setColor:ccc3(Col.r, Col.g+127, Col.b+127)];
		
		return;
	}
	
	if (previousTile == currentTile)
	{
		if (soundOn)
		{
			audioFile = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"deselect" ofType:@"wav"]]; 
			AudioServicesCreateSystemSoundID((CFURLRef)audioFile, &shortSound); 
			AudioServicesPlaySystemSound(shortSound);
		}
		
		ccColor3B Col = [previousTile color];
		
		[previousTile setColor:ccc3(Col.r, Col.g-127, Col.b-127)];
		previousTile = NULL;
		bonusCounter = 0;
		
		return;
	}
	
	if (previousTile->tileID == currentTile->tileID)
	{
		bonusCounter++;
		timex = 0;
		[timerBar setTextureRect:CGRectMake(0,0,148-timex,11)];
		[timerBar setPosition:ccp(220,450)];
		[timerBar setScale:1.0f];
		
		gameScore += 4*timeLeftCount;
		timeLeftCount = 25;
	
		
		
		if (soundOn)
		{
			audioFile = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"removeTile" ofType:@"wav"]]; 
			AudioServicesCreateSystemSoundID((CFURLRef)audioFile, &shortSound); 
			AudioServicesPlaySystemSound(shortSound);
		}
		
		
		previousTile->isEnabled = NO;
		previousTile->isRendered = NO;

		currentTile->isEnabled = NO;
		currentTile->isRendered = NO;

		[self ridTile:previousTile];
		[self ridTile:currentTile];
		NSLog(@" ");

		int index;
		index = previousTile->indexI* numCols + previousTile->indexJ;
		[manager removeChild:previousTile->tileShadow cleanup:YES];
		[manager removeChild:previousTile cleanup:YES];
		
		layoutArray[currentLayoutIndex][index]--;
		index = currentTile->indexI*numCols + currentTile->indexJ;
		layoutArray[currentLayoutIndex][index]--;
		[manager removeChild:currentTile->tileShadow cleanup:YES];
		[manager removeChild:currentTile cleanup:YES];		
		
		previousTile = NULL;
		tileCount-=2;

		if (bonusCounter >= 3)
		{
			//[self schedule:@selector(flashBonus) interval:.3f];
			bonusScheduler = TRUE;
			bonusFlashCount = 0;
			bonusCounter = 0;
			gameScore+=20;
		}
		
		NSString* scr = [NSString stringWithFormat:@"%d",gameScore];
		[scoreLabel setString:scr];
		
		if (tileCount == 0)
		{
			enableTouch = FALSE;
			//[self setIsTouchEnabled:FALSE];
			currentLayoutIndex++;
			[timerBar setVisible:NO];
			[menu setVisible:NO];
			[scoreLabel setVisible:NO];
			[bonusLabel setVisible:NO];
			//[takeScoreMenu setVisible:NO];
			
			[self unschedule:@selector(timerFunc)];
			tileCount = 0;
			
			[self unschedule:@selector(flashBonus)];

			bonusFlashCount = 0;
			
			if (currentLayoutIndex < numberOfGames)
			{
				if (gameScore >= roundScore[(currentLayoutIndex-1)])
				{
					
					[self readyScreen:currentLayoutIndex];
				}
				else 
				{
					[self gameFinished:2];
				}
			}
			else
			{
				[self gameFinished:0];
 			}
			
		}
		
	}
	else
	{
		bonusCounter = 0;
		if (soundOn)
		{
			audioFile = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"error" ofType:@"wav"]]; 
			AudioServicesCreateSystemSoundID((CFURLRef)audioFile, &shortSound); 
			AudioServicesPlaySystemSound(shortSound);
		}
		
		ccColor3B Col = [previousTile color];
		[previousTile setColor:ccc3(Col.r, Col.g-127, Col.b - 127)];
		previousTile = currentTile;
		Col = [previousTile color];
		[previousTile setColor:ccc3(Col.r, Col.g+127, Col.b+127) ];
	}
		
}

-(void)ridTile:(tileSprite*)currentTile
{
	int i = currentTile->indexI;
	int j = currentTile->indexJ;
	int k = currentTile->indexK;
	
	
	//NSLog([NSString stringWithFormat:@"%d,%d,%d gone",i,j,k]);
	// enable the left tile
	if (j != 0 && tileBoard[i][j-1][k] != NULL && tileBoard[i][j-1][k]->isRendered && !tileBoard[i][j-1][k]->isEnabled)
	{
		/*if (k!= numberOfLayers-1 && tileBoard[i][j-1][k+1] != NULL && tileBoard[i][j-1][k+1]->isRendered)
		{
			
		}
		else*/
		{
			//NSLog([NSString stringWithFormat:@"%d,%d,%d left",i,(j-1),k]);
			tileBoard[i][j-1][k]->isEnabled = TRUE;

		}
	}// enable the right tile
	else if (j != numCols-1 && tileBoard[i][j+1][k] != NULL && tileBoard[i][j+1][k]->isRendered && !tileBoard[i][j+1][k]->isEnabled)
	{
		/*if (k!= numberOfLayers-1 && tileBoard[i][j+1][k+1] != NULL && tileBoard[i][j+1][k+1]->isRendered)
		{
			
		}
		else*/ 
		{
			//NSLog([NSString stringWithFormat:@"%d,%d,%d right",i,(j+1),k]);
			tileBoard[i][j+1][k]->isEnabled = TRUE;

		}

	}
	
	if (k!= 0 && tileBoard[i][j][k-1] != NULL)
	{
		/*if (j!= 0 && (tileBoard[i][j-1][k-1] == NULL || !tileBoard[i][j-1][k-1]->isRendered))
		{
			NSLog([NSString stringWithFormat:@"%d,%d,%d bottom",i,j,(k-1)]);
			tileBoard[i][j][k-1]->isEnabled = TRUE;
		}
		else if (j!= numCols-1 && (tileBoard[i][j+1][k-1] == NULL || !tileBoard[i][j+1][k-1]->isRendered))
		{
			NSLog([NSString stringWithFormat:@"%d,%d,%d bottom",i,j,(k-1)]);
			tileBoard[i][j][k-1]->isEnabled = TRUE;
		}*/
		if (j!= 0 && j!= numCols-1 && tileBoard[i][j-1][k-1] != NULL && tileBoard[i][j+1][k-1] != NULL && tileBoard[i][j-1][k-1]->isRendered && tileBoard[i][j+1][k-1]->isRendered)
		{
				
		}
		else if (!tileBoard[i][j][k-1]->isEnabled)
		{
			//NSLog([NSString stringWithFormat:@"%d,%d,%d bottom",i,j,(k-1)]);
			tileBoard[i][j][k-1]->isEnabled = TRUE;
		}

	}
		
}

-(void) gameFinished :(int)parameter
{
	NSString* str = [NSString stringWithFormat:@"Your Score = %d",gameScore];
	if (timerScheduler)
	{
		[self unschedule:@selector(timerFunc)];
		[self unschedule:@selector(flashBonus)];
	}
	[timerSprites removeChild:timerBar cleanup:YES];
	
	if (parameter == 1)
	{
		Label* time = [Label labelWithString:@"Time Over" fontName:@"Arial" fontSize:30];
		[time setPosition:ccp(160,220)];
		[self addChild:time z:1];
	}
	
	if (parameter == 2)
	{
		NSLog(@"start add");
		Label* lessScore = [Label labelWithString:@"Insufficient Score" fontName:@"Arial" fontSize:30];
		[lessScore setPosition:ccp(160,220)];
		[self addChild:lessScore z:1];
	}
	
	gameOverLabel = [Label labelWithString:str fontName:@"Arial" fontSize:25];
	[gameOverLabel setPosition:ccp(160,160)];
	[self addChild:gameOverLabel z:0];
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	int currentHighScore = [prefs integerForKey:@"highscore"];
	if (currentHighScore < gameScore)
	{
		[prefs setInteger:gameScore forKey:@"highscore"];
	}
	
	endGame = YES; 
}

@end

@implementation PauseLayer
-(id) init
{
	if (self == [super init])
	{
		Sprite* bg = [Sprite spriteWithFile:@"Bub.png"];
		[bg setPosition:ccp(160,240)];
        
		[self addChild:bg];
		MenuItem *resumeButton = [MenuItemFont itemFromString:@"Resume" target:self selector:@selector(onResume:)];
		MenuItemToggle *sound; 
		if (soundOn)
		{
			sound = [MenuItemToggle itemWithTarget:self selector:@selector(onSound:) items:[MenuItemFont itemFromString: @"SoundOn"],[MenuItemFont itemFromString: @"SoundOff"],nil];
		}
		else 
		{
			sound = [MenuItemToggle itemWithTarget:self selector:@selector(onSound:) items:[MenuItemFont itemFromString: @"SoundOff"],[MenuItemFont itemFromString: @"SoundOn"],nil];
		}

		Menu* menu = [Menu menuWithItems:resumeButton,sound,nil];
		[menu alignItemsVerticallyWithPadding:10];
		[menu setPosition:ccp(160,240)];
		[self addChild:menu z:0];
	}
	return self;
}



-(void)onResume:(id)sender
{
	[self removeAllChildrenWithCleanup:YES];
	Layer* backGroundLayer = (Layer*)[self parent];
	[backGroundLayer removeChild:self cleanup:YES];
	[backGroundLayer setIsTouchEnabled:YES];
	[[Director sharedDirector] resume];
}

-(void)onSound:(id)sender
{
	soundOn =!soundOn;
}

@end



