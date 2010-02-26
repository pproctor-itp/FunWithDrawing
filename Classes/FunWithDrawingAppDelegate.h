//
//  FunWithDrawingAppDelegate.h
//  FunWithDrawing
//
//  Created by Patrick Proctor on 2/24/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FunWithDrawingViewController;

@interface FunWithDrawingAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    FunWithDrawingViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet FunWithDrawingViewController *viewController;

@end

