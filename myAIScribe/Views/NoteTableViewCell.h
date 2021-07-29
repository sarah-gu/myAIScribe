//
//  NoteTableViewCell.h
//  myAIScribe
//
//  Created by Sarah Wen Gu on 7/12/21.
//
@import Parse;
#import <UIKit/UIKit.h>
#import "Note.h"
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoteTableViewCell : UITableViewCell
@property (strong, nonatomic) Note *note;
@property (weak, nonatomic) IBOutlet PFImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *timePosted;
@property (weak, nonatomic) IBOutlet UILabel *noteCreator;
@property (weak, nonatomic) IBOutlet UILabel *subjectTag1;
@property (weak, nonatomic) IBOutlet UILabel *subjectTag2;
@property (weak, nonatomic) IBOutlet UILabel *subjectTag3;
@property (weak, nonatomic) IBOutlet UILabel *fullName;

@end

NS_ASSUME_NONNULL_END
