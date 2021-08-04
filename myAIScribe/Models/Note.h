//
//  Note.h
//  myAIScribe
//
//  Created by Sarah Wen Gu on 7/12/21.
//
#import <Foundation/Foundation.h>
#import "Parse/Parse.h"

@interface Note : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString * _Nullable postID;
@property (nonatomic, strong) PFUser * _Nullable author;

@property (nonatomic, strong) NSString * _Nullable caption;
@property (nonatomic, strong) PFFileObject * _Nullable image;
@property (nonatomic, strong) NSString * _Nullable  subject1;
@property (nonatomic, strong) NSString * _Nullable subject2;
@property (nonatomic, strong) NSString * _Nullable subject3;
//@property (nonatomic, strong) NSNumber *likeCount;
//@property (nonatomic, strong) NSNumber *commentCount;

+ (void) postUserImage: ( UIImage * _Nullable )image withCaption1:(NSString * _Nullable)mySubject1 withCaption2:(NSString * _Nullable)mySubject2 withCaption3:(NSString * _Nullable)mySubject3 withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end
