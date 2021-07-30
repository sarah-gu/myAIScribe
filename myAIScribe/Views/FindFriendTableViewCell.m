//
//  FindFriendTableViewCell.m
//  myAIScribe
//
//  Created by Sarah Wen Gu on 7/30/21.
//

#import "FindFriendTableViewCell.h"
#import "Friends.h"
@import Parse;

@implementation FindFriendTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)followFriend:(id)sender {
    PFUser *currentUser = [PFUser currentUser];
    PFUser *authorOfNote = self.clickedUser; 
    
    [Friends addNewFollowing:currentUser withFollowing:authorOfNote withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded){
            NSLog(@"new Friend created!");
        }
    }];
    
    NSMutableArray *myFriends = [currentUser objectForKey:@"friends"];
    [myFriends addObject:self.clickedUser];
    currentUser[@"friends"] = myFriends;
    [currentUser saveInBackground];

    [self.followBtn setTitle:@"Following" forState:UIControlStateNormal];
    self.followBtn.enabled = NO;
   // NSLog(@"%@", authorFollowers);
    NSLog(@"friend & follower added! ");
}

@end
