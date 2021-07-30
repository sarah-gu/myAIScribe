//
//  ClassDetailCollectionViewCell.h
//  myAIScribe
//
//  Created by Sarah Wen Gu on 7/30/21.
//
#import "Note.h"
#import <UIKit/UIKit.h>
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface ClassDetailCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet PFImageView *myImageView;
@property (strong, nonatomic) Note * note;
@end

NS_ASSUME_NONNULL_END
