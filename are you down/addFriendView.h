//
//  addFriendView.h
//  are you down
//
//  Created by Robert Crosby on 6/21/17.
//  Copyright © 2017 Robert Crosby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "References.h"


@interface addFriendView : UIViewController <AVCaptureMetadataOutputObjectsDelegate,UIScrollViewDelegate,UIAlertViewDelegate> {
    AVCaptureSession *_session;
    AVCaptureDevice *_device;
    AVCaptureDeviceInput *_input;
    AVCaptureMetadataOutput *_output;
    AVCaptureVideoPreviewLayer *_prevLayer;
    UIView *_highlightView;
    bool stopReloading;
    __weak IBOutlet UIScrollView *superScrollView;
    __weak IBOutlet UILabel *keepLooking;
    __weak IBOutlet UILabel *confirmFriend;
    double lastAlpha;
    int lastOffest;
    __weak IBOutlet UIImageView *keepLookingImage;
    __weak IBOutlet UIImageView *confirmFriendImage;
    __weak IBOutlet UILabel *resultText;
    __weak IBOutlet UILabel *titleBlur;
    __weak IBOutlet UIButton *closeButton;
    __weak IBOutlet UIImageView *myQRCode;
}

- (IBAction)close:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *titleLabel;
@property (weak, nonatomic) NSNumber *justAddFriend;

@end
