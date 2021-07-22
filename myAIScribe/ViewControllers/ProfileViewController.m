//
//  ProfileViewController.m
//  myAIScribe
//
//  Created by Sarah Wen Gu on 7/21/21.
//
#import "DetailsViewController.h"
#import "FollowerViewController.h"
#import "Note.h"
#import "ProfileViewController.h"
@import Parse;
#import "SuggestedNotesCollectionViewCell.h"

@interface ProfileViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@end


@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.username.text = self.currentUser[@"username"];
    NSLog(@"%@", self.username.text);
    if(self.currentUser == [PFUser currentUser]){
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
    
    [self queryMyPosts];
    [self.collectionView reloadData];
}

- (void) queryMyPosts {
    PFQuery *query = [PFQuery queryWithClassName:@"Note"];
    [query orderByDescending:@"creationDate"];
    [query whereKey:@"author" equalTo:[PFUser currentUser]];
    query.limit = 20;

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
    else if([@"followerSegue" isEqual: segue.identifier]){
        FollowerViewController *followerViewController = [segue destinationViewController];
        followerViewController.currentUser = [PFUser currentUser];
    }
}


@end

