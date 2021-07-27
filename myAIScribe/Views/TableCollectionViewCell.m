//
//  TableCollectionViewCell.m
//  myAIScribe
//
//  Created by Sarah Wen Gu on 7/27/21.
//
#import "Note.h"
#import "TableCollectionViewCell.h"

@implementation TableCollectionViewCell

- (void) setNote:(Note *)note {
    self.noteImage.file = note[@"image"];
    [self.noteImage loadInBackground];
}

@end
