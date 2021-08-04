//
//  FriendTableViewCell.h
//  myAIScribe
//
//  Created by Sarah Wen Gu on 7/22/21.
//

#import <UIKit/UIKit.h>
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface FriendTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet PFImageView *profilePicture;

@end

NS_ASSUME_NONNULL_END
