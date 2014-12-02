#import "Headers.h"

#ifdef DEBUG
    #define PPLog(fmt, ...) NSLog((@"[ProPic] %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
    #define PPLog(fmt, ...)
#endif

MXLMediaView *mediaView;
%hook IGUserDetailViewController

%new - (void)handleTapFrom:(UITapGestureRecognizer*)tapGestureRecognizer {
	mediaView = [[MXLMediaView alloc] init];

    if (self.headerView.profilePic.originalImage) {
    	PPLog(@"IMAGE EXISTS; CONTINUING DISPLAY");
    	UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressFrom:)];
    	[longPress setMinimumPressDuration:0.3];
    	[mediaView addGestureRecognizer:longPress];
    	[mediaView showImage:self.headerView.profilePic.originalImage inParentView:self.navigationController.parentViewController.view completion:^{
      		PPLog(@"PROFILE PIC IS SHOWING");
    	}];
    } else {
    	PPLog(@"IMAGE DOESN'T EXIST");
    }
}

%new - (void)handleLongPressFrom:(UILongPressGestureRecognizer*)longPressGestureRecognizer {
	PPLog(@"LONG PRESS ACTIVATED; SHARE MENU OPENING");
	
	if (mediaView) {
		UIActivityViewController *activityViewController;
		if (mediaView.mediaType == MXLMediaViewTypeImage) {
			activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[mediaView.mediaImage]
                                    applicationActivities:nil];
		} else {
			activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[mediaView.videoURL]
                                    applicationActivities:nil];
		}

		[self.navigationController.parentViewController presentViewController:activityViewController
                                      animated:YES
                                    completion:nil];
	}
}

%end

%hook UINavigationController

- (void)pushViewController:(id)viewController animated:(BOOL)animated {
	
	PPLog(@"VIEWCONTROLLER IS OF CLASS: %@",[viewController class]);
	if([viewController isKindOfClass:[%c(IGUserDetailViewController) class]]) {
		PPLog(@"VIEWCONTROLLER IS IGUSERDETAILVIEWCONTROLLER; ADDING IMAGEVIEWER FUNCTIONALITY TO PROFILE PIC");
		IGUserDetailViewController *userDetail = (IGUserDetailViewController*)viewController;
		[userDetail.headerView.profilePic setUserInteractionEnabled:YES];
		[userDetail.headerView.profilePic addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:userDetail action:@selector(handleTapFrom:)]];
		PPLog(@"TAP GESTURE ENABLED; COMPLETING NAV CONTROLLER TRANSITION");
		%orig(userDetail,animated);
	} else {
		PPLog(@"VIEWCONTROLLER IS NOT OF IGUSERDETAILVIEWCONTROLLER; NOT ADDING IMAGEVIEWER FUNCTIONALITY");
		%orig;
	}
}

%end
