//
//  addFriendView.m
//  are you down
//
//  Created by Robert Crosby on 6/21/17.
//  Copyright © 2017 Robert Crosby. All rights reserved.
//

#import "addFriendView.h"

@interface addFriendView () {
    NSString *usernameScanned,*phoneScanned;
    bool addFriend;
    __weak IBOutlet UILabel *blurView;
    __weak IBOutlet UILabel *goingBack;
    __weak IBOutlet UISegmentedControl *segmentControl;
}

- (IBAction)segmentControl:(id)sender;
- (IBAction)addByUsername:(id)sender;


@end

@implementation addFriendView

-(void)viewWillAppear:(BOOL)animated {
    if ([References screenHeight] > 568) {
        blurView.frame = CGRectMake(blurView.frame.origin.x, blurView.frame.origin.y, [References screenWidth], [References screenHeight] - blurView.frame.origin.y);
        titleBlur.frame = CGRectMake(titleBlur.frame.origin.x, titleBlur.frame.origin.y, [References screenWidth], titleBlur.frame.size.height);
        closeButton.frame = CGRectMake(closeButton.frame.origin.x+50, closeButton.frame.origin.y, closeButton.frame.size.width, closeButton.frame.size.height);
        segmentControl.frame = CGRectMake(segmentControl.frame.origin.x, segmentControl.frame.origin.y, [References screenWidth] - 16, segmentControl.frame.size.height);
        keepLooking.frame = CGRectMake(([References screenWidth]/2) - (keepLooking.frame.size.width/2), keepLooking.frame.origin.y, keepLooking.frame.size.width, keepLooking.frame.size.height);
        keepLookingImage.frame = CGRectMake(([References screenWidth]/2) - (keepLookingImage.frame.size.width/2), keepLookingImage.frame.origin.y, keepLookingImage.frame.size.width, keepLookingImage.frame.size.height);
        confirmFriend.frame = CGRectMake(([References screenWidth]/2) - (confirmFriend.frame.size.width/2), confirmFriend.frame.origin.y, confirmFriend.frame.size.width, confirmFriend.frame.size.height);
        confirmFriendImage.frame = CGRectMake(([References screenWidth]/2) - (confirmFriendImage.frame.size.width/2), confirmFriendImage.frame.origin.y, confirmFriendImage.frame.size.width, confirmFriendImage.frame.size.height);
    }
    addFriend = NO;
    [References createLine:titleBlur xPos:0 yPos:titleBlur.frame.origin.y+titleBlur.frame.size.height-1];
    [References blurView:blurView];
     [References blurView:titleBlur];
    blurView.alpha = 0;
    [References tintUIButton:closeButton color:[UIColor darkGrayColor]];
}

- (void)viewDidLoad {
    UIImage *image= [self imageWithImage:[UIImage imageNamed:@"up.png"] scaledToSize:CGSizeMake(25, 25)];
    keepLookingImage.contentMode = UIViewContentModeCenter;
    [keepLookingImage setImage:image];
    UIImage *image2= [self imageWithImage:[UIImage imageNamed:@"down.png"] scaledToSize:CGSizeMake(25, 25)];
    confirmFriendImage.contentMode = UIViewContentModeCenter;
    [confirmFriendImage setImage:image2];
    [References cornerRadius:keepLookingImage radius:keepLookingImage.frame.size.height/2];
    [References cornerRadius:confirmFriendImage radius:confirmFriendImage.frame.size.height/2];
    confirmFriendImage.alpha = 0;
    keepLookingImage.alpha = 0;
    lastOffest = 0;
    lastAlpha = 1;
    stopReloading = NO;
    _highlightView = [[UIView alloc] init];
    _highlightView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
    _highlightView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    [self.view addSubview:_highlightView];
    
    [self.view addSubview:resultText];
    if ([AVCaptureDevice respondsToSelector:@selector(requestAccessForMediaType: completionHandler:)]) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            // Will get here on both iOS 7 & 8 even though camera permissions weren't required
            // until iOS 8. So for iOS 7 permission will always be granted.
            if (granted) {
                // Permission has been granted. Use dispatch_async for any UI updating
                // code because this block may be executed in a thread.
                dispatch_async(dispatch_get_main_queue(), ^{
                    _session = [[AVCaptureSession alloc] init];
                    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
                    NSError *error = nil;
                    
                    _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:&error];
                    if (_input) {
                        [_session addInput:_input];
                    } else {
                        NSLog(@"Error: %@", error);
                    }
                    
                    _output = [[AVCaptureMetadataOutput alloc] init];
                    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
                    [_session addOutput:_output];
                    
                    _output.metadataObjectTypes = [_output availableMetadataObjectTypes];
                    
                    _prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
                    _prevLayer.frame = self.view.bounds;
                    _prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
                    [self.view.layer addSublayer:_prevLayer];
                    [self.view.layer insertSublayer:_prevLayer atIndex:0];
                    [_session startRunning];
                    [self.view bringSubviewToFront:_highlightView];
                    [self.view bringSubviewToFront:resultText];

                });
            } else {
                // Permission has been denied.
            }
        }];
    } else {
        // We are on iOS <= 6. Just do what we need to do.
        _session = [[AVCaptureSession alloc] init];
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        NSError *error = nil;
        
        _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:&error];
        if (_input) {
            [_session addInput:_input];
        } else {
            NSLog(@"Error: %@", error);
        }
        
        _output = [[AVCaptureMetadataOutput alloc] init];
        [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        [_session addOutput:_output];
        
        _output.metadataObjectTypes = [_output availableMetadataObjectTypes];
        
        _prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
        _prevLayer.frame = self.view.bounds;
        _prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [self.view.layer addSublayer:_prevLayer];
        [self.view.layer insertSublayer:_prevLayer atIndex:0];
        [_session startRunning];
        [self.view bringSubviewToFront:_highlightView];
        [self.view bringSubviewToFront:resultText];

    }
   
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    CGRect highlightViewRect = CGRectZero;
    AVMetadataMachineReadableCodeObject *barCodeObject;
    NSString *detectionString = nil;
    NSArray *barCodeTypes = @[AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code,
                              AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code,
                              AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode];
    
    for (AVMetadataObject *metadata in metadataObjects) {
        for (NSString *type in barCodeTypes) {
            if ([metadata.type isEqualToString:type])
            {
                barCodeObject = (AVMetadataMachineReadableCodeObject *)[_prevLayer transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)metadata];
                highlightViewRect = barCodeObject.bounds;
                detectionString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
                break;
            }
        }
        
        if (detectionString != nil)
        {
            if (stopReloading == NO) {
                NSArray *info = [detectionString componentsSeparatedByString:@"^$^"];
                usernameScanned = info[0];
                phoneScanned = info[1];
                [References fadeOut:blurView];
                _highlightView.hidden = YES;
                [_titleLabel setText:usernameScanned];
                [resultText setText:@"drag the arrows to confirm your friend"];
                [References fadeIn:blurView];
                [References fadeIn:keepLookingImage];
                [References fadeIn:confirmFriendImage];
                stopReloading = YES;
                superScrollView.scrollEnabled = YES;
            }
            
            break;
        }
        else
            [resultText setText:@"scan a code or tap above to manually add a friend."];
        [_titleLabel setText:@"Add Friend"];
    }
    
    _highlightView.frame = highlightViewRect;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (addFriend == NO) {
        if (keepLooking.frame.size.height > 567) {
            [References fadeOut:blurView];
            _highlightView.hidden = YES;
            [resultText setText:@"scan a code or tap above to manually add a friend"];
            [_titleLabel setText:@"Add Friend"];
            [References fadeOut:blurView];
            [References fadeOut:keepLookingImage];
            [References fadeOut:confirmFriendImage];
            stopReloading = NO;
            superScrollView.scrollEnabled = NO;
        }
        if (confirmFriend.frame.origin.y < 0) {
            addFriend =YES;
            //[References toastMessage:@"one sec" andView:self];
            [resultText setText:@"invite them to your next event!"];
            BOOL isUppercase = [[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:[usernameScanned characterAtIndex:0]];
            if (isUppercase == TRUE) {
                [_titleLabel setText:[NSString stringWithFormat:@"%@ Added!",usernameScanned]];
            } else {
                [_titleLabel setText:[NSString stringWithFormat:@"%@ added!",usernameScanned]];
            }
            [References fadeOut:confirmFriendImage];
            [References fadeOut:keepLookingImage];
            [References fadeIn:goingBack];
            [NSTimer scheduledTimerWithTimeInterval:2.0
                                             target:self
                                           selector:@selector(goingBack)
                                           userInfo:nil
                                            repeats:NO];
        }
        if (scrollView.contentOffset.y < 0) {
            if (scrollView.contentOffset.y > -500) {
                confirmFriend.frame = CGRectMake(0, [References screenHeight]+8*scrollView.contentOffset.y, [References screenWidth], [References screenHeight]-8*scrollView.contentOffset.y);
            }
        } else {
            if (scrollView.contentOffset.y < 350) {
                keepLooking.frame = CGRectMake(0, 0, [References screenWidth], 8*scrollView.contentOffset.y);
            }
        }
        lastOffest = scrollView.contentOffset.y;
    }
    
}

-(void)goingBack {
    [self addFriend:phoneScanned andName:usernameScanned];
    // add tue friend then quit
}

- (CIImage *)createQRForString:(NSString *)qrString
{
    // Need to convert the string to a UTF-8 encoded NSData object
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    
    // Create the filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // Set the message content and error-correction level
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    
    // Send the image back
    return qrFilter.outputImage;
}

-(void)addFriend:(NSString*)phoneNumber andName:(NSString*)name{
    NSURL *url = [NSURL URLWithString:@"http://138.197.217.29:5000/addFriend"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    // NSError *actualerror = [[NSError alloc] init];
    // Parameters
    NSDictionary *tmp = [[NSDictionary alloc] init];
    tmp = @{
            @"phone"     : [[NSUserDefaults standardUserDefaults] objectForKey:@"phone"],
            @"otherPhone"    : phoneNumber,
            @"otherName"    : name
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
                                   [[NSUserDefaults standardUserDefaults] setObject:responseBody forKey:@"updateFriends"];
                                   [[NSUserDefaults standardUserDefaults] synchronize];
                                   [self dismissViewControllerAnimated:YES completion:nil];
                               }
                           }];
}

-(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)segmentControl:(id)sender {
    NSString *selected = [segmentControl titleForSegmentAtIndex:segmentControl.selectedSegmentIndex];
    if ([selected isEqualToString:@"Scan Code"]) {
        [References fadeOut:myQRCode];
        [References fadeOut:blurView];
        superScrollView.scrollEnabled = NO;
        stopReloading = NO;
    } else if ([selected isEqualToString:@"My Code"]) {
        superScrollView.scrollEnabled = NO;
        UIImage *qrCode =[self createNonInterpolatedUIImageFromCIImage:[self createQRForString:[NSString stringWithFormat:@"%@^$^%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"name"], [[NSUserDefaults standardUserDefaults] objectForKey:@"phone"]]] withScale:5];
        [self changeWhiteColorTransparent:qrCode];
        UIImage *final = [self changeWhiteColorTransparent:qrCode];
        [myQRCode setImage:final];
        if ([References screenHeight] > 568) {
            myQRCode.frame = CGRectMake(([References screenWidth]/2)-(myQRCode.frame.size.width/2), myQRCode.frame.origin.y, myQRCode.frame.size.width, myQRCode.frame.size.height);
        }
        [References fadeIn:blurView];
        [References fadeIn:myQRCode];
        stopReloading = YES;
    }
}

- (IBAction)addByUsername:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add By Phone Number" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Search", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
    NSURL *url = [NSURL URLWithString:@"http://138.197.217.29:5000/findFriend"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    // NSError *actualerror = [[NSError alloc] init];
    // Parameters
    NSDictionary *tmp = [[NSDictionary alloc] init];
    tmp = @{
            @"phone"     : [alertView textFieldAtIndex:0].text,
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
                                       [References toastMessage:@"No user with that phone number" andView:self];
                                   } else {
                                   [References fadeOut:blurView];
                                   _highlightView.hidden = YES;
                                   [_titleLabel setText:responseBody];
                                       phoneScanned = [alertView textFieldAtIndex:0].text;
                                       usernameScanned = responseBody;
                                   [resultText setText:@"drag the arrows to confirm your friend"];
                                   [References fadeIn:blurView];
                                   [References fadeIn:keepLookingImage];
                                   [References fadeIn:confirmFriendImage];
                                   stopReloading = YES;
                                   superScrollView.scrollEnabled = YES;
                                   }
                               }
                           }];
    
    }
}

- (UIImage *)createNonInterpolatedUIImageFromCIImage:(CIImage *)image withScale:(CGFloat)scale
{
    // Render the CIImage into a CGImage
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:image fromRect:image.extent];
    
    // Now we'll rescale using CoreGraphics
    UIGraphicsBeginImageContext(CGSizeMake(image.extent.size.width * scale, image.extent.size.width * scale));
    CGContextRef context = UIGraphicsGetCurrentContext();
    // We don't want to interpolate (since we've got a pixel-correct image)
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    // Get the image out
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // Tidy up
    UIGraphicsEndImageContext();
    CGImageRelease(cgImage);
    // Need to set the image orientation correctly
    UIImage *flippedImage = [UIImage imageWithCGImage:[scaledImage CGImage]
                                                scale:scaledImage.scale
                                          orientation:UIImageOrientationDownMirrored];
    
    return flippedImage;
}

-(UIImage *)changeWhiteColorTransparent: (UIImage *)image
{
    //convert to uncompressed jpg to remove any alpha channels
    //this is a necessary first step when processing images that already have transparency
    image = [UIImage imageWithData:UIImageJPEGRepresentation(image, 1.0)];
    CGImageRef rawImageRef=image.CGImage;
    //RGB color range to mask (make transparent)  R-Low, R-High, G-Low, G-High, B-Low, B-High
    const CGFloat colorMasking[6] = {222, 255, 222, 255, 222, 255};
    
    UIGraphicsBeginImageContext(image.size);
    CGImageRef maskedImageRef=CGImageCreateWithMaskingColors(rawImageRef, colorMasking);
    
    //iPhone translation
    CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0.0, image.size.height);
    CGContextScaleCTM(UIGraphicsGetCurrentContext(), 1.0, -1.0);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, image.size.width, image.size.height), maskedImageRef);
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    CGImageRelease(maskedImageRef);
    UIGraphicsEndImageContext();
    return result;
}
@end
