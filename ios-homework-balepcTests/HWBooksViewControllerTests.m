//
//  HWBooksViewControllerTests.m
//  ios-homework-balepc
//
//  Created by Ruslan Skorb on 2/2/15.
//  Copyright (c) 2015 Ruslan Skorb. All rights reserved.
//

#import "HWBooksViewController.h"
#import "HWBooksNetworkModel.h"
#import "HWBookFeedbackViewController.h"

@interface HWBooksViewController ()

@property (strong, readonly, nonatomic) HWBooksNetworkModel *networkModel;
@property (strong, readonly, nonatomic) NSArray *books;

- (void)getBookSet;
- (void)updateView;

@end

SpecBegin(HWBooksViewController)

__block HWBooksViewController *booksVC = nil;
__block id mock;

dispatch_block_t sharedBefore = ^{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    booksVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"HWBooksViewControllerID"];
    mock = [OCMockObject partialMockForObject:booksVC];
    [[mock stub] getBookSet];
};

after(^{
    [mock stopMocking];
    booksVC = nil;
});

describe(@"general", ^{
    before(^{
        sharedBefore();
    });
    
    it(@"initialization", ^{
        expect(booksVC.view).toNot.beNil();
    });
});

describe(@"books", ^{
    itHasSnapshotsForDevices(@"with no books", ^{
        sharedBefore();
        
        id networkModelMock = [OCMockObject niceMockForClass:[HWBooksNetworkModel class]];
        [[[networkModelMock stub] andReturnValue:OCMOCK_VALUE(YES)] allDownloaded];
        [[[mock stub] andReturn:networkModelMock] networkModel];
        
        [booksVC.view layoutIfNeeded]; // lays out the subviews immediately
        
        return booksVC;
    });
    
    describe(@"with books", ^{
        __block NSMutableArray *books;
        dispatch_block_t booksBefore = ^{
            sharedBefore();
            books = [NSMutableArray array];
            
            for(int i = 0; i < 9; ++i) {
                Book *book  = [[Book alloc] initWithDictionary:@{
                                                                 @"bookID": @"stubbed",
                                                                 @"title": [NSString stringWithFormat:@"Book %d", i],
                                                                 @"author": [NSString stringWithFormat:@"Author %d", i]
                                                                 } error:nil];
                
                [books addObject:book];
            }
            
            [[[mock stub] andReturn:books] books];
        };
        
        itHasSnapshotsForDevices(@"with books", ^{
            booksBefore();
            
            [booksVC.view layoutIfNeeded]; // lays out the subviews immediately
            
            return booksVC;
        });
        
        it(@"handles tap", ^{
            booksBefore();
            
            expect(booksVC.view).notTo.beNil();
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
            
            HWBookFeedbackViewController *bookFeedbackVC = [[HWBookFeedbackViewController alloc] init];
            id bookFeedbackStub = [OCMockObject partialMockForObject:bookFeedbackVC];
            [[bookFeedbackStub expect] setBook:books[indexPath.row]];
            
            UITableView *tableView = booksVC.tableView;
            id tableViewStub = [OCMockObject partialMockForObject:tableView];
            [[[tableViewStub stub] andReturn:indexPath] indexPathForCell:OCMOCK_ANY];
            
            UIStoryboardSegue *segue = [[UIStoryboardSegue alloc] initWithIdentifier:HWFromBooksToBookFeedbackIdentifier source:booksVC destination:bookFeedbackVC];
            [booksVC prepareForSegue:segue sender:OCMOCK_ANY];
            
            [bookFeedbackStub verify];
        });
    });
});

SpecEnd