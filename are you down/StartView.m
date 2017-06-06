//
//  StartView.m
//  are you down
//
//  Created by Robert Crosby on 5/30/17.
//  Copyright © 2017 Robert Crosby. All rights reserved.
//

#import "StartView.h"

@interface StartView ()

@end

@implementation StartView

- (void)viewDidLoad {
    doSignIn = false;
    [References cornerRadius:card radius:10.0f];
    [References cornerRadius:signupButton radius:10.0f];
    [References cornerRadius:verificationcard radius:10.0f];
    [verificationField addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
    [super viewDidLoad];
    contactNames = [[NSMutableArray alloc] init];
    contactPhoneNumbers = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view.
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidChange:(id)sender {
    if ([activationCode isEqualToString:verificationField.text]) {
       // [References toastMessage:@"it works!" andView:self];
        PostView *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PostView"];
        [self presentViewController:viewController animated:YES completion:nil];
    }
}

-(void)signup{
    activationCode = [References randomIntWithLength:4];
    NSLog(@"%@",activationCode);
    NSURL *url = [NSURL URLWithString:@"http://138.197.217.29:5000/signUp"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    // NSError *actualerror = [[NSError alloc] init];
    // Parameters
    NSDictionary *tmp = [[NSDictionary alloc] init];
    tmp = @{
            @"friendNames"     : contactNames,
            @"friendNumbers"     : contactPhoneNumbers,
            @"name"       : commonName.text,
            @"token"    : [[NSUserDefaults standardUserDefaults] objectForKey:@"token"],
            @"phone"         : phoneNumber.text,
            @"activationCode"   : activationCode
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
                                   [[NSUserDefaults standardUserDefaults] setObject:commonName.text forKey:@"name"];
                                   [[NSUserDefaults standardUserDefaults] setObject:phoneNumber.text forKey:@"phone"];
                                   //NSMutableDictionary *activity = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
                                   [References moveUp:signUpScroll yChange:[References screenHeight]];
                                   [References moveUp:verificationScroll yChange:[References screenHeight]];
                                   codeTemp.text = activationCode;
                                   //[References toastMessage:[NSString stringWithFormat:@"your code is: %@",activationCode] andView:self];
                               }
                           }];
    
}

-(void)signin{
    activationCode = [References randomIntWithLength:4];
    NSURL *url = [NSURL URLWithString:@"http://138.197.217.29:5000/signIn"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    // NSError *actualerror = [[NSError alloc] init];
    // Parameters
    NSDictionary *tmp = [[NSDictionary alloc] init];
    tmp = @{
            @"phone"         : phoneNumber.text,
            @"token"    : [[NSUserDefaults standardUserDefaults] objectForKey:@"token"],
            @"activationCode"   : activationCode
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
                                   //NSMutableDictionary *activity = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
                                   NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                   if ([responseBody containsString:@"sorry"]) {
                                       [References toastMessage:responseBody andView:self];
                                   } else {
                                       [[NSUserDefaults standardUserDefaults] setObject:responseBody forKey:@"name"];
                                       [[NSUserDefaults standardUserDefaults] setObject:phoneNumber.text forKey:@"phone"];
                                       doSignIn =true;
                                       [References moveUp:signUpScroll yChange:[References screenHeight]];
                                       [References moveUp:verificationScroll yChange:[References screenHeight]];
                                       codeTemp.text = activationCode;
                                   }
                                
                                   //[References toastMessage:[NSString stringWithFormat:@"your code is: %@",activationCode] andView:self];
                               }
                           }];
    
}

- (IBAction)allowContacts:(id)sender {
    [self getAllContacts];
    if (contactNames.count > 0) {
        [References fadeButtonText:allowContacts text:@"you're all set!"];
        [allowContacts setEnabled:NO];
        [References fadeButtonTextColor:allowContacts color:[UIColor paperColorTeal]];
    } else {
         [References fadeButtonTextColor:allowContacts color:[UIColor paperColorRedA400]];
        
    }
}

- (IBAction)signupButton:(id)sender {
    if ([signupButton.titleLabel.text isEqualToString:@"Sign Up"]) {
        if ((phoneNumber.text.length < 10) && (commonName.text.length < 1)) {
            [References toastMessage:@"make sure you entered your information correctly" andView:self];
        }
        else if ((phoneNumber.text.length < 10) || ([phoneNumber.text containsString:@"-"]) || ([phoneNumber.text containsString:@"("]) || ([phoneNumber.text containsString:@")"]) || ([phoneNumber.text containsString:@"+"])) {
            [References toastMessage:@"something isn't right with your phone number. enter it without any special characters or spaces; just numbers" andView:self];
        }
        else if (commonName.text.length < 1) {
            [References toastMessage:@"something isn't right with your name" andView:self];
        } else {
            [self signup];
        }
    } else {
        [self signin];
    }

}

- (IBAction)verifyCode:(id)sender {
    
}

- (void)getAllContacts {
    [contactPhoneNumbers removeAllObjects];
    [contactNames removeAllObjects];
    CNContactStore *addressBook = [[CNContactStore alloc] init];
    NSArray *keysToFetch = @[CNContactGivenNameKey,CNContactFamilyNameKey,CNContactPhoneNumbersKey];
    CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetch];
    [addressBook enumerateContactsWithFetchRequest:fetchRequest
                                             error:nil
                                        usingBlock:^(CNContact* __nonnull contact, bool * __nonnull stop){
                                            NSArray *digits = [[contact.phoneNumbers valueForKey:@"value"] valueForKey:@"digits"];
                                            NSString *name = [NSString stringWithFormat:@"%@ %@",contact.givenName,contact.familyName];
                                            if ((digits.count != 0) && (name.length > 1)) {
                                                [contactPhoneNumbers addObject:digits[0]];
                                                [contactNames addObject:name];
                                            }
                                        }];
}
- (IBAction)signInButton:(id)sender {
    if ([signInButton.titleLabel.text isEqualToString:@"Sign In"]) {
        commonName.hidden = YES;
        commonNameLabel.hidden = YES;
        allowContacts.hidden = YES;
        allowContactsLabel.hidden = YES;
        [References fadeIn:howToSignIn];
        //[References fadeOut:commonNameLabel];
        //[References fadeOut:commonName];
        //[References fadeOut:allowContactsLabel];
        //[References fadeOut:allowContacts];
        [References moveDown:phoneNumberLabel yChange:40];
        [References moveDown:phoneNumber yChange:40];
        [References moveDown:howToSignIn yChange:40];
        [References fadeLabelText:signInLabel newText:@"if it's your first time"];
        [References fadeButtonText:signupButton text:@"Sign In"];
        [References fadeButtonText:signInButton text:@"Sign Up"];
    } else {
        howToSignIn.hidden = YES;
        [References fadeIn:commonNameLabel];
        [References fadeIn:commonName];
        [References fadeIn:allowContactsLabel];
        [References fadeIn:allowContacts];
        [References fadeLabelText:signInLabel newText:@"if you've already been here"];
        [References fadeButtonText:signupButton text:@"Sign Up"];
        [References fadeButtonText:signInButton text:@"Sign In"];
        [References moveUp:phoneNumberLabel yChange:40];
        [References moveUp:phoneNumber yChange:40];
        [References moveUp:howToSignIn yChange:40];
    }
    
}
@end
