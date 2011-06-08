//
//  PlayScene.m
//  Mahjongg
//
//  Created by GamePipe Iphone Dev on 7/28/09.
//  Copyright 2009 USC. All rights reserved.
//

#import "PlayScene.h"
#import "MahjonggAppDelegate.h"

int mainLayoutArray[12][36] = {
    
{	0,0,1,1,0,0,
    0,0,1,1,0,0,
    1,1,0,0,1,1,
    1,1,0,0,1,1,
    1,1,1,1,1,1,
    0,0,1,1,0,0},
    
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
    0,0,1,1,0,0,
    1,1,1,2,1,1,
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
	0,0,1,1,0,0},


{   1,0,0,0,0,1,
	1,2,2,2,2,1,
	1,2,3,3,2,1,
	1,2,2,2,2,1,
	1,1,1,1,1,1,
	1,0,0,0,0,1},

{   0,1,0,0,1,0,
	0,2,3,3,2,0,
	1,1,2,2,1,1,
	1,3,2,2,3,1,
	1,1,1,1,1,1,
	2,1,0,0,1,2},
    
{   1,1,0,0,1,1,
    0,2,3,3,2,0,
    1,1,2,2,1,1,
    1,3,2,2,3,1,
    1,2,1,1,2,1,
    2,1,0,0,1,2},
    
{   0,1,2,2,1,0,
    1,2,3,3,2,1,
    1,1,2,2,1,1,
    1,3,2,2,3,1,
    1,1,1,1,1,1,
    2,1,2,2,1,2}
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
        [self addChild:[[[LevelSelectLayer alloc] initWithColor:ccc4(0, 120, 0,255)] autorelease] z:0];
		
	}
	return self;
}

-(void) finishGame
{
	[[self getChildByTag:0] removeAllChildrenWithCleanup:YES];
	[self addChild:[[[LevelSelectLayer alloc] initWithColor:ccc4(0, 120, 0,255)] autorelease] z:0];	
}

-(void) restartGame:(int)index
{
    BackgroundLayer* l = [BackgroundLayer node];
    [self addChild:l z:0 tag:0];
    [l readyScreen:index];
}

@end

@implementation BackgroundLayer

-(id) initWithColor:(ccColor4B)color
{
	if ((self = [super initWithColor:color]))
	{
		endGame = FALSE;		
		roundScore[0] = 600;
		roundScore[1] = 1200;
		roundScore[2] = 1800;
		timerScheduler = FALSE;
		manager = [AtlasSpriteManager spriteManagerWithFile:@"mahjong.png" capacity:144];
		
		[self addChild: manager z:0];
		
		gameScore = 0;
		tileScale = 1.5f;
		layerOffset = 7.0f;
        timeCount = 0;
		
		for (int i=0;i < numberOfGames;i++)
		{
			for (int j=0;j<36;j++)
			{
				layoutArray[i][j] = mainLayoutArray[i][j];
			}
		}
		
		[self setIsTouchEnabled:YES];
		enableTouch = FALSE;
		
		[MenuItemFont setFontSize:19];
		MenuItem *pauseButton = [MenuItemFont itemFromString:@"Options" target:self  selector:@selector(onPauseGame:)];
		menu = [Menu menuWithItems:pauseButton,nil];
		[menu setPosition:ccp(60,450)];
		[menu setVisible:NO];
		[self addChild:menu];
		
		/*MenuItem *takeScoreButton = [MenuItemFont itemFromString:@"Take Score" target:self  selector:@selector(onTakeScr:)];
		takeScoreMenu = [Menu menuWithItems:takeScoreButton,nil];
		[takeScoreMenu setPosition:ccp(50,290)];
		[takeScoreMenu setVisible:NO];
		[self addChild:takeScoreMenu];*/
        
        timeLabel = [Label labelWithString:[NSString stringWithFormat: @"Time: %f",timeCount] fontName:[MenuItemFont fontName] fontSize:16];
		[timeLabel setPosition:ccp(250,450)];
		[timeLabel setVisible:NO];
		[self addChild:timeLabel z:0];
        
        previousBestTime = [Label labelWithString:[NSString stringWithFormat: @"Previous Best: %f",timeCount] fontName:[MenuItemFont fontName] fontSize:16];
		[previousBestTime setPosition:ccp(200,400)];
		[previousBestTime setVisible:NO];
		[self addChild:previousBestTime z:0];
        
//		timerBar = [AtlasSprite spriteWithRect:CGRectMake(0,0, 148, 11) spriteManager:timerSprites];
//		[timerBar setPosition:ccp(220,450)];
//		[timerBar setScale:1.0f];
//		[timerBar setVisible:NO];
//		[timerSprites addChild:timerBar z:0];
		
		
		//[self readyScreen:0];		
	}
	return self;
}



-(void)onPauseGame:(id)sender
{
	[self setIsTouchEnabled:FALSE];
	[[Director sharedDirector] pause];
	[self addChild:[[[PauseLayer alloc] initWithColor:ccc4(0, 120, 0,255)] autorelease] z:1 tag:1];
}


-(void) readyScreen:(int) roundNumber
{
    currentLayoutIndex = roundNumber;
    [self beginRoundFunc];
}

-(void)beginRoundFunc
{
	//[self unschedule:@selector(getTime)];
	[self initGame];		
}

-(void)getTime
{
    timeCount+=0.03f;
    [timeLabel setString:[NSString stringWithFormat:@"Time: %.2f",timeCount]];
}

-(void) initGame
{	
	[menu setVisible:YES];
    [timeLabel setVisible:YES];
		
    float prevBest = [[(MahjonggAppDelegate*)[[UIApplication sharedApplication] delegate]getScoreMananger] getBestScoreForLevel:currentLayoutIndex];
    
    if (prevBest > 0)
    {
        [previousBestTime setString:[NSString stringWithFormat:@"Previous Best: %f",prevBest]];
    }
    {
        [previousBestTime setString:@"Previous Best: NA"];
    }
    
    [previousBestTime setVisible:YES];
    
    [self schedule:@selector(getTime) interval:0.03f];
    
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
	timeCount = 0;

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
					
                    
					tileBoard[i][j][k-1] = [tileSprite spriteWithRect:CGRectMake(54*(index%12), (60*(index/12)), 54, 60) spriteManager:manager];
					[manager addChild:tileBoard[i][j][k-1] z:zValue+1];
					CGPoint center = ccp(firstCenter.x + 27.0f*tileScale*j + layerOffset*(k-1),firstCenter.y - 30.0f*tileScale*i + layerOffset*(k-1));
					[tileBoard[i][j][k-1] setPosition:center];
					tileBoard[i][j][k-1]->tileShadow = [[AtlasSprite spriteWithRect:CGRectMake(0,720,54,60) spriteManager:manager] retain];
					[tileBoard[i][j][k-1]->tileShadow setPosition:ccp(center.x+4,center.y+4)];
					[manager addChild:tileBoard[i][j][k-1]->tileShadow z:zValue];
					
					
					[tileBoard[i][j][k-1] setProperties:index/4 :ccp(center.x -13.5f*tileScale,center.y+15*tileScale) :enable :TRUE :i :j :k-1];
					[tileBoard[i][j][k-1] setScale:tileScale/2];
					[tileBoard[i][j][k-1]->tileShadow setScale:tileScale/2];
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
		
		return;
	}
	
	if (previousTile->tileID == currentTile->tileID)
	{
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
        
		if (tileCount == 0)
		{
			enableTouch = FALSE;
			//[self setIsTouchEnabled:FALSE];
			currentLayoutIndex++;
			
			[menu setVisible:NO];
			[timeLabel setVisible:NO];
            [previousBestTime setVisible:NO];
			//[takeScoreMenu setVisible:NO];
			
			tileCount = 0;
			
			[self unschedule:@selector(getTime)];
            [self gameFinished];
		}
		
	}
	else
	{
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

-(void) gameFinished
{
	{
		Label* time = [Label labelWithString:@"Puzzle Complete" fontName:[MenuItemFont fontName] fontSize:30];
		[time setPosition:ccp(160,300)];
		[self addChild:time z:1];
	}
	
	
	{
		Label* lessScore = [Label labelWithString:@"Tap to continue" fontName:[MenuItemFont fontName] fontSize:20];
		[lessScore setPosition:ccp(160,120)];
		[self addChild:lessScore z:1];
	}
	
	[[(MahjonggAppDelegate*)[[UIApplication sharedApplication] delegate]getScoreMananger] newScore:timeCount forLevel:currentLayoutIndex+1 sendToGC:YES];
    
	endGame = YES; 
}

@end

@implementation PauseLayer
- (id) initWithColor:(ccColor4B)color
{
	if (self == [super initWithColor:color])
	{
		//Sprite* bg = [Sprite spriteWithFile:@"Bub.png"];
		//[bg setPosition:ccp(160,240)];
        
		//[self addChild:bg];
		MenuItem *resumeButton = [MenuItemFont itemFromString:@"Resume" target:self selector:@selector(onResume:)];
        MenuItem *puzzleSelectButton = [MenuItemFont itemFromString:@"Puzzle Select Menu" target:self selector:@selector(onPuzzleSelect:)];
        
		MenuItemToggle *sound; 
		if (soundOn)
		{
			sound = [MenuItemToggle itemWithTarget:self selector:@selector(onSound:) items:[MenuItemFont itemFromString: @"SoundOn"],[MenuItemFont itemFromString: @"SoundOff"],nil];
		}
		else 
		{
			sound = [MenuItemToggle itemWithTarget:self selector:@selector(onSound:) items:[MenuItemFont itemFromString: @"SoundOff"],[MenuItemFont itemFromString: @"SoundOn"],nil];
		}
        MenuItem* restartButton = [MenuItemFont itemFromString:@"Restart" target:self selector:@selector(onRestartSelect:)];
        
		Menu* menu = [Menu menuWithItems:resumeButton,sound,puzzleSelectButton,restartButton,nil];
		[menu alignItemsVerticallyWithPadding:10];
		[menu setPosition:ccp(160,240)];
		[self addChild:menu z:0];
	}
	return self;
}

-(void)onRestartSelect:(id)sender
{
    [self removeAllChildrenWithCleanup:YES];
    BackgroundLayer* backGroundLayer = (BackgroundLayer*)[self parent];
	[backGroundLayer removeChild:self cleanup:YES];
    [[backGroundLayer parent] restartGame:backGroundLayer->currentLayoutIndex];
    [[backGroundLayer parent] removeChild:backGroundLayer cleanup:YES];
    [[Director sharedDirector] resume];
}

-(void)onPuzzleSelect:(id)sender
{
	[self removeAllChildrenWithCleanup:YES];
	Layer* backGroundLayer = (Layer*)[self parent];
	[backGroundLayer removeChild:self cleanup:YES];
	[[backGroundLayer parent] addChild:[[[LevelSelectLayer alloc] initWithColor:ccc4(0, 120, 0,255)] autorelease] z:0 tag:0];
    [[backGroundLayer parent] removeChild:backGroundLayer cleanup:YES];
	[[Director sharedDirector] resume];
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

@implementation LevelSelectLayer

- (id) initWithColor:(ccColor4B)color
{
    if ((self = [super initWithColor:color]))
    {
        Label* l = [Label labelWithString:@"Select to Play" fontName:[MenuItemFont fontName] fontSize:[MenuItemFont fontSize]];
        [l setPosition:ccp(160,440)];
        [self addChild:l];
        
        MenuItem *levelButton1 = [MenuItemSprite itemFromNormalSprite:[Sprite spriteWithFile:@"level1.png"] selectedSprite:[Sprite spriteWithFile:@"level1.png"]target:self selector:@selector(onLevelSelect:)];
        [levelButton1 setTag:1];
        //[levelButton1 setScale:0.20f];
        
        
        MenuItem *levelButton2 = [MenuItemSprite itemFromNormalSprite:[Sprite spriteWithFile:@"level1.png"] selectedSprite:[Sprite spriteWithFile:@"level2.png"]target:self selector:@selector(onLevelSelect:)];
        [levelButton2 setTag:2];
        //[levelButton2 setScale:0.20f];
        
         MenuItem *levelButton3 = [MenuItemSprite itemFromNormalSprite:[Sprite spriteWithFile:@"level1.png"] selectedSprite:[Sprite spriteWithFile:@"level3.png"]target:self selector:@selector(onLevelSelect:)];
        [levelButton3 setTag:3];
        //[levelButton3 setScale:0.20f];
        
         MenuItem *levelButton4 = [MenuItemSprite itemFromNormalSprite:[Sprite spriteWithFile:@"level1.png"] selectedSprite:[Sprite spriteWithFile:@"level4.png"]target:self selector:@selector(onLevelSelect:)];
        [levelButton4 setTag:4];
        [levelButton4 setScale:0.20f];
        
         MenuItem *levelButton5 = [MenuItemSprite itemFromNormalSprite:[Sprite spriteWithFile:@"level1.png"] selectedSprite:[Sprite spriteWithFile:@"level5.png"]target:self selector:@selector(onLevelSelect:)];
        [levelButton5 setTag:5];
        [levelButton5 setScale:0.20f];
        
        MenuItem *levelButton6 = [MenuItemSprite itemFromNormalSprite:[Sprite spriteWithFile:@"level1.png"] selectedSprite:[Sprite spriteWithFile:@"level6.png"]target:self selector:@selector(onLevelSelect:)];
        [levelButton6 setTag:6];
        [levelButton6 setScale:0.20f];
        
        MenuItem *levelButton7 = [MenuItemSprite itemFromNormalSprite:[Sprite spriteWithFile:@"level1.png"] selectedSprite:[Sprite spriteWithFile:@"level7.png"]target:self selector:@selector(onLevelSelect:)];
        [levelButton7 setTag:7];
        [levelButton7 setScale:0.20f];
        
        MenuItem *levelButton8 = [MenuItemSprite itemFromNormalSprite:[Sprite spriteWithFile:@"level1.png"] selectedSprite:[Sprite spriteWithFile:@"level8.png"] target:self selector:@selector(onLevelSelect:)];
        [levelButton8 setTag:8];
        [levelButton8 setScale:0.20f];                          
                                  
        MenuItem *levelButton9 = [MenuItemSprite itemFromNormalSprite:[Sprite spriteWithFile:@"level1.png"] selectedSprite:[Sprite spriteWithFile:@"level9.png"]target:self selector:@selector(onLevelSelect:)];
        [levelButton9 setTag:9];
        [levelButton9 setScale:0.20f];
                                  
        MenuItem *levelButton10 = [MenuItemSprite itemFromNormalSprite:[Sprite spriteWithFile:@"level1.png"] selectedSprite:[Sprite spriteWithFile:@"level10.png"]target:self selector:@selector(onLevelSelect:)];
        [levelButton10 setTag:10];
        [levelButton10 setScale:0.20f];
        
        MenuItem *levelButton11 = [MenuItemSprite itemFromNormalSprite:[Sprite spriteWithFile:@"level1.png"] selectedSprite:[Sprite spriteWithFile:@"level11.png"]target:self selector:@selector(onLevelSelect:)];
        [levelButton11 setTag:11];
        [levelButton11 setScale:0.20f];
        
        MenuItem *levelButton12 = [MenuItemSprite itemFromNormalSprite:[Sprite spriteWithFile:@"level1.png"] selectedSprite:[Sprite spriteWithFile:@"level12.png"]target:self selector:@selector(onLevelSelect:)];
        [levelButton12 setTag:12];
        [levelButton12 setScale:0.20f];
		
		Menu* menu = [Menu menuWithItems:levelButton1,levelButton2,levelButton3,levelButton4,nil];
		[menu alignItemsHorizontallyWithPadding:15];
		[menu setPosition:ccp(160,370)];
		[self addChild:menu z:0];
        
        Menu* menu1 = [Menu menuWithItems:levelButton5,levelButton6,levelButton7,levelButton8,nil];
		[menu1 alignItemsHorizontallyWithPadding:15];
		[menu1 setPosition:ccp(160,270)];
		[self addChild:menu1 z:0];
        
        Menu* menu2 = [Menu menuWithItems:levelButton9,levelButton10,levelButton11,levelButton12,nil];
		[menu2 alignItemsHorizontallyWithPadding:15];
		[menu2 setPosition:ccp(160,170)];
		[self addChild:menu2 z:0];
        
        
        MenuItem* backButton = [MenuItemFont itemFromString:@"MainMenu" target:self selector:@selector(onBack:)];
        Menu* backMenu = [Menu menuWithItems:backButton, nil];
        [backMenu setPosition:ccp(160,100)];
        [self addChild:backMenu];
    }
    return self;
}

-(void) onBack:(id)sender
{
    [self removeAllChildrenWithCleanup:YES];
    [[self parent] removeChild:self cleanup:YES];
    [[Director sharedDirector] replaceScene:[MenuScene node]];
}

-(void)onLevelSelect:(id)sender
{
    BackgroundLayer* l = [[[BackgroundLayer alloc] initWithColor:ccc4(0, 120, 0,255)] autorelease];
    [[self parent] addChild:l z:0 tag:0];
    int r = [sender tag];
    [l readyScreen:r-1];
    [self removeAllChildrenWithCleanup:YES];
    [[self parent] removeChild:self cleanup:YES];
    
}

@end



