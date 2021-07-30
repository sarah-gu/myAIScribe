//
//  ClassDetailViewController.m
//  myAIScribe
//
//  Created by Sarah Wen Gu on 7/30/21.
//

#import "ClassDetailViewController.h"
#import "DetailsViewController.h"
#import "Note.h"
@import Parse;
#import "SuggestedNotesCollectionViewCell.h"

@interface ClassDetailViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation ClassDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;

    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout;
    layout.minimumInteritemSpacing = 2.5;
    layout.minimumLineSpacing = 2.5;
    
    CGFloat postsPerRow = 2;
    CGFloat itemWidth = (self.view.frame.size.width - layout.minimumInteritemSpacing * (postsPerRow - 1)) / postsPerRow;
    CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    [self.collectionView reloadData];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SuggestedNotesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ClassDetailCell" forIndexPath:indexPath];
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
    
//    if([@"detailSeguefromGroup"  isEqual: segue.identifier]){
//        UICollectionViewCell *tappedCell = sender;
//        NSIndexPath *indexPath = [self.collectionView indexPathForCell:tappedCell];
//        Note *note = self.posts[indexPath.item];
//        
//        DetailsViewController *detailsViewController = [segue destinationViewController];
//        detailsViewController.note = note;
//    }
}


@end
