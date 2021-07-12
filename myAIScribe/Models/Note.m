//
//  Note.m
//  myAIScribe
//
//  Created by Sarah Wen Gu on 7/12/21.
//

#import "Note.h"
#import "Parse/Parse.h"

@implementation Note

@dynamic postID;
@dynamic userID;
@dynamic author;
//@dynamic caption;
@dynamic image;
//@dynamic likeCount;
//@dynamic commentCount;



+ (nonnull NSString *)parseClassName {
    return @"Note";
}

+ (void) postUserImage: ( UIImage * _Nullable )image  withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    Note *newNote = [Note new];
    newNote.image = [self getPFFileFromImage:image];
    
    newNote.author = [PFUser currentUser];
    //newNote.caption = caption;
    //newNote.likeCount = @(0);
    //newNote.commentCount = @(0);
    
    //[self resizeImage:newPost.image withSize:@10];
    [newNote saveInBackgroundWithBlock: completion];
}

+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
 
    // check if image is not nil
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
 //   return [PFFileObject fileWithName:@"image.png" data:imageData];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
@end


