//
//  PlayScene.h
//  Mahjongg
//
//  Created by GamePipe Iphone Dev on 7/28/09.
//  Copyright 2009 USC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "MenuScene.h"


#define numberOfRows 6
#define numberOfColumns 6
#define numberOfTiles 144
#define numberOfLayers 5
#define numberOfGames 4





@interface tileSprite : AtlasSprite 
{
	@public
	int tileID;
	BOOL isEnabled;
	BOOL isRendered;
	CGPoint corner;
	int indexI , indexJ, indexK;
	AtlasSprite* tileShadow;
}


-(void) setProperties :(int)tileIdentity :(CGPoint)position :(BOOL) enable :(BOOL) rendered :(int)i :(int)j :(int)k ;

@end


@interface PlayScene : Scene 
{
}

-(void) finishGame;
@end

@interface BackgroundLayer : Layer
{
	BOOL bonusScheduler,timerScheduler;
	AtlasSpriteManager* manager;
	AtlasSpriteManager* timerSprites;
	AtlasSprite* timerBar;
	tileSprite* previousTile;
	float tileScale,layerOffset;
	int numCols,numRows,numLayers,numTiles,numTrials,tileCount,currentLayoutIndex;
	float timex;
	Label* scoreLabel;
	Label* readyLabel;
	Label* scoreNotGood;
	Label* gameOverLabel;
	Sprite* bonusLabel;
	int timeLeftCount;
	int gameScore;
	Menu *menu;
	SystemSoundID shortSound;
	NSURL* audioFile;
 	tileSprite* tileBoard[numberOfRows][numberOfColumns][numberOfLayers];
	int layoutArray[4][36];
	BOOL tileIDtracker[numberOfTiles];
	CGPoint previousTouch;
	int bonusCounter,bonusFlashCount;
	int roundScore[(numberOfGames-1)];
	BOOL enableTouch,endGame;
}



-(void) checkWhichTileSelected:(CGPoint)currentPoint; 
-(void) checkIfMatch:(tileSprite*)currentTile;
-(void) ridTile:(tileSprite*)currentTile;
-(void) initGame;
-(void) readyScreen:(int)roundNumber;
-(void) gameFinished :(int)parameter;


@end

@interface PauseLayer : Layer
{	
}
@end




