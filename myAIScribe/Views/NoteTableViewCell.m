//
//  NoteTableViewCell.m
//  myAIScribe
//
//  Created by Sarah Wen Gu on 7/12/21.
//
@import Parse; 
#import "NoteTableViewCell.h"
#import "Note.h"
#import "DateTools.h"

@implementation NoteTableViewCell

- (void)setNote:(Note *)note {
    _note = note;
    self.photoImageView.file = note[@"image"];
    [self.photoImageView loadInBackground];
    
   
    self.noteCreator.text = [NSString stringWithFormat:@"@%@", note[@"author"][@"username"]];
  
    NSDate *date = self.note.createdAt;
    self.timePosted.text =date.shortTimeAgoSinceNow;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
