//
//  HWBookFeedbackViewController.m
//  ios-homework-balepc
//
//  Created by Ruslan Skorb on 2/2/15.
//  Copyright (c) 2015 Ruslan Skorb. All rights reserved.
//

#import "HWBookFeedbackViewController.h"
#import "HWCommentTableViewCell.h"

static inline CGFLOAT_TYPE CGFloat_ceil(CGFLOAT_TYPE cgfloat) {
#if CGFLOAT_IS_DOUBLE
    return ceil(cgfloat);
#else
    return ceilf(cgfloat);
#endif
}

@interface HWBookFeedbackViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UITextView *commentPlaceholderTextView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sendBarButtonItem;
@property (weak, nonatomic) IBOutlet HWCommentTableViewCell *commentCell;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentTextViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentTextViewBottomConstraint;

@end

@implementation HWBookFeedbackViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.book.title;
    
    self.nameTextField.delegate = self;
    
    RAC(self.sendBarButtonItem, enabled) = [RACSignal
                                            combineLatest:@[self.nameTextField.rac_textSignal, self.commentTextView.rac_textSignal]
                                            reduce:^(NSString *name, NSString *comment) {
                                                return @((name.length > 0) && (comment.length > 100));
                                            }];
    
    @weakify(self)
    RAC(self.commentPlaceholderTextView, hidden) = [self.commentTextView.rac_textSignal map:^id(NSString *comment) {
        @strongify(self)
        if (!self) {
            return @(YES);
        }
        
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
        
        return @(comment.length > 0);
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:125/255.0f green:92/255.0f blue:79/255.0f alpha:1.0f]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
}

#pragma mark - IBActions

- (IBAction)onSendButtonPressed:(UIBarButtonItem *)sender
{
    [self sendFeedback];
}

#pragma mark - Private

- (void)sendFeedback
{
    [SVProgressHUD showWithStatus:@"Sending..."];
    [HomeWorkAPI createFeedbackForBook:self.book name:[self.nameTextField.text copy] comment:[self.commentTextView.text copy] success:^(id message) {
        [SVProgressHUD dismiss];
        [self showMessage:NSLocalizedString(@"Your feedback has been sent.", nil) title:NSLocalizedString(@"Thanks!", nil)];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self showMessage:error.localizedDescription title:NSLocalizedString(@"Couldn’t Send Feedback", nil)];
    }];
}

- (void)showMessage:(NSString *)message title:(NSString *)title
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView setAlertViewStyle:UIAlertViewStyleDefault];
    [alertView show];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        [self.commentCell setNeedsLayout];
        [self.commentCell layoutIfNeeded];
        
        CGFloat width = self.commentTextView.frame.size.width;
        
        CGFloat height = CGFloat_ceil([self.commentTextView sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)].height);
        height += self.commentTextView.textContainerInset.top;
        height += self.commentTextView.textContainerInset.bottom;
        height -= self.commentTextViewTopConstraint.constant;
        height -= self.commentTextViewBottomConstraint.constant;
        
        if (height < [self.commentCell minHeight]) {
            height = [self.commentCell minHeight];
        }
        
        return height;
    } else {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [self.nameTextField becomeFirstResponder];
    } else if (indexPath.section == 1) {
        [self.commentTextView becomeFirstResponder];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:self.nameTextField]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.commentTextView becomeFirstResponder];
            
            CGFloat bottomMargin = 10.0f;
            CGRect caretRect = [self.commentTextView caretRectForPosition:self.commentTextView.selectedTextRange.end];
            CGRect commentCellRect = self.commentCell.frame;
            CGRect caretRectInTableView = CGRectMake(caretRect.origin.x + commentCellRect.origin.x,
                                                     caretRect.origin.y + commentCellRect.origin.y + bottomMargin,
                                                     caretRect.size.width,
                                                     caretRect.size.height);
            
            [self.tableView scrollRectToVisible:caretRectInTableView animated:YES];
        });
    }
    return YES;
}

@end
