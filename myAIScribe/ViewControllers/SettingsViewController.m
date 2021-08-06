//
//  SettingsViewController.m
//  myAIScribe
//
//  Created by Sarah Wen Gu on 7/12/21.
//

#import "SettingsViewController.h"
#import "ProfileViewController.h"
@import Parse;
#import "SceneDelegate.h"
#import "LoginViewController.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *joinedLabel;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;
@property (weak, nonatomic) IBOutlet UIButton *bbtn5;
@property (weak, nonatomic) IBOutlet UIButton *btn6;
@property (weak, nonatomic) IBOutlet UILabel *numNotes;
@property (weak, nonatomic) IBOutlet PFImageView *profilePicture;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    PFUser *loggedInUser = [PFUser currentUser];
    
    self.fullNameLabel.text = loggedInUser[@"fullName"];
    self.usernameLabel.text = [NSString stringWithFormat:@"@%@", loggedInUser[@"username"]];
    self.numNotes.text = [NSString stringWithFormat:@"%@", loggedInUser[@"numNotes"]];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // Configure the input format to parse the date string
    formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
    // Convert String to Date
    NSDate *date =loggedInUser.createdAt;
    // Configure output format
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterNoStyle;
    // Convert Date to String
    self.joinedLabel.text = [formatter stringFromDate:date];
    
    self.btn1.layer.masksToBounds = YES;
    self.btn1.layer.cornerRadius = 25;

    self.btn2.layer.masksToBounds = YES;
    self.btn2.layer.cornerRadius = 25;
    
    self.btn3.layer.masksToBounds = YES;
    self.btn3.layer.cornerRadius = 25;

    self.btn4.layer.masksToBounds = YES;
    self.btn4.layer.cornerRadius = 25;

    self.bbtn5.layer.masksToBounds = YES;
    self.bbtn5.layer.cornerRadius = 25;

    self.btn6.layer.masksToBounds = YES;
    self.btn6.layer.cornerRadius = 25;
    
    if(loggedInUser[@"profilePicture"] == nil){
        [self.profilePicture setImage:[UIImage systemImageNamed:@"person.crop.circle"]];
    }
    else {
        self.profilePicture.file = loggedInUser[@"profilePicture"];
        [self.profilePicture loadInBackground];
    }
    self.profilePicture.layer.masksToBounds = YES;
    self.profilePicture.layer.cornerRadius = 30;
    // Do any additional setup after loading the view.
}
- (IBAction)logoutBtn:(id)sender {
    
    SceneDelegate *appDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    //AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController" ];
    appDelegate.window.rootViewController = loginViewController;
    NSLog(@"logged out");
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
    }];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([@"profileSegue" isEqual: segue.identifier]){
        ProfileViewController *profileViewController = [segue destinationViewController];
        profileViewController.currentUser = [PFUser currentUser];
    }
}


@end
