//
//  ScanViewController.m
//  myAIScribe
//
//  Created by Sarah Wen Gu on 7/12/21.
//

#import "ScanViewController.h"
#import "Note.h"
#import "SceneDelegate.h"
#import "LoginViewController.h"
#import "SVProgressHUD.h"

@interface ScanViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *notePic;
@property (weak, nonatomic) IBOutlet UITextField *classTag;
@property (weak, nonatomic) IBOutlet UITextField *classTag2;
@property (weak, nonatomic) IBOutlet UITextField *classTag3;
@property (nonatomic) BOOL animateLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *classTagTopConstraint;

@end

@implementation ScanViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.classTag2.alpha = 0;
    self.classTag3.alpha = 0;
    self.animateLabel = NO;
   // [self takePic:YES];
}
- (IBAction)saveNote:(id)sender {
    UIImage *imageToPost = self.notePic.image;
    [SVProgressHUD show];
    NSString *sub1 =self.classTag.text;
    NSString *sub2 = self.classTag2.text;
    NSString *sub3 = self.classTag3.text;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [Note postUserImage:imageToPost
               withCaption1: sub1
               withCaption2: sub2
               withCaption3: sub3
             withCompletion: ^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded){
                NSLog(@"posted image successfuly");
                PFUser *currentUser = [PFUser currentUser];
                [currentUser incrementKey:@"numNotes"];
                //save the user with updated note count
                [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if(!error){
                        NSLog(@"successfully incremented notesCount");
                        NSLog(@"%@", currentUser[@"numNotes"]);
                        //stop the loading icon for SVProgressHUD
                        dispatch_async(dispatch_get_main_queue(),^{
                            [SVProgressHUD dismiss];
                        });
                        //switch the viewcontroller to a new window
                        SceneDelegate *appDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        UITabBarController *tabViewController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarController" ];
                        [tabViewController setSelectedIndex:1];
                        appDelegate.window.rootViewController = tabViewController;
                    }
                }];
            }
            else{
                NSLog(@"Error posting: %@", error.localizedDescription);
            }
        }];
    });
    
}

- (IBAction)logoutBtn:(id)sender {
    SceneDelegate *appDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    //AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController" ];
    appDelegate.window.rootViewController = loginViewController;
    NSLog(@"logged out");
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
    }];
}
- (IBAction)onTap:(id)sender {
    [self.view endEditing:true];
    if(self.animateLabel){
        [UIView animateWithDuration:0.5 animations:^{
            self.classTagTopConstraint.constant = 8;
            [self.view layoutIfNeeded];
        }];
        self.animateLabel = NO;
    }
}



- (IBAction)takeNewPic:(id)sender {
    [self takePic:YES];
}

- (IBAction)takePicFromLibrary:(id)sender {
    [self takePic:NO];
}


- (IBAction)onFirstTagWritten:(id)sender {
    self.classTag2.alpha = 1;
    if(!self.animateLabel){
        [UIView animateWithDuration:0.5 animations:^{
            self.classTagTopConstraint.constant = -208;
            [self.view layoutIfNeeded]; // Called on parent view

        }];
    }
    self.animateLabel = YES;
}

- (IBAction)secondTagWritten:(id)sender {
    self.classTag3.alpha = 1;
    if(!self.animateLabel){
        [UIView animateWithDuration:0.5 animations:^{
            self.classTagTopConstraint.constant = -208;
            [self.view layoutIfNeeded]; // Called on parent view
        }];
    }
    self.animateLabel = YES;
}

-(void) takePic:(BOOL) isCamera {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;

    imagePickerVC.navigationBarHidden = NO;
    imagePickerVC.toolbarHidden = YES;
    // The Xcode simulator does not support taking pictures, so let's first check that the camera is indeed supported on the device before trying to present it.
    if(isCamera) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
            //imagePickerVC.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
            imagePickerVC.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
            imagePickerVC.showsCameraControls = YES;
        }
        else {
            NSLog(@"Camera 🚫 available so we will use photo library instead");
            imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
    }
    else {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
//    if ([[UIScreen mainScreen] bounds].size.height == 568.0f) {
//        // iPhone 5, 16:9 ratio, need to "zoom in" in order to fill the screen since there is extra space between top and bottom bars on a taller screen
//        imagePickerVC.cameraViewTransform = CGAffineTransformScale(imagePickerVC.cameraViewTransform, 1.5, 1.5); // change 1.5 to suit your needs
//    }
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

// helper method for the camera
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    // Get the image captured by the UIImagePickerController
    //UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    [self.notePic setImage:editedImage];
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
