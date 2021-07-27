//
//  RegisterViewController.m
//  myAIScribe
//
//  Created by Sarah Wen Gu on 7/14/21.
//
//@import Parse;
#import "Parse/Parse.h"
#import "RegisterViewController.h"

@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *fullNameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)onSignUp:(id)sender {
    
    [self checkEmptyFields];

    PFUser *newUser = [PFUser user];
    // set user properties
    newUser[@"fullName"] = self.fullNameField.text;
    newUser[@"numNotes"] = @0;
    newUser[@"numGoals"] = @0; 
    newUser.username = self.usernameField.text;
    newUser.email = self.emailField.text;
    newUser.password = self.passwordField.text;
    NSLog(@"%@", newUser.username);
    NSArray *friendArray = [[NSArray alloc] init];

    // call sign up function on the object
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {

            [self failedAttempt:[NSString stringWithFormat:@"%@", ((void)(@"User log in failed: %@"), error.localizedDescription)]];
           // NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"User registered successfully");
            [newUser addObject:friendArray forKey:@"friends"];
            [newUser saveInBackground];
            [newUser addObject:friendArray forKey:@"followers"];
            // manually segue to logged in view
            [self performSegueWithIdentifier:@"mainPageSegue" sender:nil];
        }
    }];
}

- (IBAction)onTap:(id)sender {
    [self.view endEditing:true];
}

- (void) failedAttempt:(NSString*) mes {
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

- (void) checkEmptyFields {
    if ([self.usernameField.text isEqual:@""] || [self.passwordField.text isEqual:@""] || [self.fullNameField.text isEqual:@""] ||  [self.emailField.text isEqual:@""]   ){
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
