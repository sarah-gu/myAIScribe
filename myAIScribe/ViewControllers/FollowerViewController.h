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
@property (nonatomic, strong) PFUser *currentUser;
@end

NS_ASSUME_NONNULL_END
