	//
	//  AdManager.m
	//  Cross Me Not
	//
	//  Created by Manan Patel on 2/1/11.
	//  Copyright 2011 ngmoco:). All rights reserved.
	//

#import "AdManager.h"


@implementation AdManager

-(id)init:(UIViewController*)pVC
{
    if ((self = [super init]))
    {
		adViewVisible = FALSE;
        _parentViewController = pVC;
		
        [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://api.hostip.info/country.php"]] delegate:self startImmediately:YES];
    }	
    return self;
}

- (void)_animate:(UIView*)adView up:(BOOL)up
{
	if (up)
	{
        //if (adView.frame.origin.y == 480) 
		{
			[UIView beginAnimations:@"animateAdBannerUp" context:NULL];
			adView.frame = CGRectOffset(adView.frame, 0, -50);
			[UIView commitAnimations];	
		}
	}
	else 
	{
        //if (adView.frame.origin.y == -50) 
		{
			[UIView beginAnimations:@"animateAdBannerUp" context:NULL];
			adView.frame = CGRectOffset(adView.frame, 0, 50);
			[UIView commitAnimations];
		}
	}
}


-(UIView *) getAdView
{
	return _adView;
}

-(void) setParentView:(UIView*)pView andPosition:(Boolean)Top
{
	_parentView = pView;
	adTop = Top;
	if (_adView) 
	{
		if(adTop)
		{
			[_adView setFrame:TOP_AD_FRAME];
			if(!adViewVisible)
				_adView.frame = CGRectOffset(_adView.frame, 0, -50);
		}
		else
		{
			[_adView setFrame:BOTTOM_AD_FRAME];
			if(!adViewVisible)
				_adView.frame = CGRectOffset(_adView.frame, 0, 50);
		}
        
		[_parentView addSubview:_adView];
	}
	
}

-(void) shutdown
{
	[_adView removeFromSuperview];
	[_adView release];
	_adView = NULL;
}

-(void) dealloc
{
	[_adView release];
    [_parentViewController release];
    [_parentView release];
    [countryCode release];

	[super dealloc];
}

#pragma mark -
#pragma mark NSURLConnection delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSString* newStr = [[NSString alloc] initWithData:data                                                     encoding:NSUTF8StringEncoding];
    countryCode = newStr;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Get user's country code based on currentLocale
    NSLocale *locale = [NSLocale currentLocale];
    
    if ( countryCode == nil )
        countryCode = [locale objectForKey: NSLocaleCountryCode];
    if ([countryCode isEqualToString:@"XX"])
        countryCode = [locale objectForKey: NSLocaleCountryCode];
    
    if ([countryCode isEqualToString:@"US"] ||
        [countryCode isEqualToString:@"GB"] ||
        [countryCode isEqualToString:@"FR"] ||
        [countryCode isEqualToString:@"IT"] ||
        [countryCode isEqualToString:@"JP"] ||
        [countryCode isEqualToString:@"DE"])
    {
        // Use iAds
        ADBannerView *iadView = [[ADBannerView alloc] initWithFrame:BOTTOM_AD_FRAME];
        iadView.frame = CGRectOffset(iadView.frame, 0, 50);
        if( [[[UIDevice currentDevice] systemVersion] compare:@"4.2" options:NSNumericSearch] != NSOrderedAscending )
        {
            [iadView setRequiredContentSizeIdentifiers:[NSSet setWithObjects:ADBannerContentSizeIdentifierPortrait, nil]];
            [iadView setCurrentContentSizeIdentifier:ADBannerContentSizeIdentifierPortrait];
        }
        else 
        {
            [iadView setRequiredContentSizeIdentifiers:[NSSet setWithObjects:ADBannerContentSizeIdentifier320x50, nil]];
            [iadView setCurrentContentSizeIdentifier:ADBannerContentSizeIdentifier320x50];
        }
        
        [iadView setDelegate:self];
        _adView = iadView;			
    }
    else 
    {
        // Use Admob
        //_adView = [AdMobView requestAdWithDelegate:self];
        GADBannerView* bannerView = [[GADBannerView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
        bannerView.adUnitID = @"a14ddf107374a90";
        bannerView.rootViewController = _parentViewController;
        GADRequest* req = [GADRequest request];
        req.testDevices = [NSArray arrayWithObjects:GAD_SIMULATOR_ID, nil];
        [bannerView loadRequest:req];
        bannerView.delegate = self;
        
        _adView = bannerView;
    }
    [self setParentView:_parentViewController.view andPosition:FALSE];
}

#pragma mark -
#pragma mark ADBannerViewDelegate methods

- (void)bannerViewDidLoadAd:(ADBannerView *)banner 
{
	if (!adViewVisible) {
		[self _animate:banner up:!adTop];
		adViewVisible = TRUE;
	}
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
		//iAds failed
	NSLog(@"%@",[error localizedDescription]);
	if (adViewVisible)
	{
		[self _animate:banner up:adTop];
		adViewVisible = FALSE;
	}	
		// clean iAds
		//[banner removeFromSuperview];
		//[banner release];
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
	[[[UIApplication sharedApplication] delegate] applicationWillResignActive:nil];
	return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner {
	[[[UIApplication sharedApplication] delegate] applicationDidBecomeActive:nil];
}


#pragma mark -
#pragma mark GAD delegate methods
- (void)adViewDidReceiveAd:(GADBannerView *)view
{
    if (adTop)
	{
		[_adView setFrame:TOP_AD_FRAME];
		_adView.frame = CGRectOffset(_adView.frame, 0, -50);
		[_parentView addSubview:_adView];
	}
	else
	{
		[_adView setFrame:BOTTOM_AD_FRAME];
		_adView.frame = CGRectOffset(_adView.frame, 0, 50);
		[_parentView addSubview:_adView];
	}
	
	if (!adViewVisible) {
		[self _animate:_adView up:!adTop];
		adViewVisible = TRUE;
	}
}

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error
{
	if(adViewVisible)
	{
		[self _animate:_adView up:adTop];
		adViewVisible = FALSE;
	}
}

- (void)adViewWillPresentScreen:(GADBannerView *)adView
{
    
}

- (void)adViewWillDismissScreen:(GADBannerView *)adView
{
    
}

- (void)adViewDidDismissScreen:(GADBannerView *)adView
{
    
}

- (void)adViewWillLeaveApplication:(GADBannerView *)adView
{
    
}


@end
