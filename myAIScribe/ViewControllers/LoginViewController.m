//
//  LoginViewController.m
//  myAIScribe
//
//  Created by Sarah Wen Gu on 7/12/21.
//

#import "LoginViewController.h"
#import "Parse/Parse.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
}
- (IBAction)onTap:(id)sender {

    [self.view endEditing:true];

}
- (IBAction)loginBtn:(id)sender {
    
    [self checkEmptyFields];
    
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
           // NSLog(@"User log in failed: %@", error.localizedDescription);
            
            [self failedAttempt:[NSString stringWithFormat:@"%@", ((void)(@"User log in failed: %@"), error.localizedDescription)]];
        } else {
            NSLog(@"User logged in successfully");
            
            // display view controller that needs to shown after successful login
            
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        }
    }];
    
}

- (IBAction)registerUser:(id)sender {

    [self performSegueWithIdentifier:@"registerSegue" sender:nil];
}
// code to eror check for empty fields / incorrect username
- (void) failedAttempt:(NSString*) mes{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Failed Attempt"
                                                                               message:mes
                                                                        preferredStyle:(UIAlertControllerStyleAlert)];
    
    // create a cancel action
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                             // handle cancel response here. Doing nothing will dismiss the view.
                                                      }];
    // add the cancel action to the alertController
    [alert addAction:cancelAction];

    // create an OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                             // handle response here.
                                                     }];
    // add the OK action to the alert controller
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:^{
        // optional code for what happens after the alert controller has finished presenting
    }];
}

- (void) checkEmptyFields{
    if ([self.usernameField.text isEqual:@""] || [self.passwordField.text isEqual:@""]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Invalid Fields"
                                                                                   message:@"You left either your username or password empty!"
                                                                            preferredStyle:(UIAlertControllerStyleAlert)];
        
        // create a cancel action
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                                 // handle cancel response here. Doing nothing will dismiss the view.
                                                          }];
        // add the cancel action to the alertController
        [alert addAction:cancelAction];

        // create an OK action
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                                 // handle response here.
                                                         }];
        // add the OK action to the alert controller
        [alert addAction:okAction];
        
        [self presentViewController:alert animated:YES completion:^{
            // optional code for what happens after the alert controller has finished presenting
        }];
    }
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
