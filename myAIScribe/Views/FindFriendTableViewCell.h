//
//  FindFriendTableViewCell.h
//  myAIScribe
//
//  Created by Sarah Wen Gu on 7/30/21.
//

@import Parse; 
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FindFriendTableViewCell : UITableViewCell

@property (strong, nonatomic) PFUser *clickedUser;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *followBtn;

@end

NS_ASSUME_NONNULL_END
