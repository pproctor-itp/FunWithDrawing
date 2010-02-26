//
//  MyCustomView.m
//  FunWithDrawing
//
//  Created by Patrick Proctor on 2/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MyCustomView.h"
#import "stdlib.h"
#import "math.h"

#define kAccelerometerFrequency        10 //Hz

const int dropCount = 60;
const int cloudCount = 40;

@implementation MyCustomView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}

- (void) awakeFromNib
{
	// you have to initialize your view here since it's getting
	// instantiated by the nib
	twoFingers = NO;
	
	// Start by creating 10 drops and 10 clouds
	allDrops = new Drop[dropCount];
	allClouds = new Cloud[cloudCount];
	
	for (int i = 0; i < cloudCount; i++)
	{
		CGRect myBounds = self.bounds;
		CGFloat xLoc = (myBounds.size.width/(cloudCount-1))*i;
		allClouds[i].x = xLoc;
		allClouds[i].y = 10 * (rand() % 4);
	}
	
	for (int i = 0; i < dropCount; i++)
	{
		allDrops[i].x = allClouds[i % cloudCount].x;
		allDrops[i].y = 20;
		allDrops[i].active = NO;
	}
	
	// define colors
	dropColor = CGColorCreateGenericRGB(0.0f, 0.2f, 1.0f, 0.90f);
	waterColor = CGColorCreateGenericRGB(0.0f, 0.0f, .2f, 0.90f);
	cloudColor = CGColorCreateGenericRGB(0.63f, 0.63f, 0.83f, 0.60f);
	
	// Initialize the water level at 5 pixels
	waterLevel = 50;
	
	// configure for accelerometer
	[self configureAccelerometer];
}

-(void)configureAccelerometer
{
	UIAccelerometer*  theAccelerometer = [UIAccelerometer sharedAccelerometer];
	
	if(theAccelerometer)
	{
		theAccelerometer.updateInterval = 1 / kAccelerometerFrequency;
		theAccelerometer.delegate = self;
	}
	else
	{
		NSLog(@"Oops we're not running on the device!");
	}
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
	if (maxWater == NO)
	{
		float accel = fabs(acceleration.x);
		if (accel > 1.0f)
		{
			int changer = rand() % dropCount;
			
			// For every noticeable acceleration event, randomly activate a drop
			allDrops[changer].active = YES;
			
			changer = rand() % dropCount;
			
			// For every noticeable acceleration event, randomly activate a drop
			allDrops[changer].active = YES;
		}
	}
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect 
{	
	if (maxWater == YES)
	{
		// Draw the water
		CGContextRef context = UIGraphicsGetCurrentContext();
		CGContextSetFillColorWithColor(context, waterColor);
		CGContextFillRect(context, CGRectMake(0, (rect.size.height - waterLevel), rect.size.width, waterLevel));
		
		CGFloat waveSize = rect.size.width / 10;
		
		CGContextBeginPath(context);
		CGContextMoveToPoint(context, 0, (rect.size.height - waterLevel));
		
		int i = 0;
		
		for (i = 1; i < 12; i+=2)
		{
			CGContextAddArcToPoint(context, (waveSize * (i-1)), (rect.size.height - waterLevel), waveSize*i, (rect.size.height - waterLevel-15),30);
			CGContextAddArcToPoint(context, waveSize*i, (rect.size.height - waterLevel-15), waveSize*(i+1), (rect.size.height - waterLevel),30);
		}
		
		CGContextAddLineToPoint(context, waveSize*(i), (rect.size.height - waterLevel));
		
		CGContextFillPath(context);
		
		for (int i = 0; i < cloudCount; i++)
		{
			[self drawCloud:allClouds[i]];
		}
		waterLevel-=5;
		if (waterLevel <= 50)
		{
			maxWater = NO;
		}
	}
	else
	{
		// First check your drops to see if any have reached the water
		for (int i = 0; i < dropCount; i++)
		{
			if (allDrops[i].y > (rect.size.height - waterLevel))
			{
				allDrops[i].x = allClouds[i % cloudCount].x;
				allDrops[i].y = 20;
				allDrops[i].active = NO;
				waterLevel+=2;
			}
		}
		
		// Draw the water
		CGContextRef context = UIGraphicsGetCurrentContext();
		CGContextSetFillColorWithColor(context, waterColor);
		CGContextFillRect(context, CGRectMake(0, (rect.size.height - waterLevel), rect.size.width, waterLevel));
		
		CGFloat waveSize = rect.size.width / 10;
		
		CGContextBeginPath(context);
		CGContextMoveToPoint(context, 0, (rect.size.height - waterLevel));
		
		int i = 0;
		
		for (i = 1; i < 12; i+=2)
		{
			CGContextAddArcToPoint(context, (waveSize * (i-1)), (rect.size.height - waterLevel), waveSize*i, (rect.size.height - waterLevel-15),30);
			CGContextAddArcToPoint(context, waveSize*i, (rect.size.height - waterLevel-15), waveSize*(i+1), (rect.size.height - waterLevel),30);
		}
		
		CGContextAddLineToPoint(context, waveSize*(i), (rect.size.height - waterLevel));
		
		CGContextFillPath(context);
		
		// Iterate over clouds and drops, and draw each, and adjust position of drops
		for (int i = 0; i < cloudCount; i++)
		{
			[self drawCloud:allClouds[i]];
		}
		for (int i = 0; i < dropCount; i++)
		{
			[self drawDrop:allDrops[i]];
			if (allDrops[i].active == YES)
			{
				allDrops[i].y += 3;
			}
		}
		if (waterLevel > rect.size.height - 100)
		{
			maxWater = YES;
			
			for (int i = 0; i < dropCount; i++)
			{
				allDrops[i].active = NO;
				allDrops[i].x = allClouds[i % cloudCount].x;
				allDrops[i].y = 20;
			}
		}
	}
}

- (void)drawDrop:(Drop)myDrop
{
	// Only draw if active
	if (myDrop.active == YES)
	{
		float diameter = 10;
		float radius = .5 * diameter;
		CGRect myOval = {myDrop.x - radius, myDrop.y - radius, diameter, diameter};
		CGContextRef context = UIGraphicsGetCurrentContext();
		CGContextSetFillColorWithColor(context, dropColor);
		CGContextAddEllipseInRect(context, myOval);
		CGContextFillPath(context);
		
		CGContextBeginPath(context);
		CGContextMoveToPoint(context, myDrop.x - radius, myDrop.y);
		CGContextAddLineToPoint(context, myDrop.x, myDrop.y - (2 * radius));
		CGContextAddLineToPoint(context, myDrop.x + radius, myDrop.y);
		CGContextClosePath(context);
		CGContextFillPath(context);
	}
}

- (void)drawCloud:(Cloud)myCloud
{
	float diameter = 50;
	float radius = .5 * diameter;
	CGRect myOval = {myCloud.x - radius, myCloud.y - radius, diameter, diameter};
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetFillColorWithColor(context, cloudColor);
	CGContextAddEllipseInRect(context, myOval);
	CGContextFillPath(context);
}


- (void)dealloc {
    [super dealloc];
}


@end
