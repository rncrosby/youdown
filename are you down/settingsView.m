//
//  settingsView.m
//  are you down
//
//  Created by Robert Crosby on 6/22/17.
//  Copyright © 2017 Robert Crosby. All rights reserved.
//

#import "settingsView.h"
#import "References.h"
#import "UIColor+BFPaperColors.h"

@interface settingsView () {
    
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UIButton *dismiss;
    __weak IBOutlet UIScrollView *superScrollView;
    __weak IBOutlet UILabel *signOutCard;
    __weak IBOutlet UILabel *signOutCardShadow;
    __weak IBOutlet UILabel *feedbackCard;
    __weak IBOutlet UILabel *feedbackCardShadow;
    __weak IBOutlet UILabel *fullyToastedShadow;
    __weak IBOutlet UILabel *statusBarBlur;
    bool doStatusBarBlur;
    __weak IBOutlet UIButton *iMessageUs;
    __weak IBOutlet UIButton *onTheAppStore;
    __weak IBOutlet UILabel *feedBackText;
    __weak IBOutlet UILabel *signOutText;
    
    __weak IBOutlet UILabel *mastTop;
    __weak IBOutlet UILabel *mastMiddle;
    __weak IBOutlet UILabel *mastBottom;
    
    
    
}
- (IBAction)dismissView:(id)sender;
- (IBAction)signOut:(id)sender;
- (IBAction)reviewOnAppStore:(id)sender;
- (IBAction)messageUs:(id)sender;

@end

@implementation settingsView

- (void)viewDidLoad {
    int ogWidth = signOutCard.frame.size.width;
    if ([References screenHeight] > 568) {
        dismiss.frame = CGRectMake(dismiss.frame.origin.x+50, dismiss.frame.origin.y, dismiss.frame.size.width, dismiss.frame.size.height);
        superScrollView.frame = CGRectMake(0, 0, [References screenWidth], [References screenHeight]);
        feedbackCard.frame = CGRectMake(feedbackCard.frame.origin.x, feedbackCard.frame.origin.y, [References screenWidth] - 16, feedbackCard.frame.size.height);
        feedbackCardShadow.frame = CGRectMake(feedbackCardShadow.frame.origin.x, feedbackCardShadow.frame.origin.y, [References screenWidth] - 21, fullyToastedShadow.frame.size.height);
        signOutCard.frame = CGRectMake(signOutCard.frame.origin.x, signOutCard.frame.origin.y, [References screenWidth] - 16, signOutCard.frame.size.height);
        signOutCardShadow.frame = CGRectMake(signOutCardShadow.frame.origin.x, signOutCardShadow.frame.origin.y, [References screenWidth] - 21, signOutCardShadow.frame.size.height);
        onTheAppStore.frame = CGRectMake(onTheAppStore.frame.origin.x, onTheAppStore.frame.origin.y, onTheAppStore.frame.size.width+((feedbackCard.frame.size.width-ogWidth)/2), onTheAppStore.frame.size.height);
        iMessageUs.frame = CGRectMake(iMessageUs.frame.origin.x+((feedbackCard.frame.size.width-ogWidth)/2), iMessageUs.frame.origin.y, iMessageUs.frame.size.width+((feedbackCard.frame.size.width-ogWidth)/2), iMessageUs.frame.size.height);
        feedBackText.frame = CGRectMake(feedBackText.frame.origin.x, feedBackText.frame.origin.y, feedbackCard.frame.size.width, feedBackText.frame.size.height);
        signOutText.frame = CGRectMake(signOutText.frame.origin.x, signOutText.frame.origin.y, signOutText.frame.size.width+50, signOutText.frame.size.height);
        mastTop.frame = CGRectMake(0, mastTop.frame.origin.y+80, [References screenWidth], mastTop.frame.size.height);
        mastBottom.frame = CGRectMake(0, mastBottom.frame.origin.y+80, [References screenWidth], mastBottom.frame.size.height);
        mastMiddle.frame = CGRectMake(0, mastMiddle.frame.origin.y+80, [References screenWidth], mastMiddle.frame.size.height);
        statusBarBlur.frame = CGRectMake(statusBarBlur.frame.origin.x, statusBarBlur.frame.origin.y, [References screenWidth], statusBarBlur.frame.size.height);
        if ([References screenHeight] > 667) {
            mastTop.frame = CGRectMake(0, mastTop.frame.origin.y+50, [References screenWidth], mastTop.frame.size.height);
            mastBottom.frame = CGRectMake(0, mastBottom.frame.origin.y+50, [References screenWidth], mastBottom.frame.size.height);
            mastMiddle.frame = CGRectMake(0, mastMiddle.frame.origin.y+50, [References screenWidth], mastMiddle.frame.size.height);
            dismiss.frame = CGRectMake(dismiss.frame.origin.x+30, dismiss.frame.origin.y, dismiss.frame.size.width, dismiss.frame.size.height);
        }
    }
    doStatusBarBlur = NO;
    [References tintUIButton:dismiss color:[UIColor darkGrayColor]];
    [References createLine:superScrollView xPos:8 yPos:titleLabel.frame.origin.y+titleLabel.frame.size.height+4];
    CAGradientLayer *gradient = [References createGradient:[References colorFromHexString:@"#FEB692"] andColor:[References colorFromHexString:@"#EA5455"]];
    CAGradientLayer *gradient3 = [References createGradient:[References colorFromHexString:@"#ABDCFF"] andColor:[References colorFromHexString:@"#0396FF"]];
    [signOutCard.layer insertSublayer:gradient atIndex:0];
    signOutCardShadow.backgroundColor = [UIColor whiteColor];
    [References cardshadow:signOutCardShadow];
    [References cornerRadius:signOutCard radius:8.0f];
    
    [feedbackCard.layer insertSublayer:gradient3 atIndex:0];
    feedbackCardShadow.backgroundColor = [UIColor whiteColor];
    [References cardshadow:feedbackCardShadow];
    [References cornerRadius:feedbackCard radius:8.0f];

    doStatusBarBlur = NO;
    [References blurView:statusBarBlur];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y > 0) {
        if (doStatusBarBlur == NO) {
            doStatusBarBlur = YES;
            [References fadeIn:statusBarBlur];
        }
    } else if (scrollView.contentOffset.y <= 0) {
        if (doStatusBarBlur == YES) {
            doStatusBarBlur = NO;
            [References fadeOut:statusBarBlur];
        }
    }
}

- (IBAction)dismissView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)signOut:(id)sender {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isSignOut"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"name"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"phone"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    UIStoryboard *iPhone4Storyboard = [UIStoryboard storyboardWithName:@"iPhone4" bundle:nil];
    UIViewController *initialViewController = [iPhone4Storyboard instantiateInitialViewController];
    [self presentViewController:initialViewController animated:YES completion:nil];
}

- (IBAction)reviewOnAppStore:(id)sender {
    [SKStoreReviewController requestReview];
}

- (IBAction)messageUs:(id)sender {
    NSArray *recipents = @[@"5105416477"];
    NSString *message = [NSString stringWithFormat:@"You guys should change..."];
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:recipents];
    [messageController setBody:message];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
