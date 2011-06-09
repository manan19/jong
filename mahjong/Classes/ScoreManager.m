	//
	//  ScoreManager.m
	//  Cross Me Not
	//
	//  Created by Manan Patel on 10/28/10.
	//  Copyright 2010 ngmoco:). All rights reserved.
	//

#import "ScoreManager.h"
#import "PlayScene.h"


@implementation ScoreManager

- (id) init
{
	self = [super init];
	if (self != nil) {
		
		if([ScoreManager _isGameCenterAvailable])
		{
			[self _registerForAuthenticationNotification];
			[self _authenticateLocalPlayer];
		}
	}
	return self;
}


- (void) _authenticateLocalPlayer
{
    [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:^(NSError *error) {
		if (error == nil)
		{
				// Insert code here to handle a successful authentication.
		}
		else
		{
				// Your application can process the error parameter to report the error to the player.
		}
	}];
}

- (void) _registerForAuthenticationNotification
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(_authenticationChanged) name:GKPlayerAuthenticationDidChangeNotificationName object:nil];
}

- (void) updateScoresFromGameCenter:(int)level
{
	temp = level;
	GKLeaderboard *lbquery;
	
	lbquery = [[GKLeaderboard alloc] initWithPlayerIDs:[NSArray arrayWithObjects:[GKLocalPlayer localPlayer].playerID,nil]];
	[lbquery setCategory:[NSString stringWithFormat:@"mml%d",level]];
	
	[lbquery loadScoresWithCompletionHandler:
	 ^(NSArray *scores, NSError *error) 
	{
		if (error != nil) 
		{
			[self updateScoresFromGameCenter:temp];
		}
		else if (scores != nil)
		{
			if([scores count])
			{
				float score = [((GKScore*)[scores objectAtIndex:0]) value];
				[self newScore:score/100 forLevel:temp sendToGC:FALSE];
			}
			
			if (temp < numberOfGames)
			{
				[self updateScoresFromGameCenter:++temp];
			}
		}
	}
	];
	
	[lbquery release];
}

- (void) _authenticationChanged
{
	[self readBestTimes];
	
    if ([GKLocalPlayer localPlayer].isAuthenticated)
	{
			// Insert code here to handle a successful authentication.
		
			///////////////////////// TODO read in scores properly
		[self updateScoresFromGameCenter:1];		
	}
	else
	{
			// Insert code here to clean up any outstanding Game Center-related classes.
	}
}

- (void) _reportHighScore:(int64_t) score forCategory: (NSString*) category
{
	if( [ScoreManager _isGameCenterAvailable] && [GKLocalPlayer localPlayer].isAuthenticated )
	{
		GKScore *scoreReporter = [[[GKScore alloc] initWithCategory:category] autorelease];
		scoreReporter.value = score;
		
		[scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
			if (error != nil)
			{
				NSLog(@"%@",[error localizedFailureReason]);
			}
		}];
	}
}


- (void) readBestTimes 
{
	NSString *appFile = [self _getFilePath];
	bestTimes = [[NSMutableDictionary alloc] initWithContentsOfFile:appFile];
	
	int j = 1;
	while (j<=numberOfGames) {
		NSString *key = [NSString stringWithFormat:@"%d",j++];
		if( ![bestTimes objectForKey:key] )
		[bestTimes setObject:@"9990" forKey:key];
	}
	
	if (!bestTimes) 
	{
		bestTimes = [[NSMutableDictionary alloc] init];
		int i = 1;
		while (i<=numberOfGames) {
			[bestTimes setObject:@"9990" forKey:[NSString stringWithFormat:@"%d",i++]];
		}

	}
}

- (void) _writeBestTimes
{
	NSString *appFile = [self _getFilePath];
	if (!bestTimes) {
		bestTimes = [[NSMutableDictionary alloc] init];
	}
	[bestTimes writeToFile:appFile atomically:YES];
}

- (void) _setBestScore:(float)score forLevel:(int)level
{
	[bestTimes setObject:[NSString stringWithFormat:@"%f",score] forKey:[NSString stringWithFormat:@"%d",level]];
}

+(BOOL)_isGameCenterAvailable
{
		// Check for presence of GKLocalPlayer API.
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
	
		// The device must be running running iOS 4.1 or later.
    NSString *reqSysVer = @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
	
    return (gcClass && osVersionSupported);
}

- (NSString*)_getFilePath
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *appFile;
	if([ScoreManager _isGameCenterAvailable] && [GKLocalPlayer localPlayer].isAuthenticated)
	{
		appFile = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[GKLocalPlayer localPlayer].alias]];
	}
	else 
	{
		appFile = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"LocalBestTimes"];
	}
	
	return appFile;
}


- (void) newScore:(float)score forLevel:(int)level sendToGC:(BOOL)report
{
	float prevBest = [self getBestScoreForLevel:level];
	
	if( prevBest > score)
	{
			//Update new Best Time
		[self _setBestScore:score forLevel:level];
			//Write to file
		[self _writeBestTimes];
			//Report to Game Center
		
		if (report) {
			int64_t newBest = score * 100;
			[self _reportHighScore:newBest forCategory:[NSString stringWithFormat:@"mml%d",level]];
		}
	}
	else
	{
		if (!report) 
		{
			int64_t newBest = prevBest * 100;
			[self _reportHighScore:newBest forCategory:[NSString stringWithFormat:@"mml%d",level]];
		}
	}

	
}


- (float) getBestScoreForLevel:(int)level
{
	return [[bestTimes objectForKey:[NSString stringWithFormat:@"%d",level]] floatValue];
}


- (void) dealloc
{
	[bestTimes release];
	
	[super dealloc];
}



@end

