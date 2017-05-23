//
//  PostView.h
//  are you down
//
//  Created by Robert Crosby on 5/18/17.
//  Copyright © 2017 Robert Crosby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "References.h"
#import "UIColor+BFPaperColors.h"
#import "PostGroupsCollectionCell.h"
#import "PostFriendsTableCell.h"
#import "friendObject.h"
#import "groupObject.h"

@interface PostView : UIViewController <UITextFieldDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource> {
    NSString *groupSelected;
    __weak IBOutlet UIImageView *backgroundImage;
    // create post view
    __weak IBOutlet UIScrollView *createPostScroll;
    // create post subviews
    __weak IBOutlet UILabel *createPostInfo;
    __weak IBOutlet UITextField *createPostText;
    __weak IBOutlet UILabel *createPostCard;
    bool keepScrollingCreatePost;
    // timer to animate text field
    NSTimer *createPostTextTimer;
    // animate text
    bool animateText;
    // create invite friends view
    __weak IBOutlet UIScrollView *inviteFriendsScroll;
    // invite friends sbuviews
    __weak IBOutlet UILabel *inviteFriendsActivity;
    __weak IBOutlet UILabel *inviteFriendsTitleCard;
    __weak IBOutlet UITableView *inviteFriendsTable;
    //arrays to hold friends and selections
    NSMutableArray *friends,*groups,*friendNames;
    bool keepScrollingInvite;
    
    // create send view
    __weak IBOutlet UIScrollView *sendActivityScroll;
    // send subviews
    
    
    
}




@end
