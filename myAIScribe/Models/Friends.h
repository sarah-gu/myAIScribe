//
//  Friends.h
//  myAIScribe
//
//  Created by Sarah Wen Gu on 7/27/21.
//
#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Friends : PFObject<PFSubclassing>
@property (nonatomic, strong) NSString *friendId;
@property (nonatomic, strong) PFUser *follower;
@property (nonatomic, strong) PFUser *following;
+ (void) addNewFollowing: ( PFUser * _Nullable )myFollower withFollowing:(PFUser * _Nullable)myFollowing withCompletion: (PFBooleanResultBlock  _Nullable)completion;
@end

NS_ASSUME_NONNULL_END
