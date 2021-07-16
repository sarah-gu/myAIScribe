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

@end

@implementation ScanViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self takePic];
}
- (IBAction)saveNote:(id)sender {
    UIImage *imageToPost = self.notePic.image;
    NSString *mySubject = self.classTag.text;
    [SVProgressHUD show];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [Note postUserImage:imageToPost withCaption:mySubject withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
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

- (IBAction)takeNewPic:(id)sender {
    [self takePic];
}

-(void) takePic {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    // The Xcode simulator does not support taking pictures, so let's first check that the camera is indeed supported on the device before trying to present it.
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
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
