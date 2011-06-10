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
#define numberOfGames 12





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
-(void) restartGame:(int)index;
@end

@interface BackgroundLayer : ColorLayer
{
    @public
	BOOL bonusScheduler,timerScheduler;
	AtlasSpriteManager* manager;
	//AtlasSpriteManager* timerSprites;
	//AtlasSprite* timerBar;
	tileSprite* previousTile;
	float tileScale,layerOffset;
	int numCols,numRows,numLayers,numTiles,numTrials,tileCount,currentLayoutIndex;
	float timex;
    Label* timeLabel,*previousBestTime,*pauseLabel;
	float timeCount;
	int gameScore;
	Menu *menu;
	SystemSoundID shortSound;
	NSURL* audioFile;
 	tileSprite* tileBoard[numberOfRows][numberOfColumns][numberOfLayers];
	int layoutArray[numberOfGames][36];
	BOOL tileIDtracker[numberOfTiles];
	CGPoint previousTouch;
	int roundScore[(numberOfGames-1)];
	BOOL enableTouch,endGame,gamePaused;
    Sprite* pauseCover;
}

-(void) checkWhichTileSelected:(CGPoint)currentPoint; 
-(void) checkIfMatch:(tileSprite*)currentTile;
-(void) ridTile:(tileSprite*)currentTile;
-(void) initGame;
-(void) readyScreen:(int)roundNumber;
-(void) gameFinished;
-(void) beginRoundFunc;
-(void) getTime;
-(void) setTilesVisible:(BOOL)b;


@end

@interface PauseLayer : ColorLayer
{	
}
@end

@interface LevelSelectLayer : ColorLayer 
{
    
    
}

@end



