//
//  FollowerViewController.h
//  myAIScribe
//
//  Created by Sarah Wen Gu on 7/22/21.
//
@import Parse;
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FollowerViewController : UIViewController
@property (strong, nonatomic) PFUser *currentUser;
@property (nonatomic) BOOL isFollowing;
@end

NS_ASSUME_NONNULL_END
