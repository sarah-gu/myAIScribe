//
//  TableCollectionViewCell.h
//  myAIScribe
//
//  Created by Sarah Wen Gu on 7/27/21.
//
#import "Note.h"
@import Parse;
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TableCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet PFImageView *noteImage;
@property (strong, nonatomic) Note *note;
@end

NS_ASSUME_NONNULL_END
