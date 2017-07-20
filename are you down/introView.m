//
//  introView.m
//  are you down
//
//  Created by Robert Crosby on 6/19/17.
//  Copyright © 2017 Robert Crosby. All rights reserved.
//

#import "introView.h"
#import "References.h"

@interface introView () {
	NSString *nameForLater,*phoneForLater;
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UITextField *phoneNumber;
    __weak IBOutlet UILabel *phoneNumberInfo;
    __weak IBOutlet UITextField *commonName;
    __weak IBOutlet UISwitch *enableContacts;
    __weak IBOutlet UILabel *findFriends;
    __weak IBOutlet UILabel *findFriendInfo;
    __weak IBOutlet UIButton *continueButton;
    __weak IBOutlet UIScrollView *superScrollView;
    __weak IBOutlet UILabel *statusBar;
    UILabel *blurLabel;
    UIView *bgVideo;
    UIView *lineA,*lineB;
    BOOL statusBarBlur;
    BOOL statusBarHidden;
    __weak IBOutlet UIButton *bottomButton;
    __weak IBOutlet UIButton *topButton;
    __weak IBOutlet UILabel *bottomButtonInfo;
    __weak IBOutlet UILabel *commonNameInfo;
	bool doingActivation;
	NSString *activationCode;
	NSString *notificationToken;
	NSMutableArray *contacts;
	NSMutableArray *contactNames;
	NSMutableArray *contactPhoneNumbers;
    __weak IBOutlet UILabel *logo;
}

- (IBAction)enableContacts:(id)sender;
- (IBAction)bottomButton:(id)sender;
- (IBAction)topButton:(id)sender;
- (IBAction)activationCodeChanged:(id)sender;

@end

@implementation introView

-(void)viewWillAppear:(BOOL)animated {
	if ([References screenHeight] > 568) {
		commonName.frame = CGRectMake(commonName.frame.origin.x, commonName.frame.origin.y, [References screenWidth]-16, commonName.frame.size.height);
		phoneNumber.frame = CGRectMake(phoneNumber.frame.origin.x, phoneNumber.frame.origin.y, [References screenWidth]-16, phoneNumber.frame.size.height);
		superScrollView.frame = CGRectMake(0, 0, [References screenWidth], [References screenHeight]);
		topButton.frame = CGRectMake(0, topButton.frame.origin.y, [References screenWidth], topButton.frame.size.height);
		bottomButton.frame = CGRectMake(0, bottomButton.frame.origin.y+80, [References screenWidth], bottomButton.frame.size.height);
		bottomButtonInfo.frame = CGRectMake(0, bottomButtonInfo.frame.origin.y+80, [References screenWidth], bottomButtonInfo.frame.size.height);
		enableContacts.frame = CGRectMake(enableContacts.frame.origin.x+60, enableContacts.frame.origin.y, enableContacts.frame.size.width, enableContacts.frame.size.height);
		phoneNumberInfo.frame = CGRectMake(phoneNumberInfo.frame.origin.x, phoneNumberInfo.frame.origin.y, commonName.frame.size.width, phoneNumberInfo.frame.size.height);
		findFriendInfo.frame = CGRectMake(findFriendInfo.frame.origin.x, findFriendInfo.frame.origin.y, commonName.frame.size.width, findFriendInfo.frame.size.height);
		if ([References screenHeight] > 667) {
			bottomButton.frame = CGRectMake(0, bottomButton.frame.origin.y+30, [References screenWidth], bottomButton.frame.size.height);
			bottomButtonInfo.frame = CGRectMake(0, bottomButtonInfo.frame.origin.y+30, [References screenWidth], bottomButtonInfo.frame.size.height);
		}
	}
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isSignOut"] == YES) {
		self.view.backgroundColor = [UIColor blackColor];
		[self loadBlur];
		[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isSignOut"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	} else {
		self.view.backgroundColor = [UIColor blackColor];
		superScrollView.alpha = 0;
		[NSTimer scheduledTimerWithTimeInterval:5.0
										 target:self
									   selector:@selector(loadBlur)
									   userInfo:nil
										repeats:NO];
	}
	
	
}

- (void)viewDidLoad {
	[References blurView:logo];
	[phoneNumber addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
	doingActivation = NO;
	contactNames = [[NSMutableArray alloc] init];
	contactPhoneNumbers = [[NSMutableArray alloc] init];
    statusBarHidden = YES;
    statusBarBlur = NO;
    [References blurView:statusBar];
    [References createLine:superScrollView xPos:titleLabel.frame.origin.x yPos:titleLabel.frame.origin.y+titleLabel.frame.size.height + 4];
    //[References ViewToLine:superScrollView withView:lineA xPos:8 yPos:findFriends.frame.origin.y-4];
    //[References ViewToLine:superScrollView withView:lineB xPos:8 yPos:findFriendInfo.frame.origin.y+findFriendInfo.frame.size.height + 8];
    [References textFieldInset:phoneNumber];
    [References textFieldInset:commonName];
    [References cornerRadius:phoneNumber radius:8.0f];
    [References cornerRadius:commonName radius:8.0f];
    [References cornerRadius:continueButton radius:16.0f];
    [super viewDidLoad];
    NSError *sessionError = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:&sessionError];
    [[AVAudioSession sharedInstance] setActive:YES error:&sessionError];
    bgVideo = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [References screenWidth], [References screenHeight])];
    blurLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [References screenWidth], [References screenHeight])];
    [References blurView:blurLabel];
    blurLabel.alpha = 0;
    [self.view addSubview:blurLabel];
    [self.view sendSubviewToBack:blurLabel];
    NSURL *movieURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"birds" ofType:@"mp4"]];
    AVAsset *avAsset = [AVAsset assetWithURL:movieURL];
    AVPlayerItem *avPlayerItem =[[AVPlayerItem alloc]initWithAsset:avAsset];
    _avPlayer = [[AVPlayer alloc]initWithPlayerItem:avPlayerItem];
    AVPlayerLayer *avPlayerLayer =[AVPlayerLayer playerLayerWithPlayer:_avPlayer];
    [avPlayerLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [avPlayerLayer setFrame:[[UIScreen mainScreen] bounds]];
    [bgVideo.layer addSublayer:avPlayerLayer];
    [self.view addSubview:bgVideo];
    [self.view sendSubviewToBack:bgVideo];
    //Config player
    [_avPlayer seekToTime:kCMTimeZero];
    [_avPlayer setVolume:0.0f];
    [_avPlayer setActionAtItemEnd:AVPlayerActionAtItemEndNone];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[_avPlayer currentItem]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerStartPlaying)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
    // Do any additional setup after loading the view.
}

-(BOOL)prefersStatusBarHidden {
    return statusBarHidden;
}

-(void)loadBlur{
	[_avPlayer pause];
	[References fadeOut:logo];
    [References fadeIn:blurLabel];
    [References fadeIn:superScrollView];
    statusBarHidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        [self setNeedsStatusBarAppearanceUpdate];
    }];
}

-(UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationFade;
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
}

- (void)playerStartPlaying
{
    [_avPlayer play];
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
//
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (scrollView.contentOffset.y > 0) {
//        if (statusBarBlur == NO) {
//            statusBarBlur = YES;
//            [References fadeIn:statusBar];
//        }
//    } else if (scrollView.contentOffset.y <= 0) {
//        if (statusBarBlur == YES) {
//            statusBarBlur = NO;
//            [References fadeOut:statusBar];
//        }
//    }
//}

- (IBAction)enableContacts:(id)sender {
}

- (IBAction)bottomButton:(id)sender {
    if ([topButton.titleLabel.text isEqualToString:@"Sign Up"]) {
        [UIView animateWithDuration:0.5 animations:^{
            commonName.alpha = 0;
            commonNameInfo.alpha = 0;
            findFriendInfo.alpha = 0;
            findFriends.alpha = 0;
            enableContacts.alpha = 0;
            [topButton setTitle:@"Sign In" forState:UIControlStateNormal];
            [bottomButton setTitle:@"Sign Up" forState:UIControlStateNormal];
            bottomButtonInfo.text = @"if it's your first time";
        }];
        [References fadeLabelText:titleLabel newText:@"Welcome Back"];
        [References moveUp:topButton yChange:160];
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            commonName.alpha = 1;
            commonNameInfo.alpha = 1;
            findFriendInfo.alpha = 1;
            findFriends.alpha = 1;
            enableContacts.alpha = 1;
            titleLabel.text = @"Get Started";
            [topButton setTitle:@"Sign Up" forState:UIControlStateNormal];
            [bottomButton setTitle:@"Sign In" forState:UIControlStateNormal];
            bottomButtonInfo.text = @"if you've been here before";
        }];
        [References fadeLabelText:titleLabel newText:@"Get Started"];
        [References moveDown:topButton yChange:160];    }
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)topButton:(id)sender {
	if (titleLabel.text.length < 5) {
		[phoneNumber setPlaceholder:@"Phone Number"];
		[commonName setText:@""];
		[phoneNumber setText:@""];
		[UIView animateWithDuration:0.5 animations:^{
			commonName.alpha = 1;
			commonNameInfo.alpha = 1;
			findFriendInfo.alpha = 1;
			findFriends.alpha = 1;
			enableContacts.alpha = 1;
			titleLabel.text = @"Get Started";
			[topButton setTitle:@"Sign Up" forState:UIControlStateNormal];
			[bottomButton setTitle:@"Sign In" forState:UIControlStateNormal];
			bottomButtonInfo.text = @"if you've been here before";
		}];
		[References fadeLabelText:titleLabel newText:@"Get Started"];
		[References moveDown:topButton yChange:160];
		[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"phone"];
		[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"name"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	} else {
//	if (enableContacts.on) {
//		[contactPhoneNumbers removeAllObjects];
//		[contactNames removeAllObjects];
//		CNContactStore *addressBook = [[CNContactStore alloc] init];
//		NSArray *keysToFetch = @[CNContactGivenNameKey,CNContactFamilyNameKey,CNContactPhoneNumbersKey];
//		CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetch];
//		[addressBook enumerateContactsWithFetchRequest:fetchRequest
//												 error:nil
//											usingBlock:^(CNContact* __nonnull contact, bool * __nonnull stop){
//												NSArray *digits = [[contact.phoneNumbers valueForKey:@"value"] valueForKey:@"digits"];
//												NSString *name = [NSString stringWithFormat:@"%@ %@",contact.givenName,contact.familyName];
//												if ((digits.count != 0) && (name.length > 1)) {
//													[contactPhoneNumbers addObject:digits[0]];
//													[contactNames addObject:name];
//												}
//											}];
	}
    if ([topButton.titleLabel.text isEqualToString:@"Sign Up"]) {
		if ([phoneNumber.text isEqualToString:@"0000000000"]) {
			[References toastMessage:@"Please enter a valid phone number" andView:self];
		} else if ((phoneNumber.text.length < 10) || (phoneNumber.text.length > 10) || (commonName.text.length < 1)) {
			[References toastMessage:@"Use a 10-digit phone number or check your name is filled in" andView:self];
		} else {
		activationCode = [References randomIntWithLength:4];
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
									   NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
									   if ([responseBody isEqualToString:@"Error"]) {
										   [References toastMessage:@"That phone number is already registered, try signing in" andView:self];
									   } else {
										   [topButton setTitle:@"Go Back" forState:UIControlStateNormal];
										   doingActivation = YES;
										   commonName.alpha = 0;
										   commonNameInfo.alpha = 0;
										   findFriendInfo.alpha = 0;
										   findFriends.alpha = 0;
										   enableContacts.alpha = 0;
										   nameForLater = commonName.text;
										   phoneForLater = phoneNumber.text;
										   [phoneNumber setText:@""];
										   [References fadeLabelText:phoneNumberInfo newText:@"we're texting you an activation code to make sure you're a person."];
										   [phoneNumber setPlaceholder:@"Activation Code"];
										   [phoneNumber becomeFirstResponder];
									   }
								   }
							   }];
		}
    } else {
		if ((phoneNumber.text.length < 10) || (phoneNumber.text.length > 10)) {
			[References toastMessage:@"Use a 10-digit phone number or check your name is filled in" andView:self];
		} else {
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
									   if ([responseBody isEqualToString:@"Error"]) {
										   [References toastMessage:@"That phone number is already registered, try signing in" andView:self];
									   } else {
										   if ([phoneNumber.text isEqualToString:@"0000000000"]) {
											   [References fadeLabelText:titleLabel newText:activationCode];
										   }
										    [topButton setTitle:@"Go Back" forState:UIControlStateNormal];
										   doingActivation = YES;
										   commonName.alpha = 0;
										   commonNameInfo.alpha = 0;
										   findFriendInfo.alpha = 0;
										   findFriends.alpha = 0;
										   enableContacts.alpha = 0;
										   nameForLater = responseBody;
										   phoneForLater = phoneNumber.text;
										   [phoneNumber setText:@""];
										  
										   [References fadeLabelText:phoneNumberInfo newText:@"we're texting you an activation code to make sure you're a person."];
										   [phoneNumber setPlaceholder:@"Activation Code"];
										   [phoneNumber becomeFirstResponder];
										}
									   
									   //[References toastMessage:[NSString stringWithFormat:@"your code is: %@",activationCode] andView:self];
								   }
							   }];
		}
    }
}
-(void)textChanged:(UITextField *)textField
{
	if (doingActivation == YES) {
		if ([phoneNumber.text isEqualToString:activationCode]) {
			
			[[NSUserDefaults standardUserDefaults] setObject:nameForLater forKey:@"name"];
			[[NSUserDefaults standardUserDefaults] setObject:phoneForLater forKey:@"phone"];
			[[NSUserDefaults standardUserDefaults] synchronize];
			// [References toastMessage:@"it works!" andView:self];
			NSString *storyboardString = @"iPhone4";
			homeView *viewController = [[UIStoryboard storyboardWithName:storyboardString bundle:nil] instantiateViewControllerWithIdentifier:@"homeView"];
			[self presentViewController:viewController animated:YES completion:nil];
		}
	}
}

- (IBAction)activationCodeChanged:(id)sender {
	
}
@end
