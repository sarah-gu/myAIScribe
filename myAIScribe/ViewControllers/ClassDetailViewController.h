//
//  ClassDetailViewController.h
//  myAIScribe
//
//  Created by Sarah Wen Gu on 7/30/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ClassDetailViewController : UIViewController
@property (strong, nonatomic) NSArray *posts;
@property (weak, nonatomic) IBOutlet UILabel *classLabel;
@end

NS_ASSUME_NONNULL_END
