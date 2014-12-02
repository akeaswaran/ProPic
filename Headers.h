//Headers.h
#import "External/MXLMediaView.h"

@interface IGUser
@property(copy) NSString *displayName; // @synthesize displayName=_displayName;
@property(copy) NSString *fullName; // @synthesize fullName=_fullName;
@property(retain) NSURL *profilePicURL;
@end

@interface IGImageView : UIImageView
@end

@interface IGProfilePictureImageView : IGImageView
@property(readonly, nonatomic) UIImage *originalImage; // @synthesize originalImage=_originalImage;
- (void)addGestureRecognizer:(UIGestureRecognizer*)gestureRecognizer;
- (void)setUserInteractionEnabled:(BOOL)enabled;
@end

@interface IGUserTableHeaderView
@property(retain, nonatomic) IGProfilePictureImageView *profilePic;
@end

@interface IGUserDetailViewController <MXLMediaViewDelegate>
@property(retain, nonatomic) IGUserTableHeaderView *headerView;
@property(retain) UIView *view;
@property(retain,readonly) UINavigationController * navigationController;
- (void)handleTapFrom:(UITapGestureRecognizer*)tapGestureRecognizer; //new
- (BOOL)isShowingCurrentUser;
//- (void)viewDidLoad;
- (id)init;
//- (void)presentViewController:(UIViewController*)viewController animated:(BOOL)animated completion:(void(^)(void))completion;
@end

