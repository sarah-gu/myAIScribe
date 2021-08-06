//
//  Note.m
//  myAIScribe
//
//  Created by Sarah Wen Gu on 7/12/21.
//
#import <CoreML/CoreML.h>
#import "Note.h"
#import "Parse/Parse.h"
@import Parse;
#import <Vision/Vision.h>

@implementation Note

@dynamic postID;
@dynamic author;
@dynamic caption;
@dynamic image;
@dynamic subject1;
@dynamic subject2;
@dynamic subject3;
//[TODO] implement like count + comment feature
//@dynamic likeCount;
//@dynamic commentCount;

+ (nonnull NSString *)parseClassName {
    return @"Note";
}

+ (void) postUserImage: ( UIImage * _Nullable )image withCaption1:(NSString * _Nullable)mySubject1 withCaption2:(NSString * _Nullable)mySubject2 withCaption3:(NSString * _Nullable)mySubject3 withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    Note *newNote = [Note new];
    newNote.image = [self getPFFileFromImage:image];
    newNote.author = [PFUser currentUser];
    NSLog(@"saving post");
    NSString * myCaption = [self generateCaption:image];
    newNote.caption = [myCaption stringByReplacingOccurrencesOfString:@"." withString:@".\n"];
    newNote.subject1 = mySubject1;
    newNote.subject2 = mySubject2;
    newNote.subject3 = mySubject3;
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
+ (NSString *)generateCaption:(UIImage *)image {
    CIImage* ciImage = [[CIImage alloc] initWithCGImage:image.CGImage];
    NSDictionary *d = [[NSDictionary alloc] init];
    VNImageRequestHandler *handler = [[VNImageRequestHandler alloc] initWithCIImage:ciImage options:d ];
    
    VNRecognizeTextRequest *myRequest = [VNRecognizeTextRequest new];
    //myRequest.completionHandler(1, nil);
    myRequest.recognitionLevel = VNRequestTextRecognitionLevelAccurate;
    myRequest.revision = VNRecognizeTextRequestRevision1;
    [handler performRequests:@[myRequest] error:nil];
    NSString *toRet = @"";

    NSLog(@"Generated Text: %@", myRequest.results); 
    for (VNRecognizedTextObservation *observation in myRequest.results){
        VNRecognizedText *myStr = [observation topCandidates:1][0];

        NSLog(@"%@", myStr.string);
        toRet = [NSString stringWithFormat:@"%@ %@", toRet, myStr.string];

//  drawing bounding boxes over the found text (implement later)
//        CGRect boundingBox = observation.boundingBox;
//
//        CGSize size = CGSizeMake(boundingBox.size.width * self.sourceImgView.bounds.size.width, boundingBox.size.height * self.sourceImgView.bounds.size.height);
//        CGPoint origin = CGPointMake(boundingBox.origin.x * self.sourceImgView.bounds.size.width, (1-boundingBox.origin.y)*self.sourceImgView.bounds.size.height - size.height);
//
//        CAShapeLayer *layer = [CAShapeLayer layer];
//
//        layer.frame = CGRectMake(origin.x, origin.y, size.width, size.height);
//        layer.borderColor = [UIColor redColor].CGColor;
//        layer.borderWidth = 2;
//
//        [self.sourceImgView.layer addSublayer:layer];
//
    }
    
    return toRet;
    
}


@end


