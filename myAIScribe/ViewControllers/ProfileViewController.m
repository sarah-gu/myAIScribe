//
//  ProfileViewController.m
//  myAIScribe
//
//  Created by Sarah Wen Gu on 7/21/21.
//
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
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
//    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"PostCollectionViewCell"];
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout;
        
    layout.minimumInteritemSpacing = 2.5;
    layout.minimumLineSpacing = 2.5;
    
    CGFloat postsPerRow = 3;
    CGFloat itemWidth = (self.view.frame.size.width - layout.minimumInteritemSpacing * (postsPerRow - 1)) / postsPerRow;
    CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    [self queryMyPosts];
    self.username.text = [PFUser currentUser][@"username"];
    NSLog(@"%@", self.username.text);
    [self.collectionView reloadData];
    
    
}
- (void) queryMyPosts {
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
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
    SuggestedNotesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PostCollectionViewCell" forIndexPath:indexPath];
    cell.post = self.posts[indexPath.item];

    
    return cell;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.posts.count;
    
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

