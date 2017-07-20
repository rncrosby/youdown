//
//  infoView.h
//  are you down
//
//  Created by Robert Crosby on 6/12/17.
//  Copyright © 2017 Robert Crosby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityObject.h"
#import "MessageObject.h"
#import "guestCell.h"

@interface infoView : UIViewController <UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource> {
    NSMutableArray *messages;
    int currentMessagePosition,numberOfMessages;
    NSMutableArray *guestNumbers,*guestNames,*attending;
}

- (IBAction)textfieldDidEdit:(id)sender;
@property (nonatomic) ActivityObject *activity;

@end
