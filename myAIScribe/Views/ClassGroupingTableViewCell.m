//
//  ClassGroupingTableViewCell.m
//  myAIScribe
//
//  Created by Sarah Wen Gu on 7/27/21.
//

#import "ClassGroupingTableViewCell.h"
#import "TableCollectionViewCell.h"

@implementation ClassGroupingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}

-(void) updateNoteCells {
    // Initialization code
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 2;
    
    CGFloat postersPerLine = 3;
    CGFloat itemWidth = (self.collectionView.frame.size.width / postersPerLine);
    CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    [self.collectionView reloadData];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TableCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TableCollectionViewCell" forIndexPath:indexPath];
    Note *note = self.myNotes[indexPath.item];
    PFFileObject *image = note[@"image"];
    cell.noteImage.file = image;
    [cell.noteImage loadInBackground];
//    NSURL *imageURL = [NSURL URLWithString:image.url];
//    [cell.noteImage]
   // NSLog(@"my note: %@", self.myNotes[indexPath.item]);
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"%lu", (unsigned long)self.myNotes.count);
    return self.myNotes.count;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
