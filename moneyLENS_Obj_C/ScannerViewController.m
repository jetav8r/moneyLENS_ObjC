//
//  ScannerViewController.m
//  moneyLENS_Obj_C
//
//  Created by Wayne Johnson on 9/17/15.
//  Copyright © 2015 Wayne Johnson. All rights reserved.
//

#import "ScannerViewController.h"
#import "moneyLENS-Swift.h"


static int kMSResultTypes = MSResultTypeImage | MSResultTypeQRCode |
	MSResultTypeEAN13;

@interface ScannerViewController () <MSAutoScannerSessionDelegate, UIActionSheetDelegate>

@property (weak) IBOutlet UIView *videoPreview;

@end

@implementation ScannerViewController {
	MSAutoScannerSession *_scannerSession;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	_scannerSession = [[MSAutoScannerSession alloc] initWithScanner:_scanner];
	_scannerSession.delegate = self;
	_scannerSession.resultTypes = kMSResultTypes;
	
	CALayer *videoPreviewLayer = [self.videoPreview layer];
	[videoPreviewLayer setMasksToBounds:YES];
	
	CALayer *captureLayer = [_scannerSession captureLayer];
	[captureLayer setFrame:[self.videoPreview bounds]];
	
	[videoPreviewLayer insertSublayer:captureLayer
								below:[[videoPreviewLayer sublayers] objectAtIndex:0]];
	[_scannerSession startRunning];
	}

- (void)viewWillLayoutSubviews
{
	[self updateInterfaceOrientation:self.interfaceOrientation];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)orientation duration:(NSTimeInterval)duration
{
	[super willAnimateRotationToInterfaceOrientation:orientation duration:duration];
	[self updateInterfaceOrientation:orientation];
}

- (void)session:(id)scannerSession didFindResult:(MSResult *)result
{
	NSString *title = [result type] == MSResultTypeImage ? @"Image" : @"Barcode";
	NSString *message = [NSString stringWithFormat:@"%@:\n%@", title, [result string]];
	UIActionSheet *aSheet = [[UIActionSheet alloc] initWithTitle:message
														delegate:self
											   cancelButtonTitle:@"OK"
										  destructiveButtonTitle:nil
											   otherButtonTitles:nil];
	[aSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	[_scannerSession resumeProcessing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)updateInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	[_scannerSession setInterfaceOrientation:interfaceOrientation];
	
	AVCaptureVideoPreviewLayer *captureLayer = (AVCaptureVideoPreviewLayer *) [_scannerSession captureLayer];
	
	captureLayer.frame = self.view.bounds;
	
	// AVCapture orientation is the same as UIInterfaceOrientation
	switch (interfaceOrientation) {
		case UIInterfaceOrientationPortrait:
			[[captureLayer connection] setVideoOrientation:AVCaptureVideoOrientationPortrait];
			break;
		case UIInterfaceOrientationPortraitUpsideDown:
			[[captureLayer connection] setVideoOrientation:AVCaptureVideoOrientationPortraitUpsideDown];
			break;
		case UIInterfaceOrientationLandscapeLeft:
			[[captureLayer connection] setVideoOrientation:AVCaptureVideoOrientationLandscapeLeft];
			break;
		case UIInterfaceOrientationLandscapeRight:
			[[captureLayer connection] setVideoOrientation:AVCaptureVideoOrientationLandscapeRight];
			break;
		default:
			break;
	}
}

- (void)dealloc
{
	[_scannerSession stopRunning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
