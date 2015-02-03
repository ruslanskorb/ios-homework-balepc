//
//  HWBooksViewController.m
//  ios-homework-balepc
//
//  Created by Ruslan Skorb on 2/2/15.
//  Copyright (c) 2015 Ruslan Skorb. All rights reserved.
//

#import "HWBooksViewController.h"
#import "HWBooksNetworkModel.h"
#import "HWBookTableViewCell.h"
#import "UIScrollView+EmptyDataSet.h"
#import "PQFCustomLoaders.h"
#import "HWBookFeedbackViewController.h"

NSString * const HWFromBooksToBookFeedbackIdentifier = @"HWFromBooksToBookFeedbackIdentifier";

@interface HWBooksViewController () <DZNEmptyDataSetSource>

@property (copy, nonatomic) NSArray *books;

@property (strong, nonatomic) HWBooksNetworkModel *networkModel;

@property (strong, nonatomic) dispatch_queue_t booksPageQueue;
@property (nonatomic, assign) BOOL booksPageQueueSuspended;

@end

@implementation HWBooksViewController

#pragma mark - Lifecycle

- (void)dealloc
{
    [self resumePageQueue];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _books = [[NSArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.emptyDataSetSource = self;
    
    // A little trick for removing the cell separators
    self.tableView.tableFooterView = [UIView new];
    
    if (!self.booksPageQueue) {
        self.booksPageQueue = dispatch_queue_create("Books Pages", NULL);
    } else {
        [self resumePageQueue];
    }
    
    self.networkModel = [[HWBooksNetworkModel alloc] init];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self registerForObservers];
    [self getBookSet];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self suspendPageQueue];
    
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self unregisterForObservers];
    
    [super viewDidDisappear:animated];
}

#pragma mark - Private

- (void)resumePageQueue
{
    if (self.booksPageQueue && self.booksPageQueueSuspended) {
        dispatch_resume(self.booksPageQueue);
        self.booksPageQueueSuspended = NO;
    }
}

- (void)suspendPageQueue
{
    if (self.booksPageQueue && !self.booksPageQueueSuspended) {
        dispatch_suspend(self.booksPageQueue);
        self.booksPageQueueSuspended = YES;
    }
}

- (void)registerForObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkAvailable:)
                                                 name:HWNetworkAvailableNotification
                                               object:nil];
}

- (void)unregisterForObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:HWNetworkAvailableNotification
                                                  object:nil];
}

- (void)networkAvailable:(NSNotification *)notification
{
    if (self.books.count == 0) {
        self.networkModel = [[HWBooksNetworkModel alloc] init];
        [self getBookSet];
    }
}

- (void)getBookSet
{
    @weakify(self);
    dispatch_async(self.booksPageQueue, ^{
        [self.networkModel getBooks:^(NSArray *books){
            @strongify(self);
            [self addBooks:books];
        } failure:nil];
    });
}

- (void)addBooks:(NSArray *)books
{
    if (books.count > 0) {
        self.books = [self.books arrayByAddingObjectsFromArray:books];
    }
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.books.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Book *book = self.books[indexPath.row];
    HWBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[book cellIdentifier] forIndexPath:indexPath];
    [cell configureWithBook:book];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 94.0f;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 94.0f;
}

#pragma mark - DZNEmptyDataSetSource

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = NSLocalizedString(@"No Data", nil);
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0f],
                                 NSForegroundColorAttributeName: [UIColor rsk_grayColor],
                                 NSParagraphStyleAttributeName: paragraphStyle
                                 };
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = NSLocalizedString(@"Unable to load books. Please\nсheck back later.", nil);
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:15.0f],
                                 NSForegroundColorAttributeName: [UIColor rsk_grayColor],
                                 NSParagraphStyleAttributeName: paragraphStyle
                                 };
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView
{
    if (self.networkModel.allDownloaded) {
        return nil;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:self.view.frame];
    PQFCirclesInTriangle *circlesInTriangle = [[PQFCirclesInTriangle alloc] initLoaderOnView:view];
    circlesInTriangle.loaderColor = [UIColor rsk_lightGrayColor];
    [circlesInTriangle show];
    
    return view;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:HWFromBooksToBookFeedbackIdentifier]) {
        HWBookTableViewCell *cell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        HWBookFeedbackViewController *controller = segue.destinationViewController;
        controller.book = self.books[indexPath.row];
    }
}

@end
