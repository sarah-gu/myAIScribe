//
//  Friends.m
//  myAIScribe
//
//  Created by Sarah Wen Gu on 7/27/21.
//

#import "Friends.h"
@import Parse;

@implementation Friends
@dynamic friendId;
@dynamic following;
@dynamic follower;

+ (nonnull NSString *)parseClassName {
    return @"Friends";
}

+ (void) addNewFollowing: ( PFUser * _Nullable )myFollower withFollowing:(PFUser * _Nullable)myFollowing withCompletion: (PFBooleanResultBlock  _Nullable)completion {
  //  PFObject *newFriend = [PFObject objectWithClassName:@"Friends"];
    Friends *newFriend = [Friends new];
    newFriend.following = myFollowing;
    newFriend.follower = myFollower; 
    [newFriend saveInBackgroundWithBlock: completion];
}

@end
