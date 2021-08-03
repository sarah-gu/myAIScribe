//
//  EditInfoViewController.m
//  myAIScribe
//
//  Created by Sarah Wen Gu on 8/3/21.
//

#import "EditInfoViewController.h"
@import Parse;

@interface EditInfoViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet PFImageView *profilePicture;

@end

@implementation EditInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    PFUser *currentUser = [PFUser currentUser];
    self.nameField.text = currentUser[@"fullName"];
    self.emailField.text = currentUser[@"email"];
    self.passwordField.text = currentUser[@"password"];
    self.usernameField.text = currentUser[@"fullName"];
    self.profilePicture.file = currentUser[@"profilePicture"];
}

- (IBAction)saveInfoOnClick:(id)sender {
    PFUser *currentUser = [PFUser currentUser];
    currentUser[@"fullName"] = self.nameField.text;
    currentUser[@"email"] = self.emailField.text;
    currentUser[@"password"] = self.passwordField.text;
    UIImage *image = self.profilePicture.image;

    NSData *imageData = UIImagePNGRepresentation(image);

    currentUser[@"profilePicture"] = [PFFileObject fileObjectWithName:@"image.png" data:imageData];
    
    [currentUser saveInBackground];
    
}

- (IBAction)changePFP:(id)sender {
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
    [self.profilePicture setImage:editedImage];
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
