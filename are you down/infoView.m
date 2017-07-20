//
//  infoView.m
//  are you down
//
//  Created by Robert Crosby on 6/12/17.
//  Copyright © 2017 Robert Crosby. All rights reserved.
//

#import "infoView.h"
#import "References.h"

@interface infoView () {
    
    bool alertIsShowing;
    __weak IBOutlet UILabel *gradientTop;
    __weak IBOutlet UILabel *createdBy;
    __weak IBOutlet UILabel *activityTitle;
    __weak IBOutlet UIButton *close;
    __weak IBOutlet UIScrollView *chatView;
    __weak IBOutlet UIToolbar *toolBar;
    __weak IBOutlet UIButton *sendButton;
    __weak IBOutlet UITextField *messageField;
    __weak IBOutlet UISegmentedControl *segmentControl;
    __weak IBOutlet UIScrollView *moreView;
    __weak IBOutlet UITableView *guestsTable;
    __weak IBOutlet UILabel *leaveShadow;
    __weak IBOutlet UILabel *leaveCard;


}

- (IBAction)close:(id)sender;
- (IBAction)sendMessage:(id)sender;
- (IBAction)changeSegment:(id)sender;
- (IBAction)leaveEvent:(id)sender;

@end

@implementation infoView

- (void)viewDidLoad {
    if ([References screenHeight] > 568) {
        segmentControl.frame = CGRectMake(segmentControl.frame.origin.x, segmentControl.frame.origin.y, [References screenWidth]-16, segmentControl.frame.size.height);
        chatView.frame = CGRectMake(chatView.frame.origin.x, chatView.frame.origin.y, [References screenWidth], [References screenHeight]-chatView.frame.origin.y);
        close.frame = CGRectMake(close.frame.origin.x+50, close.frame.origin.y, close.frame.size.width, close.frame.size.height);
        moreView.frame = CGRectMake(moreView.frame.origin.x, moreView.frame.origin.y, [References screenWidth], [References screenHeight]-chatView.frame.origin.y);
        guestsTable.frame = CGRectMake(guestsTable.frame.origin.x, guestsTable.frame.origin.y, [References screenWidth], [References screenHeight]-guestsTable.frame.origin.y);
        leaveCard.frame = CGRectMake(leaveCard.frame.origin.x, leaveCard.frame.origin.y, [References screenWidth]-16, leaveCard.frame.size.height);
        leaveShadow.frame = CGRectMake(leaveCard.frame.origin.x+5, leaveCard.frame.origin.y+5, leaveCard.frame.size.width-10, leaveCard.frame.size.height-10);
        if ([References screenHeight] > 667) {
            close.frame = CGRectMake(close.frame.origin.x+30, close.frame.origin.y, close.frame.size.width, close.frame.size.height);

        }
    }
    toolBar.frame = CGRectMake(0, [References screenHeight] - toolBar.frame.size.height, [References screenWidth], toolBar.frame.size.height);
    [self.view bringSubviewToFront:toolBar];
    guestsTable.frame = CGRectMake(0, guestsTable.frame.origin.y, guestsTable.frame.size.width, guestsTable.frame.size.height);
    moreView.frame = CGRectMake(0, moreView.frame.origin.y, moreView.frame.size.width, moreView.frame.size.height);
    moreView.hidden = YES;
    guestsTable.hidden = YES;
    guestNames = [[NSMutableArray alloc] init];
    guestNames = [_activity valueForKey:@"guestNames"];
    guestNumbers = [[NSMutableArray alloc] init];
    guestNumbers = [_activity valueForKey:@"guests"];
    attending = [[NSMutableArray alloc] init];
    attending = [_activity valueForKey:@"attending"];
    currentMessagePosition = 5; numberOfMessages = 0;
    [sendButton setTintColor:[References colorFromHexString:@"#F97794"]];
    [References tintUIButton:close color:[UIColor darkGrayColor]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
    activityTitle.text = [_activity valueForKey:@"name"];
    createdBy.text = [_activity valueForKey:@"creator"];
    messages = [_activity valueForKey:@"messages"];
    for (int a = 0; a < messages.count-1; a++) {
        NSArray *messageData = [messages[a] componentsSeparatedByString:@"^*&"];
        MessageObject *message;
        if ([messageData[0] isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"phone"]]) {
            message = [MessageObject MessageWithText:messageData[1] andAmSender:[NSNumber numberWithBool:YES]];
            [self createMessage:YES withText:[message valueForKey:@"text"] inScrollView:chatView :self.view];
        } else {
            message = [MessageObject MessageWithText:messageData[1] andAmSender:[NSNumber numberWithBool:NO]];
            [self createMessage:NO withText:[message valueForKey:@"text"] inScrollView:chatView :self.view];
        }
        
    }
    chatView.contentSize = CGSizeMake([References screenWidth], chatView.contentSize.height+50);
    if (numberOfMessages > 10) {
        CGPoint bottomOffset = CGPointMake(0, chatView.contentSize.height - chatView.bounds.size.height);
        [chatView setContentOffset:bottomOffset animated:YES];
    }
    
    [References createLine:self.view xPos:0 yPos:chatView.frame.origin.y];
    CAGradientLayer *gradient = [References createGradient:[References colorFromHexString:@"#F05F57"] andColor:[References colorFromHexString:@"#360940"]];
    [leaveCard.layer insertSublayer:gradient atIndex:0];
    leaveShadow.backgroundColor = [UIColor whiteColor];
    [References cardshadow:leaveShadow];
    [References cornerRadius:leaveCard radius:8.0f];
    [super viewDidLoad];
    [guestsTable reloadData];
    // Do any additional setup after loading the view.
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)sendMessage:(id)sender {
    NSString *notifMessage = [NSString stringWithFormat:@"#%@ %@: %@", [_activity valueForKey:@"name"],[[NSUserDefaults standardUserDefaults] objectForKey:@"name"], messageField.text];
    NSString *message = [NSString stringWithFormat:@"%@^*&%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"phone"],messageField.text];
    NSURL *url = [NSURL URLWithString:@"http://138.197.217.29:5000/sendMessage"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    // NSError *actualerror = [[NSError alloc] init];
    // Parameters
    NSDictionary *tmp = [[NSDictionary alloc] init];
    tmp = @{
            @"actID"     : [_activity valueForKey:@"actID"],
            @"message"     : message,
            @"notifMessage" : notifMessage,
            @"phone"    : [[NSUserDefaults standardUserDefaults] objectForKey:@"phone"]
            };
    
    NSError *error;
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
    [request setHTTPBody:postdata];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data,
                                               NSError *error) {
                               if (error) {
                                   // Returned Error
                                   NSLog(@"Unknown Error Occured");
                               } else {
                                   NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                   NSArray *activityArray = [responseBody componentsSeparatedByString:@"!@#"];
                                   NSMutableArray *newMessages = [[NSMutableArray alloc] initWithArray:[activityArray[4] componentsSeparatedByString:@"&*^"]];
                                   NSMutableArray *pending = [[NSMutableArray alloc] initWithArray:[activityArray[5] componentsSeparatedByString:@"$#$"]];
                                   NSMutableArray *names = [[NSMutableArray alloc] initWithArray:[activityArray[7] componentsSeparatedByString:@"$#$"]];
                                   NSArray *temp_attending = [activityArray[6] componentsSeparatedByString:@"@~!"];
                                   NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                                   f.numberStyle = NSNumberFormatterDecimalStyle;
                                   ActivityObject *newActivity = [ActivityObject ActivityWithName:activityArray[2] andGuests:pending andMessages:newMessages andAttending:[[NSMutableArray alloc] initWithArray:temp_attending] andID:activityArray[1] andNames:names andCreator:activityArray[8] andTime:[f numberFromString:activityArray[9]]];
                                   _activity = newActivity;
                                   for(UIView *subview in [chatView subviews]) {
                                       [subview removeFromSuperview];
                                   }
                                   numberOfMessages = 0;
                                   currentMessagePosition = 5;
                                   messages = [newActivity valueForKey:@"messages"];
                                   for (int a = 0; a < messages.count-1; a++) {
                                       NSArray *messageData = [messages[a] componentsSeparatedByString:@"^*&"];
                                       MessageObject *message;
                                       if ([messageData[0] isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"phone"]]) {
                                           message = [MessageObject MessageWithText:messageData[1] andAmSender:[NSNumber numberWithBool:YES]];
                                           [self createMessage:YES withText:[message valueForKey:@"text"] inScrollView:chatView :self.view];
                                       } else {
                                           message = [MessageObject MessageWithText:messageData[1] andAmSender:[NSNumber numberWithBool:NO]];
                                           [self createMessage:NO withText:[message valueForKey:@"text"] inScrollView:chatView :self.view];
                                       }
                                   }
                                   chatView.contentSize = CGSizeMake([References screenWidth], chatView.contentSize.height+50);
                                   CGPoint bottomOffset = CGPointMake(0, chatView.contentSize.height - chatView.bounds.size.height);
                                   [chatView setContentOffset:bottomOffset animated:YES];
                                   [messageField setText:@""];
                                   [messageField resignFirstResponder];
                               }
                                    
                           }];
}

- (IBAction)changeSegment:(id)sender {
    NSString *selected = [segmentControl titleForSegmentAtIndex:segmentControl.selectedSegmentIndex];
    if ([selected isEqualToString:@"Messages"]) {
        moreView.hidden = YES;
        chatView.hidden = NO;
        toolBar.hidden = NO;
        guestsTable.hidden = YES;
        [segmentControl setSelectedSegmentIndex:0];
    } else if ([selected isEqualToString:@"Guests"]) {
        chatView.hidden = YES;
        toolBar.hidden = YES;
        guestsTable.hidden = NO;
        moreView.hidden = YES;
        [segmentControl setSelectedSegmentIndex:1];
        //[References toastMessage:@"almost" andView:self];
    } else {
        guestsTable.hidden = YES;
        moreView.hidden = NO;
        chatView.hidden = YES;
        toolBar.hidden = YES;
        [segmentControl setSelectedSegmentIndex:2];
    }
}

- (IBAction)leaveEvent:(id)sender {
    NSURL *url = [NSURL URLWithString:@"http://138.197.217.29:5000/leaveEvent"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    // NSError *actualerror = [[NSError alloc] init];
    // Parameters
    NSDictionary *tmp = [[NSDictionary alloc] init];
    tmp = @{
            @"actID"     : [_activity valueForKey:@"actID"],
            @"phone"     : [[NSUserDefaults standardUserDefaults] objectForKey:@"phone"]
            };
    
    NSError *error;
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
    [request setHTTPBody:postdata];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data,
                                               NSError *error) {
                               if (error) {
                                   // Returned Error
                                   NSLog(@"Unknown Error Occured");
                               } else {
                                   [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"reloadActivities"];
                                   [[NSUserDefaults standardUserDefaults] synchronize];
                                   [self dismissViewControllerAnimated:YES completion:nil];
                               }
                           }];
}

- (void)keyboardWillShow:(NSNotification *)n
{
    NSDictionary* userInfo = [n userInfo];
    
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIViewAnimationOptions curveValue = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue] << 16;
    [UIView animateWithDuration:0.5
                          delay:0
                        options:curveValue
                     animations:^{
                         toolBar.frame = CGRectMake(0, toolBar.frame.origin.y-keyboardSize.height, [References screenWidth], toolBar.frame.size.height);
                         chatView.frame = CGRectMake(0, chatView.frame.origin.y, chatView.frame.size.width, chatView.frame.size.height-keyboardSize.height);
                         CGPoint bottomOffset = CGPointMake(0, chatView.contentSize.height - chatView.bounds.size.height);
                         [chatView setContentOffset:bottomOffset];
                     }
                     completion:nil];
    
}

- (void)keyboardWillHide:(NSNotification *)n
{
    NSDictionary* userInfo = [n userInfo];
    
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIViewAnimationOptions curveValue = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue] << 16;
    [UIView animateWithDuration:0.5
                          delay:0
                        options:curveValue
                     animations:^{
                         toolBar.frame = CGRectMake(0, toolBar.frame.origin.y+keyboardSize.height, [References screenWidth], toolBar.frame.size.height);
                         chatView.frame = CGRectMake(0, chatView.frame.origin.y, chatView.frame.size.width, chatView.frame.size.height+keyboardSize.height);
                     }
                     completion:nil];

}
- (IBAction)textfieldDidEdit:(id)sender {
    if (messageField.text.length > 0) {
        [References fade:sendButton alpha:1.0];
         } else {
             [References fade:sendButton alpha:0.4];
         }
}

-(void)createMessage:(BOOL)amSender withText:(NSString*)message inScrollView:(UIScrollView*)scrollView :(UIView*)parent{
    if (amSender == YES) {
        message = [message stringByAppendingString:@"  "];
    }
    int messageLength = (int)message.length;
    int bubbleWidth = 20;
    for (int a = 0; a < messageLength; a++) {
        bubbleWidth+=10;
    }
    bubbleWidth = bubbleWidth - (bubbleWidth*.25);
    if (bubbleWidth > scrollView.frame.size.width*0.8) {
        bubbleWidth = scrollView.frame.size.width*0.8;
    }
    int messageDivisor = messageLength/36;
    int numberofLines = messageDivisor+1;
    int bubbleHeight = 30;
    if (numberofLines > 1) {
        bubbleHeight = bubbleHeight + (numberofLines*8);
    }
    int xPosition;
    
    UIColor *bubbleColor,*textColor;
    if (amSender == YES) {
        xPosition = scrollView.frame.size.width - bubbleWidth - 8;
        bubbleColor = [References colorFromHexString:@"#F97794"];
        textColor = [UIColor whiteColor];
    } else {
        xPosition = 8;
        bubbleColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
        textColor = [UIColor darkTextColor];
    }
    UILabel *messageBubble = [[UILabel alloc] initWithFrame:CGRectMake(xPosition, currentMessagePosition, bubbleWidth, bubbleHeight)];
    [messageBubble setBackgroundColor:bubbleColor];
    [References cornerRadius:messageBubble radius:10.0f];
    [messageBubble setFont:[UIFont boldSystemFontOfSize:[UIFont systemFontSize]]];
    [messageBubble setTextColor:textColor];
    messageBubble.alpha = 1;
    NSMutableParagraphStyle *style =  [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    if (amSender == YES) {
        style.alignment = NSTextAlignmentRight;
    } else {
        style.alignment = NSTextAlignmentLeft;
    }
    
    style.firstLineHeadIndent = 10.0f;
    style.headIndent = 10.0f;
    style.tailIndent = -10.0f;
    
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:message attributes:@{ NSParagraphStyleAttributeName : style}];
    messageBubble.numberOfLines = numberofLines;
    messageBubble.attributedText = attrText;
    [scrollView addSubview:messageBubble];
    //[parent bringSubviewToFront:scrollView];
    currentMessagePosition = currentMessagePosition + 5 + messageBubble.frame.size.height;
    numberOfMessages++;
    if (scrollView.contentSize.height < currentMessagePosition) {
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, scrollView.contentSize.height+bubbleHeight+5);
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *simpleTableIdentifier = @"guestCell";
    guestCell *cell = (guestCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    if ([attending[indexPath.row] isEqualToString:@"Y"]) {
        cell.isGoing.text = @"IS GOING";
    } else {
        cell.isGoing.text = @"HASN'T RESPONDED";
    }
    cell.name.text = guestNames[indexPath.row];
    cell.phoneNumber = guestNumbers[indexPath.row];
    //[References tintUIButton:cell.addFriend color:[References colorFromHexString:@"#F97794"]];
    cell.addFriend.hidden = YES;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [cell addGestureRecognizer:longPress];
    return cell;
}

- (void)handleTapGesture:(UITapGestureRecognizer *)tapGesture {
    if (alertIsShowing == NO) {
        guestCell *cell = (guestCell*)tapGesture.view;
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:cell.name.text message:@"interact with them from here" preferredStyle:UIAlertControllerStyleActionSheet];
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            alertIsShowing = NO;
            [actionSheet dismissViewControllerAnimated:YES completion:^{
                
            }];
        }]];
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:[NSString stringWithFormat:@"Tell %@ To Come",cell.name.text] style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            alertIsShowing = NO;
            // coming soon
        }]];
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:[NSString stringWithFormat:@"Add %@ As A Friend",cell.name.text] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            // OK button tapped.
            alertIsShowing = NO;
            // coming soon
        }]];
        // Present action sheet.
        [self presentViewController:actionSheet animated:YES completion:nil];
        alertIsShowing = YES;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 42;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return guestNumbers.count-1;
}


@end
