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
#import <QuartzCore/QuartzCore.h>

@implementation NoteTableViewCell

- (void)setNote:(Note *)note {
    _note = note;
    self.photoImageView.file = note[@"image"];
    [self.photoImageView loadInBackground];
    
    [self setSubjectLabel:note[@"subject1"] toViewField:self.subjectTag1];
    [self setSubjectLabel:note[@"subject2"] toViewField:self.subjectTag2];
    [self setSubjectLabel:note[@"subject3"] toViewField:self.subjectTag3];
    
    self.noteCreator.text = [NSString stringWithFormat:@"@%@", note[@"author"][@"username"]];
    self.fullName.text = [NSString stringWithFormat:@"%@", note[@"author"][@"fullName"]];
    self.subjectTag1.layer.masksToBounds = YES;
    self.subjectTag1.layer.cornerRadius = 10;

    self.subjectTag2.layer.masksToBounds = YES;
    self.subjectTag2.layer.cornerRadius = 10;
    self.subjectTag3.layer.masksToBounds = YES;
    self.subjectTag3.layer.cornerRadius = 10;
    NSDate *date = self.note.createdAt;
    self.timePosted.text =date.shortTimeAgoSinceNow;
}

-(void) setSubjectLabel:(NSString *) subjectFromNote toViewField: (UILabel *) myField {
    if(subjectFromNote == nil || [subjectFromNote isEqual:@""]){
        myField.alpha = 0;
        myField.backgroundColor = [UIColor whiteColor];
    }
    else{
        myField.alpha = 1;
       // myField.backgroundColor = [UIColor lightGrayColor];
        myField.backgroundColor = [[UIColor alloc] initWithRed: 68.0/255.0 green: 44.0/255.0 blue: 46.0/255.0 alpha: 1.0];
        [subjectFromNote lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
        if(subjectFromNote.length > 10) {
            myField.text = [NSString stringWithFormat:@" %@ ", subjectFromNote] ;
        }
        else {
            myField.text = subjectFromNote;
        }
    }
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
