//
//  ProfileViewController.h
//  myAIScribe
//
//  Created by Sarah Wen Gu on 7/21/21.
//
@import Parse; 
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProfileViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *fullName;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *followers;
@property (weak, nonatomic) IBOutlet UILabel *following;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *numPosts;
@property (weak, nonatomic) IBOutlet UIButton *followBtn;
@property (strong, nonatomic) NSArray *posts;
@property (strong, nonatomic) PFUser *currentUser;

@end

NS_ASSUME_NONNULL_END
