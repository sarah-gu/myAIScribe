//
//  DetailsViewController.m
//  myAIScribe
//
//  Created by Sarah Wen Gu on 7/12/21.
//

#import "DetailsViewController.h"
#import "DateTools.h"
@import Parse;
#import "SceneDelegate.h"
#import "DisplayViewController.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet PFImageView *largeImageView;
@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timePostedLabel;
@property (weak, nonatomic) IBOutlet UIButton *deletePostBtn;
@property (weak, nonatomic) IBOutlet UIButton *followFriendBtn;
@property (weak, nonatomic) IBOutlet UITextView *generatedCaption;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _note = self.note;
    self.largeImageView.file = self.note[@"image"];
    [self.largeImageView loadInBackground];
    self.generatedCaption.text = self.note[@"caption"];
    //disable or enable the delete post button
    PFUser *currentUser = [PFUser currentUser];
    NSLog(@"%@", self.note[@"author"]);
  //  NSLog(@"%@", self.note[@"author"].objectId);
    if(![currentUser[@"username"] isEqual: self.note[@"author"][@"username"]]){
        self.deletePostBtn.hidden = YES;
        self.followFriendBtn.hidden = NO;
        
    }else{
        self.deletePostBtn.hidden = NO;
        self.followFriendBtn.hidden = YES;
    }
    //set the name fields
    self.fullNameLabel.text = self.note[@"author"][@"fullName"];
    self.usernameLabel.text = self.note[@"author"][@"username"];
    NSDate *date = self.note.createdAt;
    self.timePostedLabel.text =date.shortTimeAgoSinceNow;

}

- (IBAction)followFriend:(id)sender {
    PFUser *currentUser = [PFUser currentUser];
    NSMutableArray *myFriends = [currentUser objectForKey:@"friends"];
    [myFriends addObject:self.note[@"author"]];
    currentUser[@"friends"] = myFriends;
    [currentUser saveInBackground];
    NSLog(@"friend added! ");
}

- (IBAction)removePost:(id)sender {
    [self deletionWarning:@"Action cannot be undone."];
}

- (void) deletionWarning:(NSString*) mes{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete Note"
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
                                                            [self.note deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                                                                if (!error){
                                                                    NSLog(@"deletedNote");
                                                                    PFUser *currentUser = [PFUser currentUser];
                                                                    [currentUser incrementKey:@"numNotes" byAmount:@-1];
                                                                    //save the user with updated note count
                                                                    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                                                        if(!error){
                                                                            NSLog(@"successfully decremented notesCount");
                                                                            NSLog(@"%@", currentUser[@"numNotes"]);
                                                                            //switch the viewcontroller to a new window
                                                                            SceneDelegate *appDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
                                                                            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                                                            UITabBarController *tabViewController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarController" ];
                                                                            [tabViewController setSelectedIndex:1];
                                                                            appDelegate.window.rootViewController = tabViewController;
                                                                        }
                                                                    }];
                                                                }
                                                            }];
                                                     }];
    // add the OK action to the alert controller
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:^{
        // optional code for what happens after the alert controller has finished presenting
    }];
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
