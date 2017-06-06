//
//  UpcomingTableCell.m
//  are you down
//
//  Created by Robert Crosby on 5/25/17.
//  Copyright © 2017 Robert Crosby. All rights reserved.
//

#import "UpcomingTableCell.h"

@implementation UpcomingTableCell
@synthesize activity;

- (void)awakeFromNib {
    _moreScroll.contentSize =CGSizeMake(self.frame.size.width*2, _moreScroll.frame.size.height);
    [super awakeFromNib];
    // Initialization code
}

-(void)keyboardOnScreen:(NSNotification *)notification
{
    NSDictionary *info  = notification.userInfo;
    NSValue      *value = info[UIKeyboardFrameEndUserInfoKey];
    
    CGRect rawFrame      = [value CGRectValue];
    keyboardHeight = [self.superview convertRect:rawFrame fromView:nil];
    [References shift:_chatView X:_chatView.frame.origin.x Y:_chatView.frame.origin.y W:_chatView.frame.size.width H:_chatView.frame.size.height-keyboardHeight.size.height];
}

-(void)createMessage:(BOOL)amSender withText:(NSString*)message{
    if (amSender == YES) {
        message = [message stringByAppendingString:@"  "];
    }
    int messageLength = (int)message.length;
    int bubbleWidth = 20;
    for (int a = 0; a < messageLength; a++) {
        bubbleWidth+=10;
    }
    bubbleWidth = bubbleWidth - (bubbleWidth*.25);
    if (bubbleWidth > _chatView.frame.size.width*0.8) {
        bubbleWidth = _chatView.frame.size.width*0.8;
    }
    int messageDivisor = messageLength/36;
    int numberofLines = messageDivisor+1;
    int bubbleHeight = 30;
    if (numberofLines > 1) {
        bubbleHeight = bubbleHeight + (numberofLines*8);
        NSLog(@"%i",bubbleHeight);
    }
    int xPosition;
    UIColor *bubbleColor,*textColor;
    if (amSender == YES) {
        xPosition = _chatView.frame.size.width - bubbleWidth - 8;
        bubbleColor = [UIColor whiteColor];
        textColor = [UIColor blackColor];
        respond = YES;
    } else {
        xPosition = 8;
        bubbleColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
        textColor = [UIColor whiteColor];
    }
    UILabel *messageBubble = [[UILabel alloc] initWithFrame:CGRectMake(xPosition, currentMessagePosition, bubbleWidth, bubbleHeight)];
    [messageBubble setBackgroundColor:bubbleColor];
    [References cornerRadius:messageBubble radius:5.0f];
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
    [_chatView addSubview:messageBubble];
    [self bringSubviewToFront:_chatView];
    currentMessagePosition = currentMessagePosition + 5 + messageBubble.frame.size.height;
    numberOfMessages++;
    if (_chatView.contentSize.height < currentMessagePosition) {
        _chatView.contentSize = CGSizeMake(_chatView.frame.size.width, _chatView.contentSize.height+bubbleHeight+5);
    }
    
    if (respond ==YES) {
        respond = NO;
        
        [self createMessage:NO withText:[self messageResponder:message]];
    }
}

-(bool) textFieldShouldReturn:(UITextField *)textField {
    [self createMessage:YES withText:textField.text];
    [References shift:_chatView X:_chatView.frame.origin.x Y:_chatView.frame.origin.y W:_chatView.frame.size.width H:_chatView.frame.size.height+keyboardHeight.size.height];
    [textField resignFirstResponder];
    return YES;
}

-(NSString*)messageResponder:(NSString*)message{
    NSString *response;
    if ([message containsString:@"hey"]) {
        response = @"Hi";
    } else if ([message containsString:@"i love you"]) {
        response = @"i love you too";
    } else {
        response = @"i didnt quite get that";
    }
    return response;
}
- (IBAction)goToChat:(id)sender {
    [_moreScroll setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (IBAction)goToPeople:(id)sender {
    [_moreScroll setContentOffset:CGPointMake(self.frame.size.width, 0) animated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *guests = [activity valueForKey:@"guestNames"];
    return 2;
 
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    cell.textLabel.text = @"rob";
    cell.detailTextLabel.text = @"5105416477";
    return cell;
    
}
@end
