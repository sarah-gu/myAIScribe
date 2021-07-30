//
//  ClassDetailCollectionViewCell.m
//  myAIScribe
//
//  Created by Sarah Wen Gu on 7/30/21.
//

#import "ClassDetailCollectionViewCell.h"
@import Parse;
#import "Note.h"

@implementation ClassDetailCollectionViewCell

- (void) setNote:(Note *)note {
    self.myImageView.file = note[@"image"];
    [self.myImageView loadInBackground];
}

@end
