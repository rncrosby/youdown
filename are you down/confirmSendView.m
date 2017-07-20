//
//  confirmSendView.m
//  are you down
//
//  Created by Robert Crosby on 6/24/17.
//  Copyright © 2017 Robert Crosby. All rights reserved.
//

#import "confirmSendView.h"
#import "confirmSendCell.h"

#define CELL_HEIGHT 37

@interface confirmSendView () {
    UIDatePicker *datePicker;
    double timeSeconds;
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UISegmentedControl *segmentControl;
    __weak IBOutlet UIScrollView *superScrollView;
    __weak IBOutlet UITableView *guestTable;
    __weak IBOutlet UILabel *statusBarBlur;
    bool statusBar;
    int overallHeight;
    __weak IBOutlet UILabel *sendButton;
    __weak IBOutlet UILabel *sendButtonShadow;
    __weak IBOutlet UIButton *sendButtonAction;
    BOOL isSelectingDate;
    UILabel *blurItAll;
}

- (IBAction)segmentControl:(id)sender;
- (IBAction)send:(id)sender;

@end

@implementation confirmSendView

- (void)viewDidLoad {
    isSelectingDate = false;
    timeSeconds = 0;
    CAGradientLayer *gradient = [References createGradient:[References colorFromHexString:@"#F97794"] andColor:[References colorFromHexString:@"#623AA2"]];
    [sendButton.layer insertSublayer:gradient atIndex:0];
    [References cornerRadius:sendButton radius:sendButton.frame.size.width/2];
    [References cardshadow:sendButtonShadow];
    statusBar = NO;
    [References blurView:statusBarBlur];
    statusBarBlur.alpha = 0;
    titleLabel.text = _name;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated {
    [guestTable reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *simpleTableIdentifier = @"confirmSendCell";
    confirmSendCell *cell = (confirmSendCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        
    }
    if (indexPath.row == _recipientNames.count-1) {
        cell.layer.zPosition = -1;
        cell.clipsToBounds = NO;
        cell.card.frame = CGRectMake(cell.card.frame.origin.x, cell.card.frame.origin.y, cell.card.frame.size.width, cell.card.frame.size.height-5);
        cell.shadow.frame = CGRectMake(cell.shadow.frame.origin.x, cell.card.frame.origin.y, cell.shadow.frame.size.width, cell.card.frame.size.height-3);
        
    }
    if (indexPath.row == 0) {
        cell.layer.zPosition = -1;
        cell.clipsToBounds = NO;
        cell.card.frame = CGRectMake(cell.card.frame.origin.x, cell.card.frame.origin.y + 5, cell.card.frame.size.width, cell.card.frame.size.height);
        cell.shadow.frame = CGRectMake(cell.shadow.frame.origin.x, cell.card.frame.origin.y+3, cell.shadow.frame.size.width, cell.card.frame.size.height-3);
    }
    [References cornerRadius:cell.card radius:8.0f];
    cell.shadow.backgroundColor = [UIColor whiteColor];
    [References cardshadow:cell.shadow];
    cell.name.text = _recipientNames[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    superScrollView.contentSize = CGSizeMake([References screenWidth], guestTable.frame.origin.y + (CELL_HEIGHT*_recipients.count)+5);
    guestTable.frame = CGRectMake(0, guestTable.frame.origin.y, [References screenWidth], 5+(CELL_HEIGHT*_recipientNames.count));
    overallHeight = guestTable.frame.origin.y + (CELL_HEIGHT*_recipients.count);
    return _recipientNames.count;
}

-(BOOL)prefersStatusBarHidden {
    return YES;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y > 0) {
        if (statusBar == NO) {
            statusBar = YES;
            [References fadeIn:statusBarBlur];
            scrollView.bounces = FALSE;
        }
    } else if (scrollView.contentOffset.y <= 0) {
        scrollView.bounces = TRUE;
        if (statusBar == YES) {
            statusBar = NO;
            [References fadeOut:statusBarBlur];
        }
        if (scrollView.contentOffset.y < -100) {
            [_recipientNames removeAllObjects];
            [_recipients removeAllObjects];
            [guestTable reloadData];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (IBAction)segmentControl:(id)sender {
    NSString *selected = [segmentControl titleForSegmentAtIndex:segmentControl.selectedSegmentIndex];
    if ([selected isEqualToString:@"Now"]) {
        timeSeconds = 0;
        [segmentControl setSelectedSegmentIndex:0];
    } else if ([selected isEqualToString:@"Soon"]) {
        timeSeconds = 1;
        [segmentControl setSelectedSegmentIndex:1];
    } else {
        blurItAll = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [References screenWidth], [References screenHeight])];
        blurItAll.alpha = 0;
        [References blurView:blurItAll];
        [self.view addSubview:blurItAll];
        [self.view bringSubviewToFront:blurItAll];
        isSelectingDate = true;
        datePicker =[[UIDatePicker alloc]initWithFrame:CGRectMake(0, [References screenHeight]-162,[References screenWidth], 162)];
        datePicker.alpha = 0;
        datePicker.datePickerMode=UIDatePickerModeDateAndTime;
        datePicker.date=[NSDate date];
        [datePicker addTarget:self action:@selector(LabelTitle:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:datePicker];
        [self.view bringSubviewToFront:datePicker];
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             sendButton.frame = CGRectMake(sendButton.frame.origin.x, sendButton.frame.origin.y-200, sendButton.frame.size.width, sendButton.frame.size.height);
                             sendButtonAction.frame = CGRectMake(sendButtonAction.frame.origin.x, sendButtonAction.frame.origin.y-200, sendButtonAction.frame.size.width, sendButtonAction.frame.size.height);
                             sendButtonShadow.frame = CGRectMake(sendButtonShadow.frame.origin.x, sendButtonShadow.frame.origin.y-200, sendButtonShadow.frame.size.width, sendButtonShadow.frame.size.height);
                             [self.view bringSubviewToFront:sendButtonShadow];
                             [self.view bringSubviewToFront:sendButton];
                             [self.view bringSubviewToFront:sendButtonAction];
                             blurItAll.alpha = 1;
                             datePicker.alpha = 1;
                         }
                         completion:^(BOOL finished){
                         }];
        
       
        [segmentControl setSelectedSegmentIndex:2];
        
    }
}

- (IBAction)send:(id)sender {
    if (isSelectingDate == true) {
        
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             
                             datePicker.alpha = 0;
                             isSelectingDate = false;
                             sendButton.frame = CGRectMake(sendButton.frame.origin.x, sendButton.frame.origin.y+200, sendButton.frame.size.width, sendButton.frame.size.height);
                             sendButtonAction.frame = CGRectMake(sendButtonAction.frame.origin.x, sendButtonAction.frame.origin.y+200, sendButtonAction.frame.size.width, sendButtonAction.frame.size.height);
                             sendButtonShadow.frame = CGRectMake(sendButtonShadow.frame.origin.x, sendButtonShadow.frame.origin.y+200, sendButtonShadow.frame.size.width, sendButtonShadow.frame.size.height);
                             [self.view bringSubviewToFront:sendButtonShadow];
                             [self.view bringSubviewToFront:sendButton];
                             [self.view bringSubviewToFront:sendButtonAction];
                             blurItAll.alpha = 0;
                         }
                         completion:^(BOOL finished){
                             [datePicker removeFromSuperview];
                             [blurItAll removeFromSuperview];
                         }];
        
    } else {
        // send
    }
}

-(void)LabelTitle:(id)sender
{
    
    NSLog(@"%f",datePicker.date.timeIntervalSince1970);
    
}
@end
