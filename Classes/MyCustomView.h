//
//  MyCustomView.h
//  FunWithDrawing
//
//  Created by Patrick Proctor on 2/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef struct
	{
		CGFloat x;
		CGFloat y;
	}Cloud;

typedef struct
	{
		CGFloat x;
		CGFloat y;
		BOOL active;
	}Drop;

@interface MyCustomView : UIView 
{
	
	CGFloat					   waterLevel;
	CGColorRef                 dropColor;
	CGColorRef                 waterColor;
	CGColorRef                 cloudColor;
	BOOL                       twoFingers;
	BOOL					   maxWater;
	
	Drop*					   allDrops;
	Cloud*					   allClouds;
}

- (void)drawDrop:(Drop)myDrop;
- (void)drawCloud:(Cloud)myCloud;

@end
