//
//  DetailsViewController.h
//  myAIScribe
//
//  Created by Sarah Wen Gu on 7/12/21.
//

#import <UIKit/UIKit.h>
@import Parse;
#import "Note.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController
@property (nonatomic, strong) Note* note;

@end

NS_ASSUME_NONNULL_END
