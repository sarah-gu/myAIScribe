//
//  ProfileViewController.m
//  myAIScribe
//
//  Created by Sarah Wen Gu on 7/21/21.
//
#import "DetailsViewController.h"
#import "FollowerViewController.h"
#import "Friends.h"
#import "Note.h"
#import "ProfileViewController.h"
@import Parse;
#import "SuggestedNotesCollectionViewCell.h"

@interface ProfileViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) NSArray *myFollowers;
@property (nonatomic, strong) NSArray *myFollowing;
@end


@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.username.text = [NSString stringWithFormat:@"@%@", self.currentUser[@"username"]];
    self.fullName.text = self.currentUser[@"fullName"];
  //  NSLog(@"%@, %@", [self.currentUser objectId]);
    
    if(self.currentUser[@"profilePicture"] == nil){
        [self.profilePicture setImage:[UIImage systemImageNamed:@"person.crop.circle"]];
    }
    else {
        self.profilePicture.file = self.currentUser[@"profilePicture"];
        [self.profilePicture loadInBackground]; 
    }
    self.profilePicture.layer.masksToBounds = YES;
    self.profilePicture.layer.cornerRadius = 37.5;
    
    self.followBtn.layer.masksToBounds = YES;
    self.followBtn.layer.cornerRadius = 18; 
    
    if([[self.currentUser objectId] isEqual:[PFUser currentUser].objectId]){
        [self.followBtn setTitle:@"Edit Info" forState:UIControlStateNormal];
    }
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout;
    layout.minimumInteritemSpacing = 2.5;
    layout.minimumLineSpacing = 2.5;
    
    CGFloat postsPerRow = 2;
    CGFloat itemWidth = (self.view.frame.size.width - layout.minimumInteritemSpacing * (postsPerRow - 1)) / postsPerRow;
    CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    PFUser *viewer = [PFUser currentUser];
    NSArray *keys = [viewer[@"friends"] valueForKeyPath:@"objectId"];
    if([keys containsObject:[self.currentUser objectId]]) {
         NSLog(@"nice");
        [self.followBtn setTitle:@"Following" forState:UIControlStateNormal];
        self.followBtn.enabled = NO;
    }
    
    [self queryMyPosts];
    [self queryFollowersCount];
    [self queryFollowingCount];
    [self.collectionView reloadData];
}

- (IBAction)followOrEditBtn:(id)sender {
    if([[self.currentUser objectId] isEqual:[PFUser currentUser].objectId]) {
        [self performSegueWithIdentifier:@"editInfoSegue" sender:nil];
    }
    else {
        PFUser *currentUser = [PFUser currentUser];
        PFUser *authorOfNote = self.currentUser;
        
        [Friends addNewFollowing:currentUser withFollowing:authorOfNote withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if(succeeded){
                NSLog(@"new Friend created!");
            }
        }];
        
        NSMutableArray *myFriends = [currentUser objectForKey:@"friends"];
        [myFriends addObject:self.currentUser];
     
        currentUser[@"friends"] = myFriends;
        [currentUser saveInBackground];

        [self.followBtn setTitle:@"Following" forState:UIControlStateNormal];
        self.followBtn.enabled = NO;
       // NSLog(@"%@", authorFollowers);
        NSLog(@"friend & follower added! ");
    }
}

- (void) queryFollowingCount {
    PFQuery *friendQuery = [PFQuery queryWithClassName:@"Friends"];
    [friendQuery whereKey:@"follower" equalTo:self.currentUser];
    friendQuery.limit = 1;
    
    [friendQuery countObjectsInBackgroundWithBlock:^(int number, NSError * _Nullable error) {
        if(!error) {
            self.following.text = [NSString stringWithFormat:@"%i", number];
        }
    }];
}

- (void) queryFollowersCount {
    PFQuery *friendQuery = [PFQuery queryWithClassName:@"Friends"];
    [friendQuery whereKey:@"following" equalTo:self.currentUser];
    friendQuery.limit = 1;
    
    [friendQuery countObjectsInBackgroundWithBlock:^(int number, NSError * _Nullable error) {
        if(!error) {
            self.followers.text = [NSString stringWithFormat:@"%i", number];
        }
    }];
}

- (void) queryMyPosts {
    PFQuery *query = [PFQuery queryWithClassName:@"Note"];
    [query orderByDescending:@"creationDate"];
    [query whereKey:@"author" equalTo:self.currentUser];
    query.limit = 30;
    [query includeKey:@"author"];

    [query findObjectsInBackgroundWithBlock:^(NSArray<Note *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            // do something with the data fetched
            self.posts = posts;
            self.numPosts.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.posts.count];
            [self.collectionView reloadData];
        }
        else {
            // handle error
        }
    }];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SuggestedNotesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SuggestedNotesCollectionViewCell" forIndexPath:indexPath];
    cell.note = self.posts[indexPath.item];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.posts.count;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([@"detailSeguefromProfile"  isEqual: segue.identifier]){
        UICollectionViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:tappedCell];
        Note *note = self.posts[indexPath.item];
        
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.note = note;
    }
    else if([@"followingSegue" isEqual: segue.identifier]){
        FollowerViewController *followerViewController = [segue destinationViewController];
        followerViewController.currentUser = self.currentUser;
        followerViewController.isFollowing = YES;
    }
    else if([@"followerSegue" isEqual: segue.identifier]){
        FollowerViewController *followerViewController = [segue destinationViewController];
        followerViewController.currentUser = self.currentUser;
        followerViewController.isFollowing = NO;
    }
}


@end

