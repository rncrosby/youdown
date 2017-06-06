//
//  UpcomingTableCell.h
//  are you down
//
//  Created by Robert Crosby on 5/25/17.
//  Copyright © 2017 Robert Crosby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "References.h"
#import "ActivityObject.h"

@interface UpcomingTableCell : UITableViewCell <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource> {
    int currentMessagePosition, numberOfMessages;
    bool respond;
    NSMutableArray *messages;
    CGRect keyboardHeight;
}

@property (nonatomic) ActivityObject *activity;
@property (weak, nonatomic) IBOutlet UIScrollView *chatView;

@property (nonatomic) NSMutableArray *invited;
@property (nonatomic)  NSMutableArray *chat;
@property (weak, nonatomic) IBOutlet UILabel *card;
@property (weak, nonatomic) IBOutlet UILabel *activityName;
@property (weak, nonatomic) IBOutlet UILabel *guestListLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *moreScroll;
@property (weak, nonatomic) IBOutlet UITableView *guestTable;
- (IBAction)goToChat:(id)sender;
- (IBAction)goToPeople:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *more;


@end
