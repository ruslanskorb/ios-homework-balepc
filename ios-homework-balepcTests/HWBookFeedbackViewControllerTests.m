//
//  HWBookFeedbackViewControllerTests.m
//  ios-homework-balepc
//
//  Created by Ruslan Skorb on 2/2/15.
//  Copyright (c) 2015 Ruslan Skorb. All rights reserved.
//

#import "HWBookFeedbackViewController.h"
#import "HWNetworkConstants.h"

@interface HWBookFeedbackViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sendBarButtonItem;

- (void)sendFeedback;

@end

SpecBegin(HWBookFeedbackViewController)

describe(@"feedback for the book", ^{
    __block HWBookFeedbackViewController *controller;
    __block NSString *name;
    __block NSString *comment;
    
    describe(@"snapshots", ^{
        beforeEach(^{
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            controller = [mainStoryboard instantiateViewControllerWithIdentifier:@"HWBookFeedbackViewControllerID"];
            name = @"User Name";
            comment = @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.";
        });
        
        itHasSnapshotsForDevices(@"blank form", ^{
            return controller;
        });
        
        itHasSnapshotsForDevices(@"completed form", ^{
            controller.nameTextField.text = name;
            controller.commentTextView.text = comment;
            
            return controller;
        });
    });
    
    describe(@"send feedback", ^{
        __block Book *book;
        
        beforeEach(^{
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            controller = [mainStoryboard instantiateViewControllerWithIdentifier:@"HWBookFeedbackViewControllerID"];
            [controller view]; // loads view and calls viewDidLoad
            
            book = [Book modelWithJSON:@{
                                         @"id": @"1",
                                         @"title": @"MongoDB: The Definitive Guide",
                                         @"author": @"Kristina Chodorow",
                                         @"cover_image": @"http://akamaicovers.oreilly.com/images/0636920001096/cat.gif"
                                         }];
            controller.book = book;
            
            name = @"User Name";
            comment = @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.";
        });
        
        it(@"displays a confirmation after sending a feedback", ^{
            [OHHTTPStubs stubJSONResponseAtPath:[NSString stringWithFormat:HWCreateFeedbackForBookURLFormat, book.bookID]
                                   withResponse:@{@"status": @"ok", @"id": book.bookID, @"name": name, @"comment": comment}
                                  andStatusCode:201];
            
            id mockAlertView = [OCMockObject mockForClass:[UIAlertView class]];
            [[mockAlertView expect] setAlertViewStyle:UIAlertViewStyleDefault];
            [[[mockAlertView stub] andReturn:mockAlertView] alloc];
            (void)[[[mockAlertView expect] andReturn:mockAlertView]
                   initWithTitle:NSLocalizedString(@"Thanks!", nil)
                   message:NSLocalizedString(@"Your feedback has been sent.", nil)
                   delegate:OCMOCK_ANY
                   cancelButtonTitle:OCMOCK_ANY
                   otherButtonTitles:OCMOCK_ANY, nil];
            [[mockAlertView expect] show];
            
            [controller sendFeedback];
            
            [mockAlertView verifyWithDelay:1];
            [mockAlertView stopMocking];
        });
        
        it(@"displays an error on failure to send a feedback", ^{
            [OHHTTPStubs stubJSONResponseAtPath:[NSString stringWithFormat:HWCreateFeedbackForBookURLFormat, book.bookID]
                                   withResponse:@{@"status": @"fail"}
                                  andStatusCode:400];
            
            id mockAlertView = [OCMockObject mockForClass:[UIAlertView class]];
            [[mockAlertView expect] setAlertViewStyle:UIAlertViewStyleDefault];
            [[[mockAlertView stub] andReturn:mockAlertView] alloc];
            (void)[[[mockAlertView expect] andReturn:mockAlertView]
                   initWithTitle:NSLocalizedString(@"Couldn’t Send Feedback", nil)
                   message:OCMOCK_ANY
                   delegate:OCMOCK_ANY
                   cancelButtonTitle:OCMOCK_ANY
                   otherButtonTitles:OCMOCK_ANY, nil];
            [[mockAlertView expect] show];
            
            [controller sendFeedback];
            
            [mockAlertView verifyWithDelay:1];
            [mockAlertView stopMocking];
        });
    });
});

SpecEnd
