//
//  ScoreManager.h
//  Cross Me Not
//
//  Created by Manan Patel on 10/28/10.
//  Copyright 2010 ngmoco:). All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>


@interface ScoreManager : NSObject {
	NSMutableDictionary *bestTimes;
	int temp;
}

- (void) newScore:(float)score forLevel:(int)level sendToGC:(BOOL)report;
- (float) getBestScoreForLevel:(int)level;
- (void) readBestTimes;


- (void) _writeBestTimes;
- (void) _setBestScore:(float)score forLevel:(int)level;
- (void) _reportHighScore:(int64_t) score forCategory: (NSString*) category;
- (void) _authenticateLocalPlayer;
- (void) _registerForAuthenticationNotification;
- (void) _authenticationChanged;
+ (BOOL) _isGameCenterAvailable;
- (NSString*)_getFilePath;

@end
