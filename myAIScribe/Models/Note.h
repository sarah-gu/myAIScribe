//
//  Note.h
//  myAIScribe
//
//  Created by Sarah Wen Gu on 7/12/21.
//
#import <Foundation/Foundation.h>
#import "Parse/Parse.h"

@interface Note : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *postID;
@property (nonatomic, strong) PFUser *author;

@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) PFFileObject *image;
@property (nonatomic, strong) NSString *subject1;
@property (nonatomic, strong) NSString *subject2;
@property (nonatomic, strong) NSString *subject3; 
//@property (nonatomic, strong) NSNumber *likeCount;
//@property (nonatomic, strong) NSNumber *commentCount;

+ (void) postUserImage: ( UIImage * _Nullable )image withCaption1:(NSString * _Nullable)mySubject1 withCaption2:(NSString * _Nullable)mySubject2 withCaption3:(NSString * _Nullable)mySubject3 withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end
