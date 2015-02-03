//
//  HWRouterTests.m
//  ios-homework-balepc
//
//  Created by Ruslan Skorb on 2/2/15.
//  Copyright (c) 2015 Ruslan Skorb. All rights reserved.
//

#import "HWRouter.h"

SpecBegin(HWRouter)

describe(@"User-Agent", ^{
    __block NSString *userAgent = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserAgent"];
    
    it(@"uses HW-Mobile", ^{
        expect(userAgent).to.beginWith(@"HW-Mobile/");
    });
    
    it(@"uses ios-homework-balepc", ^{
        expect(userAgent).to.contain(@"ios-homework-balepc/");
    });
    
    it(@"contains version number", ^{
        expect(userAgent).to.contain([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]);
    });
    
    it(@"contains build number", ^{
        expect(userAgent).to.contain([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]);
    });
    
    it(@"is contained in requests sent out from router", ^{
        Book *book = [Book modelWithJSON:@{@"id": @"book_id"}];
        NSURLRequest *request = [HWRouter newCreateFeedbackRequestForBook:book name:@"name" comment:@"comment"];
        
        expect([request.allHTTPHeaderFields objectForKey:@"User-Agent"]).to.beTruthy();
        expect(request.allHTTPHeaderFields[@"User-Agent"]).to.equal(userAgent);
        
        request = [HWRouter newBooksRequest];
        expect(request.allHTTPHeaderFields[@"User-Agent"]).to.equal(userAgent);
    });
});

SpecEnd
