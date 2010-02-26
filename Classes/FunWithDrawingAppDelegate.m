//
//  FunWithDrawingAppDelegate.m
//  FunWithDrawing
//
//  Created by Patrick Proctor on 2/24/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "FunWithDrawingAppDelegate.h"
#import "FunWithDrawingViewController.h"

@implementation FunWithDrawingAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
