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
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) PFUser *author;

@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) PFFileObject *image;
@property (nonatomic, strong) NSString *subject; 
//@property (nonatomic, strong) NSNumber *likeCount;
//@property (nonatomic, strong) NSNumber *commentCount;



+ (void) postUserImage: ( UIImage * _Nullable )image withCaption: (NSString * _Nullable)myCaption withCompletion: (PFBooleanResultBlock  _Nullable)completion;
@end
