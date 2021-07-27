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
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView reloadData]; 
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TableCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TableCollectionViewCell" forIndexPath:indexPath];
    cell.note = self.myNotes[indexPath.item];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.myNotes.count;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
