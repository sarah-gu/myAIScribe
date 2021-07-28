//
//  DetailsViewController.m
//  myAIScribe
//
//  Created by Sarah Wen Gu on 7/12/21.
//

#import "DetailsViewController.h"
#import "DateTools.h"
#import "Friends.h"
@import Parse;
#import "ProfileViewController.h"
#import "SceneDelegate.h"
#import "DisplayViewController.h"

@interface DetailsViewController ()<UIScrollViewDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet PFImageView *largeImageView;
@property (weak, nonatomic) IBOutlet UIButton *fullNameBtn;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timePostedLabel;
@property (weak, nonatomic) IBOutlet UIButton *deletePostBtn;
@property (weak, nonatomic) IBOutlet UIButton *followFriendBtn;
@property (weak, nonatomic) IBOutlet UITextView *generatedCaption;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) PFUser *noteAuthor;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.generatedCaption.delegate = self;
    
    self.scrollView.delegate = self;
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.maximumZoomScale = 6.0;
    
    _note = self.note;
    self.largeImageView.file = self.note[@"image"];
    [self.largeImageView loadInBackground];
    self.generatedCaption.text = self.note[@"caption"];
    //disable or enable the delete post button
    PFUser *currentUser = [PFUser currentUser];
    NSLog(@"%@", self.note[@"author"]);
    self.noteAuthor =self.note[@"author"];
    NSLog(@"%@", [self.note[@"author"] objectId]);
    if(![currentUser.objectId isEqual: [self.note[@"author"] objectId]]) {
        self.deletePostBtn.hidden = YES;
        self.followFriendBtn.hidden = NO;
        self.generatedCaption.editable = NO;
        
    }else {
        self.deletePostBtn.hidden = NO;
        self.followFriendBtn.hidden = YES;
        self.generatedCaption.editable = YES;
    }
   // NSLog(@"following arr: %@", currentUser[@"friends"]);
    NSArray *keys = [currentUser[@"friends"] valueForKeyPath:@"objectId"];
    if([keys containsObject:[self.note[@"author"] objectId]]) {
         NSLog(@"nice");
        [self.followFriendBtn setTitle:@"Following" forState:UIControlStateNormal];
        self.followFriendBtn.enabled = NO;
    }
    NSLog(@"array: %@, currentUser: %@", keys, self.note[@"author"][@"objectId"]);

    //set the name fields
    [self.fullNameBtn setTitle:self.note[@"author"][@"fullName"] forState:UIControlStateNormal];
    self.usernameLabel.text = self.note[@"author"][@"username"];
    NSDate *date = self.note.createdAt;
    self.timePostedLabel.text =date.shortTimeAgoSinceNow;
}

- (IBAction)followFriend:(id)sender {
    PFUser *currentUser = [PFUser currentUser];
    PFUser *authorOfNote = self.note[@"author"];
    
    [Friends addNewFollowing:currentUser withFollowing:authorOfNote withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded){
            NSLog(@"new Friend created!");
        }
    }];
    
    NSMutableArray *myFriends = [currentUser objectForKey:@"friends"];
    [myFriends addObject:self.note[@"author"]];
    NSLog(@"%@", self.note[@"author"]); 
    currentUser[@"friends"] = myFriends;
    [currentUser saveInBackground];

    [self.followFriendBtn setTitle:@"Following" forState:UIControlStateNormal];
    self.followFriendBtn.enabled = NO;
   // NSLog(@"%@", authorFollowers);
    NSLog(@"friend & follower added! ");
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
- (IBAction)onTap:(id)sender {
    [self.view endEditing:true];
    [UIView animateWithDuration:0.5 animations:^{
        CGRect labelsFrame = self.generatedCaption.frame;
        labelsFrame.origin.y += 200;
        self.generatedCaption.frame = labelsFrame;
    }];
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    [UIView animateWithDuration:0.5 animations:^{
        CGRect labelsFrame = self.generatedCaption.frame;
        labelsFrame.origin.y -= 200;
        self.generatedCaption.frame = labelsFrame;
    }];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    NSLog(@"how often does this happen?");
    self.note[@"caption"] = self.generatedCaption.text;
    [self.note saveInBackground];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.largeImageView; 
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([@"detailToProfileSegue"  isEqual: segue.identifier]){        
        ProfileViewController *profileViewController = [segue destinationViewController];
        profileViewController.currentUser = self.noteAuthor;
    }
}


@end
