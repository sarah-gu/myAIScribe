//
//  SuggestedNotesCollectionViewCell.m
//  myAIScribe
//
//  Created by Sarah Wen Gu on 7/20/21.
//
#import "Note.h"
@import Parse; 
#import "SuggestedNotesCollectionViewCell.h"

@implementation SuggestedNotesCollectionViewCell

- (void) setNote:(Note *)post {
    
    
    self.myImageView.file = post[@"image"];
    
    [self.myImageView loadInBackground];
}

@end
