//
//  StartView.h
//  are you down
//
//  Created by Robert Crosby on 5/30/17.
//  Copyright © 2017 Robert Crosby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Contacts/Contacts.h>
#import "References.h"
#import "UIColor+BFPaperColors.h"
#import "PostView.h"

@interface StartView : UIViewController <UITextFieldDelegate> {
    bool doSignIn;
    NSString *activationCode;
    NSMutableArray *contacts;
    NSMutableArray *contactNames;
    NSMutableArray *contactPhoneNumbers;
    __weak IBOutlet UITextField *phoneNumber;
    
    __weak IBOutlet UILabel *phoneNumberLabel;
    __weak IBOutlet UITextField *commonName;
    
    __weak IBOutlet UILabel *commonNameLabel;
    __weak IBOutlet UIButton *allowContacts;
    
    __weak IBOutlet UILabel *allowContactsLabel;
    __weak IBOutlet UIButton *signInButton;
    __weak IBOutlet UILabel *signInLabel;
    __weak IBOutlet UIButton *signupButton;
    __weak IBOutlet UILabel *card;
    __weak IBOutlet UIScrollView *signUpScroll;
    __weak IBOutlet UILabel *howToSignIn;
    
    // verification part
    __weak IBOutlet UIScrollView *verificationScroll;
    __weak IBOutlet UIButton *verifyButton;
    __weak IBOutlet UILabel *verificationcard;
    __weak IBOutlet UITextField *verificationField;
    __weak IBOutlet UILabel *codeTemp;

    
    
}
- (IBAction)allowContacts:(id)sender;
- (IBAction)signupButton:(id)sender;
- (IBAction)verifyCode:(id)sender;
- (IBAction)signInButton:(id)sender;

@end
