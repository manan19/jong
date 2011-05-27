//
//  AdManager.h
//  Cross Me Not
//
//  Created by Manan Patel on 2/1/11.
//  Copyright 2011 ngmoco:). All rights reserved.
//

#import "FlurryAPI.h"
#import <Foundation/Foundation.h>
#import <iAd/ADBannerView.h>

#define TOP_AD_FRAME CGRectMake(0, 0, 320, 50)
#define BOTTOM_AD_FRAME CGRectMake(0, 430, 320, 50)

@interface AdManager : NSObject <ADBannerViewDelegate> {
	UIView *_adView;
	@public BOOL adFree,adViewVisible,adTop;
	UIView *_parentView;
	UIViewController *_parentViewController;
}

- (UIView*) getAdView;
-(void) setParentView:(UIView*)pView andPosition:(Boolean)Top;
-(void) setParentViewController:(UIViewController*)pVC;
-(void) shutdown;


- (void) _animate:(UIView*)adView up:(BOOL)up;


@end
