//
//  HWAppDelegate.m
//  ios-homework-balepc
//
//  Created by Ruslan Skorb on 2/2/15.
//  Copyright (c) 2015 Ruslan Skorb. All rights reserved.
//

#import "HWAppDelegate.h"
#import "HWRouter.h"

@interface HWAppDelegate ()

@end

@implementation HWAppDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [HWRouter setup];
    [self customizeAppearance];
    
    return YES;
}

- (void)customizeAppearance
{
    [UINavigationBar appearance].barStyle = UIBarStyleBlack;
    [UINavigationBar appearance].barTintColor = [UIColor colorWithRed:125/255.0f green:92/255.0f blue:79/255.0f alpha:1.0f];
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    [UINavigationBar appearance].titleTextAttributes = @{
                                                         NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Medium" size:17.0f],
                                                         NSForegroundColorAttributeName: [UIColor whiteColor]
                                                         };
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{
                                                           NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:17.0f],
                                                           NSForegroundColorAttributeName: [UIColor whiteColor]
                                                           }
                                                forState:UIControlStateNormal|UIControlStateHighlighted];
}

@end
