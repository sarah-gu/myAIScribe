//
//  SuggestedNotesCollectionViewCell.h
//  myAIScribe
//
//  Created by Sarah Wen Gu on 7/20/21.
//
#import "Note.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SuggestedNotesCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) Note *post;
@property (weak, nonatomic) IBOutlet PFImageView *myImageView;

@end

NS_ASSUME_NONNULL_END
